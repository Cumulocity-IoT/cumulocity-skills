---
name: migration
description: |
  Step-by-step guide to migrate a Cumulocity Web SDK application to a target version.
  Detects breaking changes with the ui-breaking-changes-cli, scaffolds a reference app
  at the target version with the new-app skill, compares key configuration files
  (app.ts, bootstrap.ts, angular.json, etc.), and finishes with a code-quality-analysis
  review. Triggers: migrate app, upgrade version, breaking changes, sdk upgrade,
  migrate cumulocity, upgrade websdk.
version: 1.0.0
category: migration
triggers:
  - migrate app
  - upgrade version
  - breaking changes
  - sdk upgrade
  - migrate cumulocity
  - upgrade websdk
  - migration guide
  - version upgrade
tags:
  - angular
  - cumulocity
  - migration
  - websdk
  - breaking-changes
  - upgrade
---

# Cumulocity Web SDK Migration Skill

## Overview

This skill guides you through a full migration of a Cumulocity Web SDK application from
one version to another. It combines three tools into a single repeatable workflow:

1. **[ui-breaking-changes-cli](https://github.com/Cumulocity-IoT/ui-breaking-changes-cli)** — detect every breaking change between the two SDK versions
2. **`new-app` skill** — scaffold a clean reference project at the target version
3. **`code-quality-analysis` skill** — verify the migrated code meets quality standards

---

## Prerequisites

Before starting, identify:

| Variable | Description | Example |
|---|---|---|
| `FROM_VERSION` | Your current `@c8y/ngx-components` version | `2025-lts`, `1021.22.50` |
| `TO_VERSION` | The target SDK version | `2026-lts`, `cd` |
| `PROJECT_ROOT` | Absolute path to the app you are migrating | `/home/user/my-c8y-app` |

To find your current version:

```bash
cat package.json | grep '@c8y/ngx-components'
```

---

## Step 1 — Detect Breaking Changes

Use the `ui-breaking-changes-cli` to get a full report of everything that changed between
your current and target versions.

### Install the CLI

Download the latest `.tgz` from the
[GitHub Releases](https://github.com/Cumulocity-IoT/ui-breaking-changes-cli/releases) page,
then extract and run it directly — no global install required:

```bash
tar -xzf c8y-breaking-changes-cli-v*.*.*.tgz
```

Alternatively, build from source:

```bash
git clone https://github.com/Cumulocity-IoT/ui-breaking-changes-cli.git
cd ui-breaking-changes-cli
pnpm install
pnpm build
```

### Run the report

```bash
# Human-readable overview
node index.js --from <FROM_VERSION> --to <TO_VERSION>

# Markdown output — paste into a PR or issue for tracking
node index.js --from <FROM_VERSION> --to <TO_VERSION> --format markdown

# Breaking changes only (suppress NOTABLE / INFO noise)
node index.js --from <FROM_VERSION> --to <TO_VERSION> --breaking-only

# Angular-specific breaking changes only
node index.js --from <FROM_VERSION> --to <TO_VERSION> --breaking-only --category angular

# Generate grep patterns to locate affected symbols in your codebase
node index.js --from <FROM_VERSION> --to <TO_VERSION> --show-grep
```

### Process the report

For each item in the report:

1. Note the **severity** (`BREAKING`, `NOTABLE`, `INFO`) and **category** (`angular`,
   `websdk-ui`, `rest-api`, `security`, `migration`).
2. Use the grep patterns from `--show-grep` to find affected usages in the project:
   ```bash
   grep -rn "<symbol>" <PROJECT_ROOT>/src
   ```
3. Create a tracking list of all `BREAKING` items — these must be resolved before the app
   will compile or run correctly.

---

## Step 2 — Scaffold a Reference App at the Target Version

Read and follow the **`new-app` skill** (`skills/new-app/SKILL.md`) to generate a fresh
application at `TO_VERSION`. Use a temporary directory so it does not interfere with the
project being migrated:

```bash
mkdir /tmp/c8y-reference-app
cd /tmp/c8y-reference-app
# … follow new-app skill steps with ng add @c8y/websdk@<TO_VERSION>
```

The reference app provides the canonical shape of every generated file at the target
version — use it as the ground truth for the comparison in Step 3.

---

## Step 3 — Compare Configuration Files

Diff the following files between the **reference app** (target version) and your
**project** (current version). For each file, apply the changes needed to align your
project with the new structure.

### Files to compare

| File | What to look for |
|---|---|
| `src/app/app.ts` | `ApplicationOptions`, feature flags, `runTime` / `buildTime` changes |
| `src/bootstrap.ts` | Bootstrap function signature, standalone vs. module-based setup |
| `angular.json` | `builder` targets, `styles` array, `assets` paths, budget thresholds |
| `package.json` | `@c8y/*` package versions, peer dependency constraints, scripts |
| `src/app/app.module.ts` | Module imports, lazy-loaded routes, removed / replaced modules |
| `src/app/app-routing.module.ts` | Route guards, lazy chunk syntax changes |
| `tsconfig.json` / `tsconfig.app.json` | `target`, `lib`, `strictTemplates`, decorator metadata |

### How to diff

Use VS Code's built-in diff, or run:

```bash
diff -u <PROJECT_ROOT>/<file> /tmp/c8y-reference-app/<file>
```

Or with `git diff` for colour output:

```bash
git diff --no-index <PROJECT_ROOT>/<file> /tmp/c8y-reference-app/<file>
```

### Applying changes

For each diffed file:

1. Copy new config keys / builder options that are missing from your project.
2. Remove keys that no longer exist in the reference app (they may have been renamed or
   deprecated).
3. Cross-reference with the breaking-changes report from Step 1 to confirm each change
   is intentional.
4. Do **not** blindly overwrite — preserve any project-specific customisations (app name,
   branding, custom routes, environment files).

---

## Step 4 — Apply Breaking-Change Fixes in Source Code

For each `BREAKING` item identified in Step 1:

1. Use the grep pattern to find all occurrences in `src/`.
2. Apply the fix described in the breaking-change entry (rename, API replacement,
   import path change, removed option, etc.).
3. After each fix, run the TypeScript compiler to catch regressions:
   ```bash
   npx tsc --noEmit
   ```
4. Optionally run the Angular build to surface template errors:
   ```bash
   ng build --configuration development
   ```

Repeat until `tsc --noEmit` and `ng build` both succeed without errors.

---

## Step 5 — Code Quality Review

Read and follow the **`code-quality-analysis` skill** (`skills/code-quality-analysis/SKILL.md`)
to run a full quality pass over the migrated source code.

Pay special attention to:

- **AP-01** — replace any leftover `*ngIf` / `*ngFor` / `*ngSwitch` with Angular's new
  control flow syntax (`@if`, `@for`, `@switch`) if the target version supports it.
- **AP-02** — excessive logic in components that should be moved to services.
- Any Cumulocity-specific anti-patterns flagged by the `mcp_c8y-docs_query-codex` queries.

Address all `BREAKING` and `HIGH` severity findings before considering the migration done.

---

## Checklist

Use this checklist to track migration progress:

- [ ] `FROM_VERSION` and `TO_VERSION` identified
- [ ] Breaking-changes report generated (`--format markdown` saved for reference)
- [ ] All `BREAKING` items catalogued
- [ ] Reference app scaffolded at `TO_VERSION`
- [ ] `app.ts` compared and updated
- [ ] `bootstrap.ts` compared and updated
- [ ] `angular.json` compared and updated
- [ ] `package.json` `@c8y/*` versions bumped and peer deps resolved
- [ ] `app.module.ts` / routing compared and updated
- [ ] `tsconfig.json` compared and updated
- [ ] All `BREAKING` source-code fixes applied
- [ ] `tsc --noEmit` passes
- [ ] `ng build` passes
- [ ] Code quality analysis completed
- [ ] All `HIGH` quality findings resolved
