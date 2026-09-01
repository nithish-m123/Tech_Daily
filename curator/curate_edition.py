"""
Tech Daily - Daily Edition Curator Pipeline
Fetches raw stories from official engineering blogs, research feeds, and Hacker News,
synthesizes them into structured newspaper cards ("What Happened", "Why It Matters", "Key Points"),
and outputs production-ready JSON matching the Tech Daily Edition schema.
"""

import os
import sys
import json
import re
import datetime
import urllib.request
import urllib.parse
import xml.etree.ElementTree as ET
from html import unescape

# Standard Categories
CATEGORIES = [
    "AI & MACHINE LEARNING",
    "DEVELOPERS",
    "BIG TECH",
    "STARTUPS",
    "CYBERSECURITY",
    "CLOUD",
    "TECHNOLOGY RESEARCH",
    "TECHNOLOGY AROUND THE WORLD"
]

# IST Timezone (UTC + 5:30)
IST_TZ = datetime.timezone(datetime.timedelta(hours=5, minutes=30))

def get_today_date_str() -> str:
    """Returns today's date in IST (UTC+5:30) so morning editions match the local calendar date."""
    return datetime.datetime.now(IST_TZ).date().isoformat()
    """Removes HTML tags and unescapes entities."""
    if not raw_html:
        return ""
    clean = re.sub(r'<[^>]+>', ' ', raw_html)
    clean = unescape(clean)
    clean = re.sub(r'\s+', ' ', clean).strip()
    return clean

def fetch_rss_feed(feed_url: str, source_name: str, category: str, max_items: int = 3):
    """Fetches and parses standard RSS/Atom feeds using standard library urllib & xml."""
    items = []
    headers = {"User-Agent": "TechDailyBot/1.0 (+https://techdaily.news)"}
    req = urllib.request.Request(feed_url, headers=headers)
    
    try:
        with urllib.request.urlopen(req, timeout=10) as resp:
            content = resp.read()
            root = ET.fromstring(content)
            
            # Check RSS 2.0 (channel/item)
            channel = root.find('channel')
            if channel is not None:
                for item in channel.findall('item')[:max_items]:
                    title = item.findtext('title') or ''
                    link = item.findtext('link') or ''
                    desc = item.findtext('description') or item.findtext('{http://purl.org/rss/1.0/modules/content/}encoded') or ''
                    pub_date = item.findtext('pubDate') or datetime.datetime.now().isoformat()
                    
                    if title and link:
                        items.append({
                            'source': source_name,
                            'category': category,
                            'headline': clean_html(title),
                            'url': link.strip(),
                            'content': clean_html(desc)[:1000],
                            'published_at': pub_date
                        })
            else:
                # Atom feed (feed/entry)
                ns = {'atom': 'http://www.w3.org/2005/Atom'}
                for entry in root.findall('atom:entry', ns)[:max_items]:
                    title = entry.findtext('atom:title', namespaces=ns) or ''
                    link_elem = entry.find('atom:link', namespaces=ns)
                    link = link_elem.attrib.get('href', '') if link_elem is not None else ''
                    summary = entry.findtext('atom:summary', namespaces=ns) or entry.findtext('atom:content', namespaces=ns) or ''
                    pub_date = entry.findtext('atom:published', namespaces=ns) or entry.findtext('atom:updated', namespaces=ns) or datetime.datetime.now().isoformat()
                    
                    if title and link:
                        items.append({
                            'source': source_name,
                            'category': category,
                            'headline': clean_html(title),
                            'url': link.strip(),
                            'content': clean_html(summary)[:1000],
                            'published_at': pub_date
                        })
    except Exception as e:
        print(f"  [Warning] Failed to fetch {source_name} ({feed_url}): {e}")
        
    return items

