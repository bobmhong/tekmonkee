# TekMonkee

A personal knowledge base of development and technical concepts, patterns, and practices—curated from years of work logs and notes.

## Overview

This repository serves as a searchable, organized collection of technical knowledge covering:

- Development patterns and best practices
- Infrastructure and DevOps techniques
- Debugging strategies and troubleshooting guides
- Tool configurations and workflows
- Architecture decisions and trade-offs
- Code snippets and reusable solutions
- Cursor AI skills and rules for automated workflows

All content has been sanitized to remove sensitive information (proprietary code, internal URLs, credentials, company-specific details).

## Navigation

### By Topic

Browse the **[Topic Index](./index/topics.md)** to find content organized by category:

| Category | Description |
|----------|-------------|
| `kubernetes` | Container orchestration, pod management, deployments |
| `infrastructure` | Cloud resources, networking, storage |
| `automation` | CI/CD, scripting, workflow automation |
| `debugging` | Troubleshooting techniques, log analysis |
| `tooling` | IDE setup, CLI tools, developer experience |
| `architecture` | System design, patterns, trade-offs |
| `security` | Auth, secrets management, best practices |
| `performance` | Optimization, profiling, monitoring |

### By Language

Browse the **[Language Index](./index/languages.md)** to find content specific to a programming language:

| Language | Description |
|----------|-------------|
| `python` | Python scripts, libraries, patterns |
| `go` | Go/Golang development |
| `javascript` | JS/Node.js, frontend |
| `typescript` | TypeScript patterns |
| `bash` | Shell scripting |
| `sql` | Database queries, optimization |
| `java` | Java development |
| `yaml` | Configuration, K8s manifests |

### By Pattern

Browse the **[Patterns Index](./index/patterns.md)** to find development patterns and practices:

| Pattern Type | Examples |
|--------------|----------|
| `creational` | Factory, Builder, Singleton |
| `structural` | Adapter, Decorator, Proxy |
| `behavioral` | Observer, Strategy, Command |
| `architectural` | MVC, Microservices, Event-driven |
| `concurrency` | Worker pools, Async patterns |
| `data` | Repository, DAO, CQRS |
| `api` | REST conventions, GraphQL patterns |
| `testing` | Mocking, Fixtures, Test doubles |

### Cursor AI Skills & Rules

This repo includes Cursor IDE skills — reusable AI workflows that teach the agent how to perform specific tasks.

| Skill | Description |
|-------|-------------|
| [tekmonkee-setup](.cursor/skills/tekmonkee-setup/SKILL.md) | Configure Cursor IDE and install standard dev tools on a new machine |

**What are Skills?**
Skills are markdown files in `.cursor/skills/` that provide instructions, scripts, and reference docs for specific workflows. When you invoke a skill (e.g., `@tekmonkee-setup`), the agent reads and follows the instructions.

**What are Rules?**
Rules are persistent guidance in `.cursor/rules/` that apply automatically to matching files or contexts. Use them for coding standards, project conventions, or file-specific patterns.

### By Timeline

Browse the **[Timeline Index](./index/timeline.md)** to see when topics were documented or updated:

```
index/timeline.md
├── 2026/
├── 2025/
├── 2024/
└── ...
```

Each entry includes the date added/updated, making it easy to find recent learnings or trace back to when a concept was first explored.

## Directory Structure

```
tekmonkee/
├── README.md                 # This file
├── .cursor/
│   ├── skills/               # Cursor AI skills (reusable workflows)
│   │   └── tekmonkee-setup/  # New machine setup skill
│   │       ├── SKILL.md
│   │       ├── install-reference.md
│   │       └── scripts/
│   └── rules/                # Cursor rules (persistent guidance)
├── index/
│   ├── topics.md             # Alphabetical topic index with tags
│   ├── languages.md          # Index by programming language
│   ├── patterns.md           # Index by development pattern
│   └── timeline.md           # Chronological index by date
├── topics/
│   ├── kubernetes/
│   ├── infrastructure/
│   ├── automation/
│   ├── debugging/
│   ├── tooling/
│   ├── architecture/
│   ├── security/
│   └── performance/
├── languages/                # Language-specific knowledge
│   ├── python/
│   ├── go/
│   ├── javascript/
│   ├── typescript/
│   ├── bash/
│   ├── sql/
│   ├── java/
│   └── yaml/
├── patterns/                 # Development patterns
│   ├── creational/
│   ├── structural/
│   ├── behavioral/
│   ├── architectural/
│   ├── concurrency/
│   ├── data/
│   ├── api/
│   └── testing/
└── snippets/                 # Reusable code snippets by language
    ├── bash/
    ├── python/
    ├── go/
    └── yaml/
```

## Metadata & Tags

Each document includes a frontmatter section for cross-referencing:

```yaml
---
title: Example Topic
date: 2025-03-15
updated: 2025-06-20
tags: [kubernetes, debugging, networking]
language: python
pattern: strategy
category: automation
---
```

### Tag Categories

- **Domain**: `kubernetes`, `docker`, `aws`, `gcp`, `linux`
- **Activity**: `debugging`, `deployment`, `migration`, `setup`
- **Concept**: `networking`, `storage`, `security`, `monitoring`
- **Tooling**: `cursor`, `vscode`, `git`, `cli`

### Languages

`python`, `go`, `javascript`, `typescript`, `bash`, `sql`, `java`, `yaml`, `rust`, `ruby`

### Patterns

- **Creational**: `factory`, `builder`, `singleton`, `prototype`
- **Structural**: `adapter`, `decorator`, `proxy`, `facade`
- **Behavioral**: `observer`, `strategy`, `command`, `state`
- **Architectural**: `mvc`, `microservices`, `event-driven`, `hexagonal`
- **Concurrency**: `worker-pool`, `async-await`, `pub-sub`, `circuit-breaker`
- **Data**: `repository`, `dao`, `cqrs`, `event-sourcing`
- **API**: `rest`, `graphql`, `grpc`, `pagination`
- **Testing**: `mock`, `fixture`, `test-double`, `contract-test`

## Search Tips

- **By tag**: Search for `tags: [tagname]` in your editor or use grep
- **By language**: Search for `language: python` or browse `index/languages.md`
- **By pattern**: Search for `pattern: factory` or browse `index/patterns.md`
- **By date range**: Browse `index/timeline.md` or search for `date: 2025-`
- **Full-text**: Use your IDE's global search or `grep -r "search term" .`

## Content Guidelines

All entries follow a consistent format:

1. **Title** - Clear, descriptive heading
2. **Metadata** - Date, tags, related topics
3. **Context** - When/why this is useful
4. **Content** - The actual knowledge (steps, code, explanation)
5. **Related** - Links to related entries

## Contributing

This is a personal knowledge base generated from private notes. Content is added through periodic analysis and curation of work logs.

---

*Last updated: 2026-02-28*
