---
name: websdk-version-map
description: Reference table mapping Cumulocity Web SDK release years to LTS aliases, primary minor versions, and support status. Use this to quickly look up which SDK version corresponds to a given year or LTS alias, and to determine which upgrade skill to apply.
---

# Cumulocity Web SDK – Release Year / Version Map

Use this reference to identify which Web SDK version corresponds to a given release year or LTS alias.

## Version Table

| Release Year | LTS Alias  | Primary Minor Version | Typical Support Range     |
|--------------|------------|-----------------------|---------------------------|
| 2026         | 2026-lts   | 1023.14.0             | Active (Latest)           |
| 2025         | 2025-lts   | 1021.22.0             | Maintenance               |
| 2024         | 2024-lts   | 1018.0.0              | Sustained Support         |
| 2023         | 2023-lts   | 1017.0.0              | Legacy (EOSS)             |

## Upgrade Skill Mapping

| From Version | To Version | Skill to Use            |
|--------------|------------|-------------------------|
| 1022.x       | 1023.x     | `websdk-1023-upgrade`   |
| 1021.x       | 1022.x     | `websdk-1022-upgrade`   |
| 1020.x       | 1021.x     | `websdk-1021-upgrade`   |
| 1019.x       | 1020.x     | `websdk-1020-upgrade`   |
| 1018.x       | 1019.x     | `websdk-1019-upgrade`   |
| 1017.x       | 1018.x     | `websdk-1018-upgrade`   |

## Notes

- The **primary minor version** listed is the first release of that LTS line (e.g. `1018.0.0`). Patch versions within a minor line (e.g. `1018.3.0`) are covered by the same upgrade skill.
- **EOSS** = End of Standard Support. Projects on 1017.x (2023-lts) should plan an upgrade path.
- When upgrading across multiple LTS generations, apply upgrade skills **one major step at a time** (e.g. 1018 → 1019 → 1020, not 1018 → 1023 directly).
- The 2026-lts line (1023.x) targets **Angular 20**; each prior LTS line corresponds to a lower Angular major version.
- Current status of moving bugfix versions can be found [here](https://www.npmjs.com/package/@c8y/ngx-components?activeTab=versions) by checking for tagged versions