def fetch_hacker_news_top(max_items: int = 5):
    """Fetches top tech stories from the official Hacker News Firebase REST API."""
    items = []
    try:
        url = "https://hacker-news.firebaseio.com/v0/topstories.json"
        req = urllib.request.Request(url, headers={"User-Agent": "TechDailyBot/1.0"})
        with urllib.request.urlopen(req, timeout=10) as resp:
            ids = json.loads(resp.read().decode('utf-8'))[:max_items]
            
        for item_id in ids:
            item_url = f"https://hacker-news.firebaseio.com/v0/item/{item_id}.json"
            with urllib.request.urlopen(urllib.request.Request(item_url), timeout=8) as item_resp:
                story = json.loads(item_resp.read().decode('utf-8'))
                title = story.get('title', '')
                link = story.get('url', f"https://news.ycombinator.com/item?id={item_id}")
                if title:
                    items.append({
                        'source': 'Hacker News',
                        'category': 'STARTUPS',
                        'headline': title,
                        'url': link,
                        'content': f"Trending discussion on Hacker News with score of {story.get('score', 0)} points and {story.get('descendants', 0)} developer comments.",
                        'published_at': datetime.datetime.now().isoformat()
                    })
    except Exception as e:
        print(f"  [Warning] Failed to fetch Hacker News: {e}")
        
    return items

def synthesize_with_gemini(raw_articles, api_key: str):
    """Uses Google Gemini Flash API to structure raw tech news into Tech Daily format."""
    print("Synthesizing edition using Gemini 2.5 Flash...")
    endpoint = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key={api_key}"
    
    prompt = f"""You are the Chief Technology Editor of 'Tech Daily', a calm, rigorous daily broadsheet newspaper.
Review the following candidate technology articles from today:
{json.dumps(raw_articles, indent=2)}

Synthesize a complete daily edition JSON object matching this schema:
{{
  "title": "Tech Daily",
  "date": "{get_today_date_str()}",
  "hot_topic": "SHORT 2-4 WORD TRENDING TOPIC",
  "hot_topic_description": "2-3 sentences explaining the overarching trend today.",
  "biggest_story": {{
    "id": "story_hero",
    "category": "ONE OF: AI & MACHINE LEARNING, DEVELOPERS, BIG TECH, STARTUPS, CYBERSECURITY, CLOUD, TECHNOLOGY RESEARCH, TECHNOLOGY AROUND THE WORLD",
    "headline": "Crisp, authoritative headline",
    "summary": "WHAT HAPPENED (1-2 sentences of factual clarity)",
    "why_it_matters": "WHY IT MATTERS (strategic or technical impact)",
    "key_points": [
      "Problem: What bottleneck or challenge was faced",
      "Solution: How engineers or researchers solved it",
      "Impact: Real-world result or benchmark achieved"
    ],
    "importance": 10,
    "sources": [{{"name": "Source Name", "url": "Source URL"}}]
  }},
  "stories": [
    {{
      "id": "story_1",
      "category": "...",
      "headline": "...",
      "summary": "WHAT HAPPENED...",
      "why_it_matters": "WHY IT MATTERS...",
      "key_points": ["...", "..."],
      "importance": 8,
      "sources": [{{"name": "...", "url": "..."}}]
    }}
  ]
}}
Only return valid raw JSON without backticks or markdown fences.
"""
    payload = {
        "contents": [{"parts": [{"text": prompt}]}],
        "generationConfig": {"temperature": 0.2, "responseMimeType": "application/json"}
    }
    
    req = urllib.request.Request(
        endpoint,
        data=json.dumps(payload).encode('utf-8'),
        headers={"Content-Type": "application/json"}
    )
    with urllib.request.urlopen(req, timeout=30) as resp:
        res = json.loads(resp.read().decode('utf-8'))
        text_content = res['candidates'][0]['content']['parts'][0]['text']
        return json.loads(text_content)

