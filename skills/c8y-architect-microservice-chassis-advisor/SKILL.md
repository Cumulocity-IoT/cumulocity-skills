---
name: c8y-architect-microservice-chassis-advisor
description: 'Recommends the best Cumulocity microservice chassis / framework for a given project. Use when a developer or architect asks which microservice chassis to use, which framework to pick for a Cumulocity microservice, how to choose between NestJS, Nitro, Spring Boot, .NET, or Python for a microservice, or needs a chassis decision for TypeScript, JavaScript, Java, C#, or Python on Cumulocity.'
argument-hint: 'Describe your project: team skills, expected load, use case, and any constraints (e.g. "Java team, enterprise ERP integration, high reliability required")'
---

# Cumulocity Microservice Chassis Advisor

## When to Use

Invoke this skill whenever someone asks:

- "Which chassis / framework should I use for my Cumulocity microservice?"
- "Should I use NestJS, Spring Boot, .NET, or Python for my microservice?"
- "What is the best stack for a Cumulocity microservice?"
- "Help me choose between the available Cumulocity SDKs."
- Questions about trade-offs between NestJS, Nitro, Spring Boot, .NET Generic Host, or Python + FastAPI in the Cumulocity context.

---

## Procedure

### Step 1 — Gather Requirements

Ask (or infer from context) the following. You do not need all answers; work with what is available.

| # | Question | Why it matters |
|---|---|---|
| 1 | What is the **primary use case**? (e.g. ERP bridge, SCADA agent, data pipeline, platform extension, analytics) | Narrows the shortlist immediately |
| 2 | What is the **team's primary tech stack**? (TypeScript / Java / C# / Python / mixed) | Skill-fit is the strongest single factor |
| 3 | Is **official Cumulocity SDK support** a hard requirement? | Only Spring Boot + Java SDK is officially supported |
| 4 | What are the **expected load characteristics**? (low/bursty, medium/steady, high-throughput, mega-fleet) | Impacts runtime, footprint, and concurrency model |
| 5 | Are there **resource / cost constraints** on the deployment? (e.g. tight memory limits, edge deployment) | Favours Nitro or .NET AOT |
| 6 | Is **AI / ML / data processing** part of the microservice logic? | Strongly favours Python |
| 7 | Is this a **rapid PoC** or a **long-lived production service**? | PoC → Nitro or Python; production → NestJS, Spring Boot, or .NET |
| 8 | Are there **enterprise governance requirements** (e.g. auditability, support SLAs, supply-chain policies)? | Favours officially backed frameworks |

---

### Step 2 — Evaluate Against the Decision Matrix

Score the shortlisted options against the criteria below.

> **Rating:** 🟢 High / Excellent &nbsp;&nbsp;|&nbsp;&nbsp; 🟡 Medium / Good &nbsp;&nbsp;|&nbsp;&nbsp; 🔴 Low / Limited

