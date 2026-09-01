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
CANONICAL_CATEGORIES = CATEGORIES

# IST Timezone (UTC + 5:30)
IST_TZ = datetime.timezone(datetime.timedelta(hours=5, minutes=30))

def get_today_date_str() -> str:
    """Returns today's date in IST (UTC+5:30) so morning editions match the local calendar date."""
    return datetime.datetime.now(IST_TZ).date().isoformat()

def clean_html(raw_html: str) -> str:
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
                    content_encoded = item.findtext('{http://purl.org/rss/1.0/modules/content/}encoded')
                    desc = content_encoded or item.findtext('description') or ''
                    pub_date = item.findtext('pubDate') or datetime.datetime.now().isoformat()
                    
                    if title and link:
                        items.append({
                            'source': source_name,
                            'category': category,
                            'headline': clean_html(title),
                            'url': link.strip(),
                            'content': clean_html(desc)[:2000],
                            'published_at': pub_date
                        })
            else:
                # Atom feed (feed/entry)
                ns = {'atom': 'http://www.w3.org/2005/Atom'}
                for entry in root.findall('atom:entry', ns)[:max_items]:
                    title = entry.findtext('atom:title', namespaces=ns) or ''
                    link_elem = entry.find('atom:link', namespaces=ns)
                    link = link_elem.attrib.get('href', '') if link_elem is not None else ''
                    content_val = entry.findtext('atom:content', namespaces=ns)
                    summary = content_val or entry.findtext('atom:summary', namespaces=ns) or ''
                    pub_date = entry.findtext('atom:published', namespaces=ns) or entry.findtext('atom:updated', namespaces=ns) or datetime.datetime.now().isoformat()
                    
                    if title and link:
                        items.append({
                            'source': source_name,
                            'category': category,
                            'headline': clean_html(title),
                            'url': link.strip(),
                            'content': clean_html(summary)[:2000],
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

def fetch_dev_to_top(max_items: int = 3):
    """Fetches top trending technical articles from the free DEV.to Community REST API."""
    items = []
    try:
        url = f"https://dev.to/api/articles?per_page={max_items}&top=1"
        req = urllib.request.Request(url, headers={"User-Agent": "TechDailyBot/1.0"})
        with urllib.request.urlopen(req, timeout=10) as resp:
            articles = json.loads(resp.read().decode('utf-8'))
            for art in articles:
                title = art.get('title', '')
                link = art.get('url', '')
                desc = art.get('description', '')
                if title and link:
                    items.append({
                        'source': 'DEV Community',
                        'category': 'DEVELOPERS',
                        'headline': clean_html(title),
                        'url': link,
                        'content': clean_html(desc),
                        'published_at': art.get('published_at', datetime.datetime.now().isoformat())
                    })
    except Exception as e:
        print(f"  [Warning] Failed to fetch DEV.to: {e}")
    return items

def fetch_full_article_content(url: str, jina_api_key: str = None) -> str:
    """Uses Jina Reader open API (r.jina.ai) to extract clean full-text journalistic article body."""
    if not url or not url.startswith("http"):
        return ""
    jina_url = f"https://r.jina.ai/{url}"
    headers = {
        "User-Agent": "TechDailyBot/1.0",
        "Accept": "text/plain",
        "X-Return-Format": "text"
    }
    if jina_api_key:
        headers["Authorization"] = f"Bearer {jina_api_key}"
        
    try:
        req = urllib.request.Request(jina_url, headers=headers)
        with urllib.request.urlopen(req, timeout=10) as resp:
            raw_text = resp.read().decode('utf-8', errors='ignore')
            clean_body = re.sub(r'\s+', ' ', raw_text).strip()
            # Return top 2,500 characters of rich substantive journalism
            if len(clean_body) > 250:
                return clean_body[:2500]
    except Exception:
        # Graceful fallback to original RSS summary
        pass
    return ""

def select_top_candidates(raw_articles, max_per_category: int = 2):
    categorized = {}
    for item in raw_articles:
        cat = item['category']
        categorized.setdefault(cat, []).append(item)
        
    selected = []
    for cat in CANONICAL_CATEGORIES:
        items = categorized.get(cat, [])
        selected.extend(items[:max_per_category])
    return selected

def synthesize_with_gemini(raw_articles, api_key: str):
    """Uses Google Gemini 1.5 Flash API to deeply structure tech news into Tech Daily newspaper format."""
    print("Synthesizing edition using Gemini 1.5 Flash with deep technical prompt...")
    endpoint = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key={api_key}"
    
    candidates = select_top_candidates(raw_articles, max_per_category=2)
    jina_key = os.environ.get("JINA_API_KEY", "").strip() or None
    print("Enriching candidate stories with full-text journalism via Jina Reader...")
    for item in candidates:
        full_text = fetch_full_article_content(item['url'], jina_key)
        if full_text and len(full_text) > len(item.get('content', '')):
            item['content'] = full_text
            print(f"  + Full-text extracted for: {item['headline'][:40]}... ({len(full_text)} chars)")
    
    prompt = f"""You are the Senior Technical Editor of 'Tech Daily', a prestigious, calm daily broadsheet newspaper (like the Financial Times or MIT Tech Review, but for software engineers and technology leaders).

Below are the candidate technical announcements, research releases, and engineering blog posts collected from today:
{json.dumps(candidates, indent=2)}

Synthesize a deeply informative, rigorous, authoritative daily edition JSON object.

STRICT EDITORIAL REQUIREMENTS (MUST FOLLOW):
1. ZERO REPETITION: Every single story MUST have unique, specific, article-grounded key points. Never repeat boilerplate phrases like "addresses key challenges", "documented and released", or "available immediately".
2. DEEP TECHNICAL PRECISION:
   - Include specific model names, version numbers, benchmarks (e.g., 35% speedup, 10x throughput, 128k context), architecture designs, protocols, CVE IDs, or specific languages/frameworks mentioned in each article.
3. KEY POINTS (MANDATORY EXACTLY 3 BULLETS PER STORY):
   - Point 1: Specific Problem / Bottleneck — Detail the exact limitation, failure mode, vulnerability, or scaling bottleneck that prompted this work.
   - Point 2: Architecture / Technical Solution — Detail how engineers solved it, mentioning the stack, data structures, algorithms, or protocol changes.
   - Point 3: Real-World Benchmarks & Impact — Detail the measured performance gain, migration requirements, open-source license, or production availability.
4. SUMMARY (WHAT HAPPENED): Two dense, factual, authoritative sentences explaining the exact technical event.
5. WHY IT MATTERS: A 1-2 sentence strategic analysis of why this matters to the broader software and infrastructure industry.

Output schema:
{{
  "title": "Tech Daily",
  "date": "{get_today_date_str()}",
  "hot_topic": "2-4 WORDS (e.g. REASONING INFERENCE ACCELERATION)",
  "hot_topic_description": "2-3 comprehensive sentences explaining the overarching industry trend today.",
  "biggest_story": {{
    "id": "story_hero",
    "category": "<ONE OF: AI & MACHINE LEARNING, DEVELOPERS, BIG TECH, STARTUPS, CYBERSECURITY, CLOUD, TECHNOLOGY RESEARCH, TECHNOLOGY AROUND THE WORLD>",
    "headline": "<Crisp, authoritative headline>",
    "summary": "<Dense 2-sentence technical summary of what happened>",
    "why_it_matters": "<Strategic impact analysis>",
    "key_points": [
      "<Specific Problem/Bottleneck with technical details>",
      "<Specific Implementation/Architecture details>",
      "<Specific Benchmark/Performance metrics or developer impact>"
    ],
    "importance": 10,
    "sources": [{{"name": "<Source Name>", "url": "<Source URL>"}}]
  }},
  "stories": [
    {{
      "id": "story_1",
      "category": "<Canonical category>",
      "headline": "<Crisp, authoritative headline>",
      "summary": "<Dense 2-sentence technical summary of what happened>",
      "why_it_matters": "<Strategic impact analysis>",
      "key_points": [
        "<Specific Problem/Bottleneck with technical details>",
        "<Specific Implementation/Architecture details>",
        "<Specific Benchmark/Performance metrics or developer impact>"
      ],
      "importance": 8,
      "sources": [{{"name": "<Source Name>", "url": "<Source URL>"}}]
    }}
  ]
}}
Return ONLY raw valid JSON. Do not include markdown code fences or backticks.
"""
    payload = {
        "contents": [{"parts": [{"text": prompt}]}],
        "generationConfig": {
            "temperature": 0.2,
            "maxOutputTokens": 8192,
            "responseMimeType": "application/json"
        }
    }
    
    try:
        req = urllib.request.Request(
            endpoint,
            data=json.dumps(payload).encode('utf-8'),
            headers={"Content-Type": "application/json"}
        )
        with urllib.request.urlopen(req, timeout=60) as resp:
            res = json.loads(resp.read().decode('utf-8'))
            text_content = res['candidates'][0]['content']['parts'][0]['text'].strip()
            
            # Clean markdown code fences if model enclosed them
            if text_content.startswith("```json"):
                text_content = text_content[7:]
            elif text_content.startswith("```"):
                text_content = text_content[3:]
            if text_content.endswith("```"):
                text_content = text_content[:-3]
            text_content = text_content.strip()
            
            parsed_edition = json.loads(text_content)
            
            # Verify required schema
            if 'stories' in parsed_edition and parsed_edition.get('biggest_story'):
                print(f"  Successfully synthesized {len(parsed_edition['stories']) + 1} stories with Gemini 1.5 Flash!")
                return parsed_edition
            else:
                print("  [Warning] Output missing required fields, falling back to local extractor...")
                return synthesize_locally(raw_articles)
    except Exception as e:
        print(f"  [Warning] Gemini API call encountered error: {e}")
        print("  Falling back to built-in editorial structuring engine...")
        return synthesize_locally(raw_articles)

def synthesize_locally(raw_articles):
    """Deep local natural-language extractor when Gemini API is not configured or offline."""
    print("Synthesizing edition locally with dynamic technical extraction...")
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
        
        # Split into distinct sentences of substance
        raw_sentences = [s.strip() for s in re.split(r'\. |\n', content) if len(s.strip()) > 25]
        
        # 1. WHAT HAPPENED: First 1-2 factual sentences
        if len(raw_sentences) >= 2:
            what_happened = f"{raw_sentences[0]}. {raw_sentences[1]}."
        elif raw_sentences:
            what_happened = f"{raw_sentences[0]}."
        else:
            what_happened = f"{headline} announced by {source}."
            
        # 2. WHY IT MATTERS: Strategic context
        if len(raw_sentences) >= 3:
            why_it_matters = f"{raw_sentences[2]}. This marks a notable development for engineering teams working in {category.lower()}."
        else:
            why_it_matters = f"Significantly impacts {category.lower()} workflows, altering how developers deploy and maintain scalable software architectures."
            
        # 3. KEY POINTS: Dynamically extract unique technical facts per article
        tech_sentences = [
            s for s in raw_sentences
            if any(term in s.lower() for term in ['model', 'api', 'performance', 'security', 'data', 'feature', 'system', 'build', 'version', 'support', 'tool', 'scale', 'cloud', 'latency', 'cve', 'code', 'users', 'benchmark', '%'])
        ]
        
        points = []
        if len(tech_sentences) >= 1:
            points.append(f"Problem & Context: {tech_sentences[0]}.")
        else:
            points.append(f"Problem & Context: {source} focuses on solving key constraints regarding {headline.lower()}.")
            
        if len(tech_sentences) >= 2:
            points.append(f"Technical Implementation: {tech_sentences[1]}.")
        elif len(raw_sentences) >= 2:
            points.append(f"Technical Implementation: {raw_sentences[1]}.")
        else:
            points.append(f"Technical Implementation: Integrates specialized engineering patterns released for {category.title()}.")
            
        if len(tech_sentences) >= 3:
            points.append(f"Deployment & Impact: {tech_sentences[2]}.")
        elif len(raw_sentences) >= 3:
            points.append(f"Deployment & Impact: {raw_sentences[2]}.")
        else:
            points.append(f"Deployment & Impact: Published by {source} with documentation and production rollout details.")
            
        # Clean double periods and whitespace
        points = [re.sub(r'\.\.+', '.', p).strip() for p in points]
        what_happened = re.sub(r'\.\.+', '.', what_happened).strip()
        why_it_matters = re.sub(r'\.\.+', '.', why_it_matters).strip()
        
        stories.append({
            'id': f"story_live_{story_counter}",
            'category': category,
            'headline': headline,
            'summary': what_happened,
            'why_it_matters': why_it_matters,
            'key_points': points,
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
                
    # Also fetch Hacker News & DEV Community
    hn_items = fetch_hacker_news_top(max_items=3)
    print(f"  + [STARTUPS] Hacker News Top: {len(hn_items)} stories found")
    all_raw_articles.extend(hn_items)

    dev_items = fetch_dev_to_top(max_items=3)
    print(f"  + [DEVELOPERS] DEV Community: {len(dev_items)} articles found")
    all_raw_articles.extend(dev_items)
    
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