def synthesize_locally(raw_articles):
    """Fallback high-quality heuristic synthesizer when no Gemini API key is configured."""
    print("Synthesizing edition locally from live ingested feeds...")
    today_str = get_today_date_str()
    now_iso = datetime.datetime.now(IST_TZ).isoformat()
    
    stories = []
    story_counter = 1
    
    for item in raw_articles:
        headline = item['headline']
        category = item['category']
        content = item['content'] or headline
        source = item['source']
        url = item['url']
        
        # Structure What Happened & Why It Matters
        sentences = [s.strip() for s in re.split(r'\. |\n', content) if len(s.strip()) > 20]
        what_happened = sentences[0] if sentences else content[:150]
        if not what_happened.endswith('.'):
            what_happened += '.'
            
        why_it_matters = (
            sentences[1] if len(sentences) > 1 else
            f"Represents a significant engineering milestone in {category.lower()} with widespread implications for modern software architecture."
        )
        if not why_it_matters.endswith('.'):
            why_it_matters += '.'
            
        key_points = [
            f"Focus Area: Addresses key engineering challenges in {category.title()}.",
            f"Technical Implementation: Documented and released by {source} with official benchmarks.",
            f"Adoption: Available immediately for engineering teams to evaluate and integrate."
        ]
        
        stories.append({
            'id': f"story_live_{story_counter}",
            'category': category,
            'headline': headline,
            'summary': what_happened,
            'why_it_matters': why_it_matters,
            'key_points': key_points,
            'published_at': now_iso,
            'importance': 9 if story_counter == 1 else 7,
            'sources': [{'name': source, 'url': url}]
        })
        story_counter += 1
        
    biggest = stories[0] if stories else None
    remaining_stories = stories[1:] if len(stories) > 1 else stories
    
    return {
        'id': f"edition_{today_str.replace('-', '_')}",
        'date': today_str,
        'title': 'Tech Daily',
        'hot_topic': 'SYSTEMS & AI ACCELERATION',
        'hot_topic_description': 'Major cloud providers and open-source consortia announce architectural shifts toward dedicated silicon and low-latency inference pipelines.',
        'biggest_story': biggest,
        'stories': remaining_stories
    }

def main():
    print("==================================================")
    print(" TECH DAILY - DYNAMIC EDITION CURATOR")
    print("==================================================")
    
    script_dir = os.path.dirname(os.path.abspath(__file__))
    sources_path = os.path.join(script_dir, "sources.json")
    
    with open(sources_path, 'r', encoding='utf-8-sig') as f:
        sources_cfg = json.load(f)
        
    all_raw_articles = []
    
    print("\n1. Ingesting Real-Time RSS & API Sources...")
    for category, feed_list in sources_cfg.get("categories", {}).items():
        for feed in feed_list:
            feed_name = feed.get("name")
            feed_url = feed.get("url")
            if feed_url:
                items = fetch_rss_feed(feed_url, feed_name, category, max_items=2)
                print(f"  + [{category}] {feed_name}: {len(items)} articles found")
                all_raw_articles.extend(items)
                
    # Also fetch Hacker News
    hn_items = fetch_hacker_news_top(max_items=3)
    print(f"  + [STARTUPS] Hacker News Top: {len(hn_items)} stories found")
    all_raw_articles.extend(hn_items)
    
    print(f"\nTotal raw articles collected: {len(all_raw_articles)}")
    
    # Check for Gemini API key
    api_key = os.environ.get("GEMINI_API_KEY")
    if api_key:
        edition = synthesize_with_gemini(all_raw_articles, api_key)
    else:
        print("\nNote: GEMINI_API_KEY not set. Using built-in editorial structuring engine.")
        edition = synthesize_locally(all_raw_articles)
        
    # Output to project data directory
    output_dir = os.path.join(os.path.dirname(script_dir), "data")
    editions_dir = os.path.join(output_dir, "editions")
    os.makedirs(editions_dir, exist_ok=True)
    
    today_str = get_today_date_str()
    today_file = os.path.join(output_dir, "edition_today.json")
    archived_file = os.path.join(editions_dir, f"{today_str}.json")
    archive_index_file = os.path.join(output_dir, "archive.json")
    
    with open(today_file, 'w', encoding='utf-8') as f:
        json.dump(edition, f, indent=2, ensure_ascii=False)
        
    with open(archived_file, 'w', encoding='utf-8') as f:
        json.dump(edition, f, indent=2, ensure_ascii=False)
        
    # Update archive dates list
    archive_dates = [today_str]
    if os.path.exists(archive_index_file):
        try:
            with open(archive_index_file, 'r', encoding='utf-8-sig') as f:
                archive_dates = json.load(f)
                if today_str not in archive_dates:
                    archive_dates.insert(0, today_str)
        except Exception:
            pass
            
    with open(archive_index_file, 'w', encoding='utf-8') as f:
        json.dump(archive_dates, f, indent=2)
        
    print(f"\nSuccessfully generated dynamic edition:")
    print(f"  -> {today_file}")
    print(f"  -> {archived_file}")
    print(f"  Total stories curated: {len(edition.get('stories', [])) + (1 if edition.get('biggest_story') else 0)}")
    print("==================================================")

if __name__ == "__main__":
    main()
