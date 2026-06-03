---
name: new-app
description: |
  Scaffold a new Cumulocity application using the @c8y/websdk Angular schematic without
  human interaction. Covers Angular CLI installation, app generation, schematic setup,
  AI tools configuration, dev server, and build commands. Triggers: new app, scaffold,
  create application, ng add websdk, setup cumulocity app, new cumulocity project.
version: 1.0.1
category: scaffolding
triggers:
  - new app
  - scaffold
  - create application
  - ng add websdk
  - setup cumulocity app
  - new cumulocity project
  - websdk schematic
  - bootstrap application
tags:
  - angular
  - cumulocity
  - scaffolding
  - websdk
  - cli
  - setup
---

# New Cumulocity Application Skill

## Overview

The `@c8y/websdk` Angular schematic scaffolds a custom Cumulocity application and wires it
into the platform. This skill produces all CLI commands needed to go from zero to a running
dev server **without any interactive prompts**.

---

## Step 1 — Install Angular CLI

Install the Angular 20 CLI globally:

```bash
npm install @angular/cli@v20-lts -g
```

> **Why Angular 20?** The `@c8y/websdk` schematic currently targets Angular 20.

---

## Step 2 — Generate the Angular Application

Use these flags to avoid any interactive prompts:

```bash
ng new <appName> \
  --style=less \
  --routing=true \
  --ssr=false \
  --skip-git=true \
  --package-manager=pnpm \
  --interactive=false \
  --defaults
```

| Flag | Purpose |
|---|---|
| `--style=less` | LESS stylesheets (required by Cumulocity component styles) |
| `--routing=true` | Angular Router module pre-configured |
| `--ssr=false` | No server-side rendering (not supported by the platform) |
| `--skip-git=true` | Skip git init (manage VCS separately) |
| `--package-manager=pnpm` | Use pnpm (preferred; faster installs, better deduplication) |
| `--interactive=false` | Fully non-interactive — no prompts |
| `--defaults` | Accept all remaining defaults |

Navigate into the new directory:

```bash
cd <appName>
```

---

## Step 3 — Add `@c8y/websdk`

### Choosing a version

Check available dist-tags on npm to find the right version:

```bash
npm dist-tags @c8y/websdk
```

Common dist-tags:

| Tag | Meaning |
|---|---|
| `latest` | Current stable release |
| `y2026-lts` | 2026 Long-Term Support line |
| `y2025-lts` | 2025 Long-Term Support line |
| `next` | Pre-release / RC channel |

Pass the tag directly to `ng add`:

```bash
ng add @c8y/websdk@y2026-lts
```

Or pin to an exact version:

```bash
ng add @c8y/websdk@1023.14.131
```

### Fully non-interactive install

Use `--application` + `--skip-confirmation` to bypass all prompts:

```bash
ng add @c8y/websdk@y2026-lts \
  --application=@c8y/<appName>@<version> \
  --skip-confirmation
```

Where:
- `<appName>` must be one of (sorted by highest priority): `sample-plugin`,`application`,`cockpit`,`tutorial`,`administration`,`codex`,`devicemanagement`, `hybrid`, `package-blueprint` 
- `<version>` is the exact package version from npm (e.g. `1023.14.160`) — resolve it with `npm view @c8y/websdk@<dist-tag> version`

**Example — cockpit base at 2026-lts:**

```bash
ng add @c8y/websdk@y2026-lts \
  --application=@c8y/sample-plugin@1023.14.160 \
  --skip-confirmation
```

---

## Step 4 — Configure AI Tools (Optional)

The schematic can write curated Cumulocity Web SDK guidelines into your project for AI
coding assistants. This step is optional but strongly recommended.

### Skip AI tools entirely

Passing `--skip-confirmation` skips AI tool setup automatically:

```bash
ng add @c8y/websdk@y2026-lts --application=@c8y/cockpit@$(npm view @c8y/websdk@y2026-lts version) --skip-confirmation
```

### Configure specific AI tools non-interactively

Use the `--ai-tools` flag with a comma-separated list of tool names:

```bash
ng add @c8y/websdk --ai-tools=claude,github-copilot,gemini
```

Valid tool names: `claude`, `github-copilot`, `gemini`

To explicitly opt out:

```bash
ng add @c8y/websdk --ai-tools=none
```

> **Note:** `--ai-tools` takes precedence over `--skip-confirmation`. When both flags are
> present, only the tools listed in `--ai-tools` are configured.

### What gets written per tool

| Tool | Files written |
|---|---|
| **Claude** | `.claude/CLAUDE.md`, `.claude/rules/*.instructions.md` |
| **GitHub Copilot** | `.github/copilot-instructions.md`, `.github/instructions/*.instructions.md` |
| **Gemini** | `.gemini/GEMINI.md`, `.gemini/rules/*.instructions.md` |

Each tool receives the same core content adapted to its configuration format:
- Project overview, TypeScript rules, Angular patterns, accessibility requirements
- Angular/TypeScript UI development guidelines
- Cypress e2e and Jest unit test conventions

The schematic **overwrites** files that match standard template names and **preserves**
any custom files that don't match.

---

## Step 5 — Run the Development Server

```bash
ng serve -u https://<yourTenant>.cumulocity.com/
```

Replace `<yourTenant>` with your Cumulocity tenant subdomain. The `-u` (or `--url`) flag
points the dev server proxy at your tenant so API calls are forwarded correctly.

---

## Step 6 — Build

```bash
ng build <appName>
```

Output lands in `dist/<appName>/`.

---

## Complete Non-Interactive Quickstart

Copy-paste sequence for a fully automated setup:

```bash
# 1. Install Angular CLI (once per machine)
npm install @angular/cli@v20-lts -g

# 2. Scaffold the app
ng new my-app \
  --style=less \
  --routing=true \
  --ssr=false \
  --skip-git=true \
  --package-manager=pnpm \
  --interactive=false \
  --defaults

# 3. Enter directory
cd my-app

# 4. Resolve target version
C8Y_VERSION=$(npm view @c8y/websdk@y2026-lts version)

# 5. Add websdk schematic (no prompts, configure GitHub Copilot + Claude)
ng add @c8y/websdk@y2026-lts \
  --application=@c8y/cockpit@${C8Y_VERSION} \
  --ai-tools=github-copilot,claude

# 6. Start dev server
ng serve -u https://mytenant.cumulocity.com/
```

---

## Reference

| Resource | URL |
|---|---|
| `@c8y/websdk` on npm | https://www.npmjs.com/package/@c8y/websdk |
| Cumulocity tutorial repository | https://github.com/Cumulocity-IoT/tutorial |
| Claude memory docs | https://docs.anthropic.com/en/docs/claude-code/memory |
| GitHub Copilot customization | https://code.visualstudio.com/docs/copilot/copilot-customization |
| Cursor rules docs | https://cursor.com/docs/rules |
| Windsurf memories docs | https://docs.windsurf.com/windsurf/cascade/memories |
| JetBrains AI guidelines | https://www.jetbrains.com/help/junie/customize-guidelines.html |
| Gemini CLI docs | https://geminicli.com/docs/cli/gemini-md |
