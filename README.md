# cumulocity-skills
Agent skills as specified by https://agentskills.io/

# Cumulocity Agent Skills

This repository contains **Cumulocity Agent Skills** — structured knowledge modules that provide guidance, best practices, and examples for Cumulocity web development. Each skill is self-contained in its own folder and conforms to the [Agent Skills specification](https://agentskills.io/specification#frontmatter-required).

---

## Purpose

Agent Skills are designed to:

- **Centralize Knowledge**: Capture focused topics such as project setup, forms, icons, pipes, and design patterns in one place.  
- **Enable AI-Assisted Development**: Allow tools like GitHub Copilot to generate code aligned with best practices.  
- **Document Best Practices**: Provide instructions, version recommendations, accessibility guidance, and modular architecture patterns.

---

## Advantages

1. **Faster Onboarding**  
   New developers can quickly follow skills instead of searching through scattered documentation, reducing ramp-up time.

2. **Consistency Across Projects**  
   Ensures all projects adhere to the same architectural standards, coding conventions, and dependency management practices.

3. **Reduced Errors**  
   Includes known pitfalls, recommended LTS versions, and setup instructions to minimize mistakes.

4. **Seamless AI Integration**  
   AI agents can reference skills directly, generating code aligned with internal best practices and external documentation.

5. **Scalable Knowledge Base**  
   New skills can be added as new components, features, or design patterns emerge, without disrupting existing workflows.

---

## Getting Started

1. Browse all folders to see the available skills. Each folder contains a `SKILL.md` file with detailed guidance.  
2. Use the skills in your projects manually, or integrate them with **AI-assisted tools** like GitHub Copilot.  
3. Follow the instructions and best practices in each skill to create consistent, maintainable, and high-quality Cumulocity applications.
---

## Sample Usage

1. Create a new project

```
I want to create a new Cumulocity web project.
Follow the "cumulocity-new-project" skill from:
https://github.com/Cumulocity-IoT/cumulocity-skills
```
2. UI development

```
I want to create a form for a Cumulocity web application using Angular. 
Please follow the guidance from my skills repository at:
https://github.com/Cumulocity-IoT/cumulocity-skills
Create a complete Angular template snippet (`.html`) for the form.
```

## Available Skills

| Skill | Description |
|-------|-------------|
| [New Project](cumulocity-new-project-skill/SKILL.md) | Steps for initializing a new Cumulocity web project, with LTS version guidance and tutorial app examples |
| [Layout](cumulocity-layout-skill.md) | Guides to create clean, consistent HTML layouts aligned with the Cumulocity Codex design system foundations |

---

## References

- [Cumulocity Documentation – Getting Started](https://cumulocity.com/docs/web/gettingstarted/)  
- [Cumulocity Tutorial App on GitHub](https://github.com/Cumulocity-IoT/tutorial)
- [Codex](https://cumulocity.com/codex/)
- [Agent Skills Specification](https://agentskills.io/specification)

## Disclaimer

This repository is provided as-is and without warranty or support. It is not a constitute part of the Cumulocity product suite. Users are free to use, fork and modify them, subject to the license agreement. While Cumulocity welcomes contributions, we cannot guarantee to include every contribution in the master project.
