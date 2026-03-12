# Agents Guide

This repository contains modular Cumulocity skills under `skills/`.

## Project Structure

- `skills/c8y-client-api/SKILL.md`
  - Reference for `@c8y/client` services, methods, and API usage patterns.
- `skills/c8y-client-breaking-changelog/SKILL.md`
  - Breaking changes for `@c8y/client` across versions.
- `skills/c8y-client-migration-analysis/SKILL.md`
  - End-to-end migration audit workflow. Pulls context from changelog and API skills.
- `skills/code-quality-analysis/SKILL.md`
  - Code quality review workflow for Angular + Cumulocity projects. References external and local guidance.
- `skills/websdk-1018-upgrade/SKILL.md` to `skills/websdk-1023-upgrade/SKILL.md`
  - Version-specific Web SDK upgrade guidance.
- `skills/websdk-breaking-changelog/SKILL.md`
  - Breaking changes for Web SDK / `@c8y/ngx-components`.
- `skills/websdk-version-map/SKILL.md`
  - Version mapping context used during upgrade planning.

## Agent Usage Recommendation

Start with analysis skills first, because they are orchestration skills that reference other skills and define execution order:

1. Use `c8y-client-migration-analysis` for upgrade impact and migration audits.
2. Use `code-quality-analysis` for implementation quality, anti-patterns, and refactoring recommendations.

These analysis skills should be treated as entry points; they direct you to supporting skills like:

- `c8y-client-breaking-changelog`
- `websdk-breaking-changelog`
- version-specific `websdk-10xx-upgrade` skills
- `c8y-client-api`
- `websdk-version-map`

## Practical Flow

For upgrade work, follow this sequence:

1. Load `c8y-client-migration-analysis`.
2. Read referenced breaking changelog and target-version upgrade skills.
3. Use `c8y-client-api` and `websdk-version-map` to validate findings.
4. Run `code-quality-analysis` on changed files before finalizing recommendations.