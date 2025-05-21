# NEAR Protocol Project Scoring Rubric

## 1. NEAR Protocol Integration (20 points)

### Scoring Guidelines
- **16-20 points**: Deep integration, NEAR standards usage, wallet integration, on-chain innovation
- **10-15 points**: Moderate NEAR use, partial integrations
- **0-9 points**: Minimal to no direct integration

### Evaluation Criteria
- Deep integration with NEAR standards (NEPs)
- Advanced features (cross-contract calls, Promises)
- Robust wallet integration
- Innovative on-chain logic
- Extensive use of NEAR SDKs (near-sdk-rs, near-sdk-js)
- Clear contract structure
- Interaction with core NEAR concepts

### AI Evaluation Prompt
Role: You are an expert AI code auditor specializing in the NEAR Protocol ecosystem.

Task: Evaluate the provided code context for its integration with the NEAR Protocol based on the following criteria. Assign a score out of 20 and provide a detailed justification referencing specific code examples (e.g., file names, function names, code snippets, library usage).

## 2. Onchain Quality (20 points)

### Scoring Guidelines
- **16-20 points**: Real, meaningful interactions with NEAR chain verified through code and live usage
- **10-15 points**: Occasional useful on-chain transactions
- **0-9 points**: Superficial or junk transactions

### Evaluation Criteria
- Quality and purpose of on-chain interactions
- Verification of transactions through code and live usage
- Complexity and meaningfulness of contract calls
- Impact on state or user experience
- Core functionality implementation

### AI Evaluation Prompt
Role: You are an AI code auditor analyzing blockchain interactions, specifically on the NEAR Protocol.

Task: Evaluate the quality and meaningfulness of the on-chain interactions implemented in the provided code context. Assess whether the transactions serve a core purpose or are superficial. Assign a score out of 20 and provide a detailed justification referencing specific code examples demonstrating the nature of the on-chain activity.

## 3. Offchain Quality (15 points)

### Scoring Guidelines
- **12-15 points**: Dedicated standalone app, complex architecture, robust back-end integrations
- **7-11 points**: Browser extension, moderate complexity
- **0-6 points**: Simple off-chain scripts, minimal complexity

### Evaluation Criteria
- Application type (web app, mobile app, desktop app)
- Architecture complexity
- Integration quality
- Framework usage
- Separation of concerns
- Build systems
- API definitions

### AI Evaluation Prompt
Role: You are an AI software architect evaluating the complexity and quality of off-chain components supporting a blockchain application.

Task: Analyze the provided code context representing the off-chain parts of the project (e.g., frontend, backend, scripts). Assess its architectural complexity, robustness, and integration quality based on the criteria below. Assign a score out of 15 and provide a detailed justification referencing specific code examples or architectural patterns identified.

## 4. Code Quality & Documentation (15 points)

### Scoring Guidelines
- **12-15 points**: Clean, modular, tested code; extensive documentation
- **7-11 points**: Moderate clarity, some tests/docs
- **0-6 points**: Poorly organized, minimal/no documentation

### Evaluation Criteria
- Code structure and modularity
- Naming conventions
- Style consistency
- Documentation quality
- Test coverage
- README completeness
- Architecture documentation

### AI Evaluation Prompt
Role: You are an AI code reviewer assessing code structure, readability, maintainability, testing practices, and documentation.

Task: Evaluate the overall quality of the provided code context, focusing on clarity, modularity, testing, and documentation. Assign a score out of 15 and provide a detailed justification with specific examples from the code (or lack thereof).

## 5. Technical Innovation/Uniqueness (15 points)

### Scoring Guidelines
- **12-15 points**: Highly novel solution, advances state-of-the-art
- **7-11 points**: Some innovative elements, derivative model
- **0-6 points**: Little/no innovation

### Evaluation Criteria
- Novelty of solution
- Technical advancement
- Unique approaches
- Problem-solving innovation
- Application of technology
- Comparison to existing solutions

### AI Evaluation Prompt
Role: You are an AI technology analyst with expertise in software development and blockchain technology.

Task: Assess the technical innovation and uniqueness demonstrated in the provided code context. Compare the approaches used against standard practices or existing solutions in the relevant domain (e.g., DeFi, NFTs, tooling on NEAR). Assign a score out of 15 and provide a justification explaining the innovative aspects or lack thereof, referencing specific techniques, algorithms, or architectural choices found in the code.

## 6. Team Activity & Project Maturity (10 points)

### Scoring Guidelines
- **8-10 points**: Active commits, ongoing development, clear roadmap
- **4-7 points**: Occasional updates, partial roadmap
- **0-3 points**: Dormant project, unclear future

### Evaluation Criteria
- Development activity level
- Project maintenance
- Version control usage
- Documentation updates
- Roadmap clarity
- Project structure
- Future planning

### AI Evaluation Prompt
Role: You are an AI project analyst evaluating project health and development velocity based on available evidence.

Task: Assess the project's activity level and maturity based primarily on information derivable from the provided context. This might include code structure hinting at ongoing development (e.g., versioning, TODOs, modularity for future expansion), documentation (e.g., roadmap sections in README), or metadata if provided (e.g., commit summaries, recent file changes). Assign a score out of 10 and provide a justification.

## 7. Grant Impact & Ecosystem Fit (5 points)

### Scoring Guidelines
- **4-5 points**: Strong ecosystem alignment, clear beneficial impact
- **2-3 points**: Moderate alignment, niche impact
- **0-1 points**: Weak fit, unclear impact

### Evaluation Criteria
- NEAR ecosystem alignment
- Potential impact
- User benefit
- Developer value
- Problem-solving relevance
- Ecosystem contribution

### AI Evaluation Prompt
Role: You are an AI ecosystem analyst evaluating how well a software project aligns with the goals and needs of a specific ecosystem (NEAR Protocol).

Task: Assess the potential impact of the project and its alignment with the NEAR ecosystem based on the provided code context and any accompanying documentation (like a README or project description). Consider the problem the code aims to solve and its relevance to NEAR users or developers. Assign a score out of 5 and provide a justification.

## 8. Financial Scheme Analyzer (15 points)

### Scoring Guidelines
- **12-15 points**: Robust protections against wash trading, Ponzi schemes, and financial fraud
- **7-11 points**: Partial protections; gaps or vulnerabilities exist
- **0-6 points**: Minimal or no protections against financial fraud

### Evaluation Criteria
- Protection against wash trading
- Anti-Ponzi scheme measures
- Financial fraud prevention
- Transaction validation
- Security audits
- Anti-collusion mechanisms

### AI Evaluation Prompt
Role: You are an expert AI auditor specializing in financial security within blockchain/web3 applications.

Task: Evaluate the provided code context specifically for vulnerabilities or robustness concerning financial schemes common to web3 ecosystems, including wash trading, Ponzi schemes, and similar fraudulent practices. Assign a score out of 15 and provide a detailed justification, citing specific evidence from the code context. 