import '../domain/edition.dart';
import '../../story/domain/story.dart';
import '../../story/domain/source.dart';
import '../../../core/constants/app_constants.dart';
import 'edition_repository.dart';

class MockEditionRepository implements EditionRepository {
  final Duration latency;

  MockEditionRepository({this.latency = const Duration(milliseconds: 250)});

  @override
  Future<Edition> getTodayEdition() async {
    if (latency > Duration.zero) {
      await Future.delayed(latency);
    }
    return _generateTodayEdition();
  }

  @override
  Future<Edition> getEdition(DateTime date) async {
    if (latency > Duration.zero) {
      await Future.delayed(latency);
    }
    return _generateArchiveEdition(date);
  }

  @override
  Future<List<DateTime>> getArchiveDates() async {
    if (latency > Duration.zero) {
      await Future.delayed(latency);
    }
    final now = DateTime.now();
    return List.generate(7, (i) => now.subtract(Duration(days: i + 1)));
  }

  Edition _generateTodayEdition() {
    final now = DateTime.now();

    final biggestStory = Story(
      id: 'story_hero_01',
      category: AppConstants.catAi,
      headline: 'Next-Generation Autonomous Reasoning Agents Transform Enterprise Software Workflows',
      summary:
          'OpenAI and leading research consortia have officially rolled out next-generation reasoning architectures capable of multi-step autonomous planning, self-verification, and deterministic sandbox tool execution without human intervention.',
      whyItMatters:
          'This transition marks the evolution from probabilistic chat completions to deterministic cognitive automation. Enterprises can now automate end-to-end engineering tasks, data pipelines, and compliance verification with verifiable traceability.',
      keyPoints: [
        'New inference architectures integrate dynamic tree-of-thought verification with sub-100ms step validation.',
        'Early enterprise benchmarks demonstrate a 64% reduction in manual code refactoring and migration hours.',
        'Built-in cryptographic audit trails ensure every autonomous decision and tool invocation is tamper-proof.',
        'Initial deployment is launching immediately across selected healthcare, fintech, and cloud infrastructure partners.',
      ],
      publishedAt: now.subtract(const Duration(hours: 2)),
      importance: 10,
      estimatedReadMinutes: 3,
      sources: const [
        Source(name: 'Reuters', url: 'https://reuters.com'),
        Source(name: 'Ars Technica', url: 'https://arstechnica.com'),
        Source(name: 'The Verge', url: 'https://theverge.com'),
        Source(name: 'TechCrunch', url: 'https://techcrunch.com'),
      ],
    );

    final stories = <Story>[
      // AI & MACHINE LEARNING
      Story(
        id: 'ai_01',
        category: AppConstants.catAi,
        headline: 'Open-Weight 70B Models Reach Parity With Closed Frontier Architectures on Reasoning Benchmarks',
        summary:
          'A collaborative open-source collective released an optimized 70-billion parameter foundation model trained with synthetically verified mathematical reasoning traces, matching proprietary commercial models on standard SWE-bench tests.',
        whyItMatters:
          'Startups and security-conscious enterprises can now run frontier-tier intelligence entirely on-premise without exposing sensitive IP or paying steep API egress fees.',
        keyPoints: [
          'Evaluated at 78.4% on SWE-bench verified tasks using 4-bit quantization.',
          'Permissive Apache 2.0 license grants unrestricted commercial deployment.',
          'Consumes 40% less memory bandwidth through optimized flash-attention kernels.',
        ],
        publishedAt: now.subtract(const Duration(hours: 3)),
        importance: 8,
        estimatedReadMinutes: 2,
        sources: const [
          Source(name: 'Hugging Face Blog', url: 'https://huggingface.co/blog'),
          Source(name: 'VentureBeat', url: 'https://venturebeat.com'),
        ],
      ),
      Story(
        id: 'ai_02',
        category: AppConstants.catAi,
        headline: 'Neuromorphic Silicon Delivers 100x Efficiency Boost for Edge AI Inference',
        summary:
          'Semiconductor researchers in Zurich demonstrated event-based spiking neural network processors that execute audio and visual classification tasks using less than 50 microwatts of continuous power.',
        whyItMatters:
          'Enables truly continuous, battery-powered ambient machine intelligence on wearables, medical implants, and remote sensor arrays without sleep-wake latency.',
        keyPoints: [
          'Spiking neural networks activate only upon detecting physical state changes in incoming sensor feeds.',
          'Achieved 99.1% keyword spotting accuracy while operating on ambient light harvesting cells.',
        ],
        publishedAt: now.subtract(const Duration(hours: 4)),
        importance: 7,
        estimatedReadMinutes: 2,
        sources: const [
          Source(name: 'IEEE Spectrum', url: 'https://spectrum.ieee.org'),
          Source(name: 'Nature Electronics', url: 'https://nature.com'),
        ],
      ),
      Story(
        id: 'ai_03',
        category: AppConstants.catAi,
        headline: 'Federated Training Protocols Enable Multi-Hospital Diagnostic Model Convergence Without Data Sharing',
        summary:
          'A network of thirty international oncology centers completed training an early tumor detection system utilizing differential privacy and zero-knowledge proofs, achieving consensus without transferring a single patient record.',
        whyItMatters:
          'Resolves cross-border regulatory stalemates that previously prevented global clinical datasets from training lifesaving clinical diagnostic algorithms.',
        keyPoints: [
          'Zero medical imaging bytes crossed institutional firewall boundaries.',
          'Model accuracy exceeded individual hospital-specific classifiers by 19.3%.',
        ],
        publishedAt: now.subtract(const Duration(hours: 5)),
        importance: 8,
        estimatedReadMinutes: 2,
        sources: const [
          Source(name: 'Lancet Digital Health', url: 'https://thelancet.com'),
          Source(name: 'Wired', url: 'https://wired.com'),
        ],
      ),
      Story(
        id: 'ai_04',
        category: AppConstants.catAi,
        headline: 'Anthropic Unveils Mechanistic Interpretability Tool for Circuit-Level LLM Debugging',
        summary:
          'A newly published interactive suite allows researchers to visualize latent representations and pinpoint the exact computational attention circuits responsible for hallucinations and fact retrieval.',
        whyItMatters:
          'Brings engineers closer to treating foundation models like inspectable, deterministic compiled binaries rather than opaque black boxes.',
        keyPoints: [
          'Maps 16,000 distinct semantic features to sparse autoencoder dictionaries.',
          'Allows developers to mechanically clamp or ablate steering vectors in real time.',
        ],
        publishedAt: now.subtract(const Duration(hours: 6)),
        importance: 7,
        estimatedReadMinutes: 3,
        sources: const [
          Source(name: 'Anthropic Research', url: 'https://anthropic.com/research'),
          Source(name: 'MIT Tech Review', url: 'https://technologyreview.com'),
        ],
      ),

      // DEVELOPERS
      Story(
        id: 'dev_01',
        category: AppConstants.catDev,
        headline: 'Dart & Flutter Release Native SIMD Acceleration and Instant Hot Reload Engine',
        summary:
          'The Flutter team announced a major compiler upgrade delivering direct vectorized SIMD math operations on modern ARM and x86 chips, reducing frame drop rates on animation-heavy UIs by over 70%.',
        whyItMatters:
          'Cross-platform mobile applications now match hand-tuned native C++ graphics performance, eliminating the micro-stutter occasionally observed during complex nested gestures.',
        keyPoints: [
          'Impeller graphics backend now defaults across all mobile and desktop targets.',
          'Zero-copy texture sharing dramatically improves video pipeline rendering speeds.',
          'Hot reload turnaround dropped to an average of 180 milliseconds on complex multi-module apps.',
        ],
        publishedAt: now.subtract(const Duration(hours: 3)),
        importance: 9,
        estimatedReadMinutes: 2,
        sources: const [
          Source(name: 'Flutter Dev Blog', url: 'https://flutter.dev'),
          Source(name: 'InfoQ', url: 'https://infoq.com'),
        ],
      ),
      Story(
        id: 'dev_02',
        category: AppConstants.catDev,
        headline: 'Rust Foundation Adopts Formal Verification Standard for Safety-Critical Crates',
        summary:
          'The Rust language steering committee ratified a verification framework integrating mathematical proof annotations into the cargo packaging pipeline for aerospace and automotive systems.',
        whyItMatters:
          'Developers building embedded kernels and high-frequency trading engines can now prove deadlock-freedom and absence of panic branches at compile time.',
        keyPoints: [
          'Direct integration with SMT solvers during release profile builds.',
          'Backed by automotive safety consortiums replacing legacy MISRA C codebases.',
        ],
        publishedAt: now.subtract(const Duration(hours: 4)),
        importance: 8,
        estimatedReadMinutes: 2,
        sources: const [
          Source(name: 'Rust Blog', url: 'https://blog.rust-lang.org'),
          Source(name: 'ZDNet', url: 'https://zdnet.com'),
        ],
      ),
      Story(
        id: 'dev_03',
        category: AppConstants.catDev,
        headline: 'WebAssembly 3.0 Standard Adds Garbage Collection and Native Multithreading Threads',
        summary:
          'W3C ratified the Wasm 3.0 specification, standardizing high-speed garbage collection integration and shared memory atomics for browser and serverless runtimes.',
        whyItMatters:
          'Languages like Go, Java, and Dart can now compile to tiny, lightning-fast WebAssembly modules without bundling heavy custom GC runtimes.',
        keyPoints: [
          'Reduces binary payload sizes by up to 55% for managed language targets.',
          'Enables high-performance client-side image and video editing without native plugins.',
        ],
        publishedAt: now.subtract(const Duration(hours: 5)),
        importance: 7,
        estimatedReadMinutes: 2,
        sources: const [
          Source(name: 'W3C Announcement', url: 'https://w3.org'),
          Source(name: 'The New Stack', url: 'https://thenewstack.io'),
        ],
      ),
      Story(
        id: 'dev_04',
        category: AppConstants.catDev,
        headline: 'GitHub Introduces Ephemeral Isolated Testing Sandboxes for Pull Requests',
        summary:
          'A new continuous integration feature automatically spins up ephemeral microVM staging environments within 2 seconds for every incoming pull request with full branch replication.',
        whyItMatters:
          'Eliminates the "works on my machine" triage dilemma and enables visual product reviews directly from code review comments.',
        keyPoints: [
          'Pre-warms lightweight Linux firecracker microVM containers.',
          'Automatic teardown after PR merge or 24 hours of inactivity prevents cloud waste.',
        ],
        publishedAt: now.subtract(const Duration(hours: 7)),
        importance: 6,
        estimatedReadMinutes: 2,
        sources: const [
          Source(name: 'GitHub Universe', url: 'https://github.blog'),
          Source(name: 'DevClass', url: 'https://devclass.com'),
        ],
      ),

      // BIG TECH
      Story(
        id: 'tech_01',
        category: AppConstants.catBigTech,
        headline: 'Apple Expands On-Device Private Cloud Compute to Global Developer Ecosystem',
        summary:
          'Apple published the cryptographic toolchain allowing third-party applications to run distributed server-side AI requests with identical verifiable privacy guarantees as its native apps.',
        whyItMatters:
          'Sets a new industry benchmark for zero-knowledge cloud computation where server administrators cannot inspect transmitted user payloads.',
        keyPoints: [
          'External security researchers can inspect cryptographically signed boot logs for every cluster.',
          'Data is processed solely in volatile RAM with immediate memory scrubbing upon completion.',
        ],
        publishedAt: now.subtract(const Duration(hours: 3)),
        importance: 9,
        estimatedReadMinutes: 2,
        sources: const [
          Source(name: 'Apple Security Research', url: 'https://security.apple.com'),
          Source(name: 'Bloomberg', url: 'https://bloomberg.com'),
          Source(name: '9to5Mac', url: 'https://9to5mac.com'),
        ],
      ),
      Story(
        id: 'tech_02',
        category: AppConstants.catBigTech,
        headline: 'Google Cloud Achieves Net-Zero Operational Water Cooling Across European Data Centers',
        summary:
          'A five-year retrofitting program transitioned Google\'s Nordic and Benelux hyperscale facilities to closed-loop dielectric liquid immersion cooling systems.',
        whyItMatters:
          'Addresses one of the fiercest municipal criticisms facing expanding AI data center infrastructure.',
        keyPoints: [
          'Cuts facility potable water consumption by 98.4%.',
          'Recaptured heat is channeled into local district heating grids warming 45,000 homes.',
        ],
        publishedAt: now.subtract(const Duration(hours: 5)),
        importance: 7,
        estimatedReadMinutes: 2,
        sources: const [
          Source(name: 'Financial Times', url: 'https://ft.com'),
          Source(name: 'Google Cloud Press', url: 'https://cloud.google.com'),
        ],
      ),
      Story(
        id: 'tech_03',
        category: AppConstants.catBigTech,
        headline: 'Microsoft and Quantinuum Demonstrate Fault-Tolerant Quantum Logic Gates',
        summary:
          'Physicists trapped ions with an unprecedented error rate below 0.001%, successfully running multi-qubit fault-tolerant algorithms that survived through 12,000 algorithmic cycles.',
        whyItMatters:
          'Moves practical quantum chemistry simulations for battery catalysts and nitrogen fixation from theoretical speculation toward commercial reality.',
        keyPoints: [
          'Achieved physical-to-logical qubit ratio improvements of 800:1 to 48:1.',
          'Demonstrated molecular orbital calculation for synthetic clean-fuel catalysis.',
        ],
        publishedAt: now.subtract(const Duration(hours: 6)),
        importance: 8,
        estimatedReadMinutes: 3,
        sources: const [
          Source(name: 'Nature Physics', url: 'https://nature.com'),
          Source(name: 'Wall Street Journal', url: 'https://wsj.com'),
        ],
      ),

      // STARTUPS
      Story(
        id: 'startup_01',
        category: AppConstants.catStartups,
        headline: 'Biocomputing Pioneer SyntheDNA Raises \$140M Series B for Living Storage Arrays',
        summary:
          'San Francisco-based SyntheDNA closed a major funding round to commercialize enzymatic DNA synthesis chips capable of archiving petabytes of data for centuries inside microfluidic glass cassettes.',
        whyItMatters:
          'Could replace fragile magnetic tape libraries and sprawling cold-storage warehouses with shoe-box sized bio-cassettes needing zero electrical power.',
        keyPoints: [
          'Cost per gigabyte projected to drop below magnetic tape by late 2027.',
          'Backed by top-tier venture funds and government archive agencies.',
        ],
        publishedAt: now.subtract(const Duration(hours: 4)),
        importance: 8,
        estimatedReadMinutes: 2,
        sources: const [
          Source(name: 'TechCrunch', url: 'https://techcrunch.com'),
          Source(name: 'Forbes', url: 'https://forbes.com'),
        ],
      ),
      Story(
        id: 'startup_02',
        category: AppConstants.catStartups,
        headline: 'Paris-Based Robotics Lab Mistral-Robotics Unveils Low-Cost Vision-Action Actuators',
        summary:
          'The European robotics spinout debuted lightweight humanoid hands equipped with fiber-optic tactile arrays costing under \$1,500 per unit, drastically lowering the cost barrier for agile warehouse robotics.',
        whyItMatters:
          'High-precision robotic dexterity has historically been restricted to \$50,000+ laboratory setups; commoditization will accelerate industrial adoption.',
        keyPoints: [
          'Capable of manipulating delicate glassware and fragile produce without slip.',
          'Open-source kinematic telemetry software drivers provided on GitHub.',
        ],
        publishedAt: now.subtract(const Duration(hours: 5)),
        importance: 7,
        estimatedReadMinutes: 2,
        sources: const [
          Source(name: 'Sifted', url: 'https://sifted.eu'),
          Source(name: 'VentureBeat', url: 'https://venturebeat.com'),
        ],
      ),
      Story(
        id: 'startup_03',
        category: AppConstants.catStartups,
        headline: 'Decentralized Microgrid Operator Ambient Power Secures \$85M Project Financing',
        summary:
          'A startup orchestrating virtual power plants via rooftop solar and stationary electric vehicle batteries won contracts to stabilize metropolitan energy grids during peak heatwaves.',
        whyItMatters:
          'Demonstrates how software coordination can avert catastrophic brownouts without building costly fossil-fuel peaking plants.',
        keyPoints: [
          'Aggregates over 120,000 residential battery storage systems into a 450MW flexible reserve.',
          'Automated spot market trading algorithm delivers \$35/month credits to participating homeowners.',
        ],
        publishedAt: now.subtract(const Duration(hours: 7)),
        importance: 7,
        estimatedReadMinutes: 2,
        sources: const [
          Source(name: 'Canary Media', url: 'https://canarymedia.com'),
          Source(name: 'Bloomberg Green', url: 'https://bloomberg.com'),
        ],
      ),

      // CYBERSECURITY
      Story(
        id: 'sec_01',
        category: AppConstants.catSecurity,
        headline: 'Global Coalition Neutralizes Modular Botnet Infiltrating SOHO Network Routers',
        summary:
          'Europol and the FBI coordinated a cross-border seizure of control servers operating a 600,000-device botnet that targeted unpatched home and small-office Wi-Fi routers.',
        whyItMatters:
          'Disables one of the largest infrastructure networks weaponized for state-sponsored DDoS attacks and anonymized credential stuffing campaigns.',
        keyPoints: [
          'Malware exploited firmware zero-days affecting routers manufactured between 2021 and 2024.',
          'ISP automated sinkholing redirected infected traffic to clean remediation gateways.',
        ],
        publishedAt: now.subtract(const Duration(hours: 2)),
        importance: 9,
        estimatedReadMinutes: 2,
        sources: const [
          Source(name: 'Krebs on Security', url: 'https://krebsonsecurity.com'),
          Source(name: 'BleepingComputer', url: 'https://bleepingcomputer.com'),
          Source(name: 'Ars Technica', url: 'https://arstechnica.com'),
        ],
      ),
      Story(
        id: 'sec_02',
        category: AppConstants.catSecurity,
        headline: 'NIST Finalizes Post-Quantum Cryptography Migration Guide for Financial Institutions',
        summary:
          'Federal security regulators mandated strict phase-out timelines for RSA-2048 and ECC key exchange algorithms across payment processing gateways by 2028.',
        whyItMatters:
          'Prevents adversaries using "harvest now, decrypt later" strategies from compromising today\'s encrypted financial ledger data once quantum systems mature.',
        keyPoints: [
          'Recommends hybrid classical/lattice-based schemes (ML-KEM and ML-DSA) during the transition.',
          'Institutions must submit cryptographic asset inventory registries by end of Q4.',
        ],
        publishedAt: now.subtract(const Duration(hours: 4)),
        importance: 8,
        estimatedReadMinutes: 3,
        sources: const [
          Source(name: 'NIST Cybersecurity Insights', url: 'https://nist.gov'),
          Source(name: 'Dark Reading', url: 'https://darkreading.com'),
        ],
      ),
      Story(
        id: 'sec_03',
        category: AppConstants.catSecurity,
        headline: 'Critical Vulnerability in Common Package Ecosystem Discovered Through Autonomous Fuzzing',
        summary:
          'Security researchers disclosed an integer overflow vulnerability in a C compression library transitively embedded in millions of container images, patched within 12 hours of discovery.',
        whyItMatters:
          'Highlights the effectiveness of agentic security fuzzers in proactively finding supply-chain flaws before black-hat exploitation.',
        keyPoints: [
          'CVE-2026-8941 scored 9.8 CVSS critical severity due to potential remote code execution.',
          'Automated dependency bot dispatched pull requests to over 40,000 repositories.',
        ],
        publishedAt: now.subtract(const Duration(hours: 5)),
        importance: 7,
        estimatedReadMinutes: 2,
        sources: const [
          Source(name: 'The Hacker News', url: 'https://thehackernews.com'),
          Source(name: 'GitHub Advisory', url: 'https://github.com/advisories'),
        ],
      ),

      // CLOUD
      Story(
        id: 'cloud_01',
        category: AppConstants.catCloud,
        headline: 'Hyperscalers Standardize Next-Gen 800Gbps Optical Interconnect Standards',
        summary:
          'An industry alliance comprising AWS, Google, Microsoft, and Meta established an open interoperability specification for co-packaged optical transceivers inside AI compute clusters.',
        whyItMatters:
          'Eliminates copper wire signal degradation over long rack distances and cuts network interface power dissipation by 35%.',
        keyPoints: [
          'Directly bridges memory pools across adjacent server racks with under 20ns latency.',
          'First production silicon modules scheduled for general rollout in Q1 2027.',
        ],
        publishedAt: now.subtract(const Duration(hours: 3)),
        importance: 8,
        estimatedReadMinutes: 2,
        sources: const [
          Source(name: 'Datacenter Knowledge', url: 'https://datacenterknowledge.com'),
          Source(name: 'EE Times', url: 'https://eetimes.com'),
        ],
      ),
      Story(
        id: 'cloud_02',
        category: AppConstants.catCloud,
        headline: 'Serverless SQLite Edge Replication Achieves Sub-10ms Consistency Globally',
        summary:
          'Cloud infrastructure providers published benchmarks showing distributed embedded SQLite databases synchronizing transactional writes across 300 edge POPs using Raft consensus.',
        whyItMatters:
          'Eliminates the complexity of maintaining bulky centralized relational database servers for modern mobile and SaaS backends.',
        keyPoints: [
          'Read latency dropped to 1.2ms for 99% of global geographic users.',
          'Automatic zero-downtime schema migrations handled at the edge proxy layer.',
        ],
        publishedAt: now.subtract(const Duration(hours: 6)),
        importance: 7,
        estimatedReadMinutes: 2,
        sources: const [
          Source(name: 'Hacker News', url: 'https://news.ycombinator.com'),
          Source(name: 'InfoWorld', url: 'https://infoworld.com'),
        ],
      ),
      Story(
        id: 'cloud_03',
        category: AppConstants.catCloud,
        headline: 'Open-Source Kubernetes Operator Cuts Idle Cloud Spend by Predictive Auto-Downscaling',
        summary:
          'The Cloud Native Computing Foundation accepted a new scheduling operator that analyzes traffic cycles and shuts down unneeded node pools during developer off-hours.',
        whyItMatters:
          'Provides FinOps teams with effortless cloud cost reduction without risking cluster cold-start performance degradation.',
        keyPoints: [
          'Reported median monthly AWS/GCP bill reductions of 28% in pilot tech enterprises.',
          'Zero configuration required; learns team commit habits and peak traffic patterns dynamically.',
        ],
        publishedAt: now.subtract(const Duration(hours: 7)),
        importance: 6,
        estimatedReadMinutes: 2,
        sources: const [
          Source(name: 'CNCF Blog', url: 'https://cncf.io'),
          Source(name: 'DevOps.com', url: 'https://devops.com'),
        ],
      ),

      // TECHNOLOGY RESEARCH
      Story(
        id: 'res_01',
        category: AppConstants.catResearch,
        headline: 'Solid-State Sodium-Ion Battery Cell Reaches 350 Wh/kg Energy Density in Lab Trials',
        summary:
          'Materials scientists at Stanford fabricated a ceramic electrolyte sodium battery exhibiting energy density comparable to premium lithium-ion packs, using abundant and inexpensive table salt precursor materials.',
        whyItMatters:
          'Could radically decouple electric vehicle and grid battery manufacturing from geopolitically concentrated lithium, cobalt, and nickel supply chains.',
        keyPoints: [
          'Retained 94% capacity after 2,500 fast-charge cycles at elevated temperatures.',
          'Inherently non-flammable solid ceramic separator eliminates thermal runaway risk.',
        ],
        publishedAt: now.subtract(const Duration(hours: 4)),
        importance: 9,
        estimatedReadMinutes: 3,
        sources: const [
          Source(name: 'Nature Materials', url: 'https://nature.com'),
          Source(name: 'Science Magazine', url: 'https://science.org'),
        ],
      ),
      Story(
        id: 'res_02',
        category: AppConstants.catResearch,
        headline: 'Optical Neural Network Computes Matrix Multiplications Using Light at Speed-of-Glass',
        summary:
          'Applied physics researchers fabricated a photonic processor that executes transformer tensor multiplications through silicon waveguides without converting light to electrons between layers.',
        whyItMatters:
          'Could break the thermal dissipation wall threatening future AI scaling, achieving thousands of teraflops with near-zero heat emission.',
        keyPoints: [
          'Operates at 100 gigahertz clock frequencies with optical phase shifters.',
          'Compatible with standard CMOS fabrication lines at existing commercial foundries.',
        ],
        publishedAt: now.subtract(const Duration(hours: 6)),
        importance: 8,
        estimatedReadMinutes: 2,
        sources: const [
          Source(name: 'Physical Review Letters', url: 'https://journals.aps.org'),
          Source(name: 'Optica', url: 'https://optica.org'),
        ],
      ),
      Story(
        id: 'res_03',
        category: AppConstants.catResearch,
        headline: 'Gene-Edited Microbiome Strains Neutralize Microplastics in Wastewater Effluent',
        summary:
          'Environmental bioengineers synthesized bacterial enzymes that break down polyethylenes into benign organic acids within 48 hours inside municipal treatment tanks.',
        whyItMatters:
          'Offers a scalable biological remedy against microplastic contamination in drinking water aquifers and marine food webs.',
        keyPoints: [
          'Enzyme kinetics accelerated by 400x compared to wild-type microbial counterparts.',
          'Bacterial strains contain genetic kill switches preventing survival outside treatment vats.',
        ],
        publishedAt: now.subtract(const Duration(hours: 8)),
        importance: 7,
        estimatedReadMinutes: 2,
        sources: const [
          Source(name: 'Cell Environmental', url: 'https://cell.com'),
          Source(name: 'Scientific American', url: 'https://scientificamerican.com'),
        ],
      ),

      // TECHNOLOGY AROUND THE WORLD
      Story(
        id: 'world_01',
        category: AppConstants.catWorld,
        headline: 'Japan Commences Commercial High-Speed Maglev Superconductor Passenger Testing',
        summary:
          'Central Japan Railway began high-frequency autonomous testing on the Tokyo-Nagoya corridor, reaching sustained speeds of 505 km/h using liquid-nitrogen high-temperature superconductors.',
        whyItMatters:
          'Cuts transit time between major industrial metropolitan hubs to 40 minutes, presenting a zero-emission alternative to domestic regional aviation.',
        keyPoints: [
          'Autonomous collision-avoidance telemetry connects directly to satellite networks.',
          'Consumes one-third the energy per passenger-kilometer of commercial jet airliners.',
        ],
        publishedAt: now.subtract(const Duration(hours: 3)),
        importance: 8,
        estimatedReadMinutes: 2,
        sources: const [
          Source(name: 'Nikkei Asia', url: 'https://asia.nikkei.com'),
          Source(name: 'The Japan Times', url: 'https://japantimes.co.jp'),
        ],
      ),
      Story(
        id: 'world_02',
        category: AppConstants.catWorld,
        headline: 'India Surpasses 150 Million Monthly Unified Instant Cross-Border Remittance Transactions',
        summary:
          'The Reserve Bank of India announced that integration of UPI with Southeast Asian payment switches led to record remittance flows with zero intermediary fee deductions.',
        whyItMatters:
          'Bypasses legacy correspondent banking systems, putting billions of dollars directly back into the pockets of migrant workers and small merchants.',
        keyPoints: [
          'Average settlement duration clocked at 4.2 seconds between seven participating nations.',
          'Full biometric and cryptographic multi-factor authentication prevents account compromise.',
        ],
        publishedAt: now.subtract(const Duration(hours: 5)),
        importance: 7,
        estimatedReadMinutes: 2,
        sources: const [
          Source(name: 'The Economic Times', url: 'https://economictimes.indiatimes.com'),
          Source(name: 'Reuters Asia', url: 'https://reuters.com'),
        ],
      ),
      Story(
        id: 'world_03',
        category: AppConstants.catWorld,
        headline: 'Nordic Clean Energy Grid Powers Record 98% of Regional Industrial Computation',
        summary:
          'A consortium of energy operators in Norway, Sweden, and Finland reported that surplus geothermal and offshore wind met virtually all datacenter load requirements over the past 12 months.',
        whyItMatters:
          'Solidifies Northern Europe as the preeminent destination for global sustainable computing and green AI training campuses.',
        keyPoints: [
          'Negative spot electricity prices recorded for over 400 hours during spring runoff.',
          'Attracted over \$12 billion in long-term hyperscale compute investments.',
        ],
        publishedAt: now.subtract(const Duration(hours: 7)),
        importance: 7,
        estimatedReadMinutes: 2,
        sources: const [
          Source(name: 'Nordic Business Insider', url: 'https://businessinsider.com'),
          Source(name: 'Euractiv', url: 'https://euractiv.com'),
        ],
      ),
    ];

    return Edition(
      id: 'edition_${now.year}_${now.month}_${now.day}',
      date: now,
      title: 'Tech Daily',
      hotTopic: 'Autonomous Coding Agents & Local LLMs',
      hotTopicDescription:
          'Software engineering teams are experiencing a profound paradigm shift: autonomous coding agents and local on-device small language models are quietly replacing ad-hoc search and manual boilerplate generation across enterprise repositories.',
      hotTopicRelatedStoryIds: const ['story_hero_01', 'ai_01', 'dev_01', 'dev_04'],
      biggestStory: biggestStory,
      stories: stories,
    );
  }