| Criterion | NestJS + @c8y/client | Nitro + c8y-nitro | Spring Boot + Java SDK | .NET Generic Host + C# SDK | Python + FastAPI |
|---|:---:|:---:|:---:|:---:|:---:|
| **Team Skill Fit** | 🟢 Web / TS teams | 🟢 Web / TS teams | 🟡 Java specialists needed | 🟡 .NET specialists needed | 🟢 Broad — data, DevOps, web |
| **Official Cumulocity Support** | 🟡 Community | 🟡 Community | 🟢 Official & fully supported | 🟡 Community | 🟡 Community |
| **Cross-Cutting Features OOB** | 🟢 Comprehensive | 🟢 Comprehensive | 🟢 Comprehensive | 🟢 Comprehensive | 🟡 Moderate |
| **Resilience Patterns OOB** | 🟡 Via libraries | 🟡 Probes + libraries | 🟢 Resilience4j native | 🟢 Polly native | 🟡 Via `tenacity` |
| **Observability** | 🟡 Via plugins | 🟢 Structured logging + OpenTelemetry | 🟢 Actuator + Micrometer | 🟢 OpenTelemetry native | 🟡 Via libraries |
| **Runtime Throughput & CPU Efficiency** | 🟡 Medium | 🟢 High | 🟡 Medium | 🟢 High | 🟡 Medium |
| **Memory & Docker Image Footprint** | 🟡 Medium | 🟢 Very Low | 🔴 High (🟢 Low with Spring Boot AOT) | 🟢 Low (🟢🟢 with AOT) | 🟡 Medium |
| **Cold Start / Startup Time** | 🟡 Fast | 🟢 Very Fast | 🔴 Slow (🟢 Very Fast with GraalVM) | 🟡 Fast (🟢 Very Fast with AOT) | 🟢 Fast |
| **Scalability & Concurrency Model** | 🟢 Async event-loop | 🟢 Async event-loop | 🟡 Thread-pool (reactive opt.) | 🟡 Thread-pool (async/await opt.) | 🟡 Async via asyncio |
| **Type Safety** | 🟢 Strong (TypeScript) | 🟢 Strong (TypeScript) | 🟢 Strong (Java) | 🟢 Strong (C#) | 🟡 Partial (type hints, Pydantic) |
| **Boilerplate Required** | 🔴 Heavy | 🟢🟢 None | 🔴 Very Heavy | 🔴 Heavy | 🟢 Minimal |
| **AI / ML & Data Integration** | 🟡 Via npm libraries | 🟡 Via npm libraries | 🟡 Via libraries (DL4J, Spring AI) | 🟡 Via NuGet (ML.NET) | 🟢 Native — NumPy, Pandas, PyTorch |
| **Ecosystem Maturity & Community Size** | 🟢 Large | 🟡 Nitro strong; c8y-nitro niche | 🟢 Very Large | 🟢 Large | 🟢 Very Large |
| **Long-term Commercial Backing** | 🟢 NestJS Inc. | 🟢 Vercel-backed Nuxt/Nitro ecosystem | 🟢 Broadcom (Spring) | 🟢 Microsoft | 🟢 PSF + broad industry |

---

### Step 3 — Apply the Quick-Pick Rules

Use these rules to short-circuit the matrix for common scenarios:

| If… | Recommend |
|---|---|
| Team is Java-based **and** official support is required | **Spring Boot + Java SDK** — only officially supported chassis |
| Team is TypeScript/Node and service will be long-lived, structured, and multi-protocol | **NestJS + @c8y/client** — strongest TS framework conventions and broad ecosystem for larger services |
| Service is resource-constrained, startup-sensitive, or needs fast iteration with strong C8Y batteries included | **Nitro + c8y-nitro** — very small footprint, very fast startup, and strong built-in Cumulocity ergonomics |
| Team is .NET/C# and throughput / image size matters | **.NET Generic Host + C# SDK** — especially strong with AOT compilation |
| Service involves AI/ML, data enrichment, or analytics | **Python + FastAPI** — unmatched data science ecosystem |
| Mixed team with no dominant skill and time-to-market pressure | **NestJS** (broad TypeScript adoption) or **Python + FastAPI** (low ramp-up) |
| Enterprise governance requires a supported SLA | **Spring Boot + Java SDK** — only option with official Cumulocity backing |
| Service involves complex business logic and heavy compute power for data analytics, image processing etc. | **Spring Boot + Java SDK** or **.NET Generic Host + C# SDK** — better suited for CPU-intensive workloads with enterprise-grade multi-threading |
| Service is I/O-heavy but not CPU-bound (e.g. API gateway, protocol translator) | **Nitro + c8y-nitro** — efficient async I/O with strong Cumulocity integration |
| Service handles and processes JSON-heavy data transformations | **Nitro + c8y-nitro** — efficient async I/O with strong Cumulocity integration |
| Service needs many enterprise integrations (databases, message queues, external APIs) | **Spring Boot + Java SDK** or **.NET Generic Host + C# SDK** — mature ecosystems with extensive integration libraries |
| Service needs fast development and deployment for a PoC or MVP | **Nitro + c8y-nitro** or **Python + FastAPI** — minimal boilerplate and fast iteration cycles |
---

### Step 4 — Formulate a Recommendation

Structure your response as follows:

1. **Primary recommendation** — state the chassis and the top 2–3 reasons it fits the stated requirements.
2. **Runner-up** (if close) — one sentence on when to reconsider.
3. **Trade-offs to watch** — flag any 🔴 ratings on criteria that are important for this project.
4. **Next steps** — link to the relevant starter or documentation.

---

## Bundled Assets

| Asset | When to load |
|-------|-------------|
| [`references/dx.md`](references/dx.md) | Use this if you want a detailed comparison of developer experience across different ecosystems |

## Resource Links

| Chassis | Starter / Docs |
|---|---|
| NestJS + @c8y/client | [NestJS](https://nestjs.com/) · [@c8y/client (npm)](https://www.npmjs.com/package/@c8y/client) · [Cumulocity Web SDK Docs](https://cumulocity.com/docs/web/) |
| Nitro + c8y-nitro | [Nitro](https://nitro.build/) · [c8y-nitro (GitHub)](https://github.com/schplitt/c8y-nitro) · [Starter Template](https://github.com/schplitt/c8y-nitro-starter) |
| Spring Boot + Java SDK | [Spring Boot](https://spring.io/projects/spring-boot) · [Java Microservice SDK (Docs)](https://cumulocity.com/docs/microservice-sdk/java/) · [Java Clients project](https://github.com/Cumulocity-IoT/cumulocity-clients-java) · [Maven Archetype for Microservice](https://github.com/Cumulocity-IoT/cumulocity-microservice-archetype) · [Examples & Templates](https://github.com/Cumulocity-IoT/cumulocity-microservice-templates) |
| .NET Generic Host + C# SDK | [.NET](https://dotnet.microsoft.com/) · [Cumulocity .NET SDK](https://github.com/Cumulocity-IoT/cumulocity-sdk-dotnet) · [Cumulocity .NET Client](https://github.com/Cumulocity-IoT/cumulocity-clients-dotnet) |
| Python + FastAPI | [FastAPI](https://fastapi.tiangolo.com/) · [Python API (GitHub)](https://github.com/Cumulocity-IoT/cumulocity-python-api) · [Python MS SDK (GitHub)](https://github.com/chisou/cumulocity-python-ms) |
