# Agents Guide

This repository contains modular Cumulocity skills under `skills/`.

## Project Structure

- `skills/code-quality-analysis/SKILL.md`
  - Code quality review workflow for Angular + Cumulocity projects. References external and local guidance.
- `skills/new-app/SKILL.md`
  - Scaffold a new Cumulocity application with `@c8y/websdk` fully non-interactively. Covers Angular CLI setup, schematic installation, AI tools configuration, dev server, and build commands.
- `skills/migration/SKILL.md`
  - End-to-end migration guide: detect breaking changes with the `ui-breaking-changes-cli`, scaffold a reference app at the target version with the `new-app` skill, compare key config files, and finish with a `code-quality-analysis` review.

## Agent Usage Recommendation

- Use `new-app` to scaffold a new Cumulocity application non-interactively.
- Use `code-quality-analysis` for implementation quality, anti-patterns, and refactoring recommendations.
- Use `migration` to upgrade an existing Cumulocity application to a new SDK version end-to-end.