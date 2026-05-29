# cumulocity-skills

Machine-readable Agent Skills with modular guidance, examples, and best practices you can add to your agent.
Currently consisting of skills for scaffolding new Cumulocity apps, SDK migration, internationalization, code quality analysis, and architecture decisions.

---
## Purpose

### Advantages

- Centralized guidance for scaffolding, upgrading, and translating Cumulocity Web SDK applications.
- Repeatable workflows that combine the `ui-breaking-changes-cli`, Angular schematics, gettext tooling, and quality checks.
- Better audit quality by combining version-specific breaking-change reports with code review.
- Modular skill set that can be extended with new guides and analysis workflows.

---

## Quick install

1. Enable “Use Agent Skills” in Visual Studio Code:

![Enable Agent Skills](public/useAgentSkills.png)

2. Add the skill pack to your agent (runs via `npx`):

```bash
npx skills add Cumulocity-IoT/cumulocity-skills
```

3. Example agent prompts:

- "Use `new-app` to scaffold a new Cumulocity cockpit application at the `y2026-lts` SDK version without any interactive prompts."
- "Use `migration` to upgrade this app from `y2025-lts` to `y2026-lts` — detect breaking changes, scaffold a reference app, and compare configs."
- "Use `internationalization` to add Italian to this Cumulocity app, including downloading the framework `.pot` and wiring up the language switcher."
- "Use `code-quality-analysis` to review these changed Angular files and report anti-patterns with fixes."

---

## Available Skills

Frontend Skills:

| Skill | Path | Summary |
|---|---:|---|
| New App | [`skills/new-app/SKILL.md`](skills/new-app/SKILL.md) | Scaffold a new Cumulocity app with `@c8y/websdk` fully non-interactively. |
| Migration | [`skills/migration/SKILL.md`](skills/migration/SKILL.md) | End-to-end SDK upgrade: breaking-change detection, reference app, config diff, quality review. |
| Internationalization | [`skills/internationalization/SKILL.md`](skills/internationalization/SKILL.md) | Add or override translations, extract strings, manage `.po` files, wire up new languages. |
| Code Quality Analysis | [`skills/code-quality-analysis/SKILL.md`](skills/code-quality-analysis/SKILL.md) | Angular + Cumulocity quality checks and anti-pattern detection. |

Architecture Skills:

| Skill | Path | Summary |
|---|---:|---|
| Chassis Advisor | [`skills/c8y-architect-microservice-chassis-advisor/SKILL.md`](skills/c8y-architect-microservice-chassis-advisor/SKILL.md) | Decision matrix and recommendation workflow for microservice chassis selection. |
| Platform Migration PKI | [`skills/c8y-architect-platform-migration-pki/SKILL.md`](skills/c8y-architect-platform-migration-pki/SKILL.md) | Best practices and approaches for migrating PKI certificates to Cumulocity. |


---

## Agent Workflow

Use the workflow skills as entry points — they reference and orchestrate the others:

1. Start a new project with `new-app` to get a clean, correctly configured baseline.
2. Use `migration` to upgrade an existing app: runs the `ui-breaking-changes-cli`, scaffolds a reference app with `new-app`, and finishes with `code-quality-analysis`.
3. Use `internationalization` to add or override translations at any point in the lifecycle.
4. Run `code-quality-analysis` standalone on any changed files before opening a PR.

See [`AGENTS.md`](AGENTS.md) for a concise structure-first guide.

---

## References

- https://cumulocity.com/docs/web/gettingstarted/
- https://www.npmjs.com/package/@c8y/client
- https://www.npmjs.com/package/@c8y/ngx-components
- https://agentskills.io/specification

---

## License & Disclaimer

Provided as-is. See `LICENSE` for details. 

This project is provided as-is and without warranty or support. It is not a constitute part of the Cumulocity product suite. Users are free to use, fork and modify them, subject to the license agreement. While Cumulocity welcomes contributions, we cannot guarantee to include every contribution in the master project.
