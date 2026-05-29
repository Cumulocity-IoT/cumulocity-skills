# Agents Guide

This repository contains modular Cumulocity skills under `skills/`.

## Project Structure

- `skills/code-quality-analysis/SKILL.md`
  - Code quality review workflow for Angular + Cumulocity projects. References external and local guidance.
- `skills/new-app/SKILL.md`
  - Scaffold a new Cumulocity application with `@c8y/websdk` fully non-interactively. Covers Angular CLI setup, schematic installation, AI tools configuration, dev server, and build commands.
- `skills/migration/SKILL.md`
  - End-to-end migration guide: detect breaking changes with the `ui-breaking-changes-cli`, scaffold a reference app at the target version with the `new-app` skill, compare key config files, and finish with a `code-quality-analysis` review.
- `skills/internationalization/SKILL.md`
  - Complete i18n guide: annotate strings with `gettext()` / `translate` pipe / directive, extract to `.pot`, create and update `.po` files, override built-in translations, and add brand-new languages including the merged-`.pot` workflow.

## MCP Server — Cumulocity Codex

Several skills call `mcp_c8y-docs_*` tools to query the Cumulocity Codex documentation
at runtime. These tools are provided by a hosted MCP server:

| Property | Value |
|---|---|
| **Server name** | `c8y-docs` |
| **Transport** | HTTP (SSE) |
| **URL** | `https://c8y-codex-mcp.schplitt.workers.dev/` |

**Add it to your agent once before using these skills:**

```bash
# Claude Code
claude mcp add --transport http c8y-docs https://c8y-codex-mcp.schplitt.workers.dev/
```

Or add it to your agent's MCP config file (e.g. `.mcp.json` for Claude Code projects):

```json
{
  "mcpServers": {
    "c8y-docs": {
      "url": "https://c8y-codex-mcp.schplitt.workers.dev/"
    }
  }
}
```

Once registered, the agent can call:
- `mcp_c8y-docs_get-codex-structure` — returns the full Codex section/subsection map
- `mcp_c8y-docs_query-codex` — keyword search across all Cumulocity documentation

---

## Agent Usage Recommendation

- Use `new-app` to scaffold a new Cumulocity application non-interactively.
- Use `code-quality-analysis` for implementation quality, anti-patterns, and refactoring recommendations.
- Use `migration` to upgrade an existing Cumulocity application to a new SDK version end-to-end.
- Use `internationalization` to add or override translations, wire up new languages, or set up the full gettext extraction and `.po` file workflow.