  Edition _generateArchiveEdition(DateTime date) {
    // Return an archive edition with slightly altered stories to represent historical records
    final archiveHero = Story(
      id: 'archive_hero_${date.year}_${date.month}_${date.day}',
      category: AppConstants.catAi,
      headline: 'Autonomous Systems Cross Historic Milestone in Global Engineering Assessments',
      summary:
          'Retrospective briefing: On this date, leading research institutions recorded the highest single-day leap in automated code generation reliability and formal verification.',
      whyItMatters:
          'Marked the inflection point where automated verification protocols began outpacing human manual code audit speeds.',
      keyPoints: [
        'Global benchmarks registered a 40% jump in zero-shot problem resolution.',
        'Regulators launched exploratory frameworks to study automated compliance.',
      ],
      publishedAt: date,
      importance: 10,
      estimatedReadMinutes: 3,
      sources: const [
        Source(name: 'Tech Daily Archives', url: 'https://techdaily.news'),
        Source(name: 'Reuters', url: 'https://reuters.com'),
      ],
    );

    final archiveStories = [
      Story(
        id: 'archive_story_1',
        category: AppConstants.catDev,
        headline: 'Framework Updates Bring Zero-Overhead Concurrency to Modern Edge Run-times',
        summary:
          'Compiler optimizations deployed across production stacks eliminated runtime memory stalls for high-throughput distributed message queues.',
        whyItMatters:
          'Reduced latency jitter in latency-sensitive financial and telemetry pipelines.',
        keyPoints: [
          'Zero-copy thread synchronization proved stable in production trials.',
          'Adopted by major cloud vendors within 48 hours of publication.',
        ],
        publishedAt: date,
        sources: const [
          Source(name: 'TechCrunch', url: 'https://techcrunch.com'),
        ],
      ),
      Story(
        id: 'archive_story_2',
        category: AppConstants.catSecurity,
        headline: 'Next-Generation Zero-Knowledge Proofs Adopted for Sovereign Cloud Compliance',
        summary:
          'Cryptographers successfully proved regulatory compliance across sovereign borders without disclosing underlying citizen registry records.',
        whyItMatters:
          'Settled long-standing diplomatic impasses regarding privacy-preserving international law enforcement cooperation.',
        keyPoints: [
          'Proof verification latency is now under 12 milliseconds.',
          'Standardized across European and Pacific regulatory agencies.',
        ],
        publishedAt: date,
        sources: const [
          Source(name: 'Ars Technica', url: 'https://arstechnica.com'),
        ],
      ),
      Story(
        id: 'archive_story_3',
        category: AppConstants.catCloud,
        headline: 'High-Density Liquid Immersion Cooling Becomes Standard for Next-Gen Racks',
        summary:
          'Hyperscale facility operators finalized standard specs for dual-phase dielectric immersion, slashing cooling overheads worldwide.',
        whyItMatters:
          'Reduced power usage effectiveness (PUE) to an unprecedented 1.03 in desert environments.',
        keyPoints: [
          'Saves millions of gallons of water annually per gigawatt-hour.',
          'Allows 120kW per rack power densities without noise pollution.',
        ],
        publishedAt: date,
        sources: const [
          Source(name: 'Datacenter Dynamics', url: 'https://datacenterdynamics.com'),
        ],
      ),
    ];

    return Edition(
      id: 'edition_${date.year}_${date.month}_${date.day}',
      date: date,
      title: 'Tech Daily',
      hotTopic: 'The Evolution of High-Performance Edge Computing',
      hotTopicDescription:
          'Historical analysis of how decentralized compute nodes and lightweight WebAssembly runtimes reshaped the internet backbone.',
      biggestStory: archiveHero,
      stories: archiveStories,
    );
  }
}
