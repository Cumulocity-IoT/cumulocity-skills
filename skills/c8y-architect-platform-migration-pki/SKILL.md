---
name: c8y-architect-platform-migration-pki
description: 'Recommends and support the best approach for migrating PKI certificates when moving from another platform or PKI to Cumulocity. Use when a developer or architect asks about how to migrate existing PKI certificates to Cumulocity, how to handle certificate rotation during migration, or best practices for PKI management in Cumulocity.'
argument-hint: 'Describe your PKI migration scenario: current platform, type of certificates, number of certificates, rotation requirements, and any constraints (e.g. "Migrating 100 device certificates from AWS IoT to Cumulocity with minimal downtime")'
---

# Cumulocity Platform Migration — PKI & Certificate Advisor

## Procedure

1. Read the relevant reference document(s) from the **Bundled Assets** table below based on the user's scenario.
2. Use the loaded document as the primary source for recommendations, architecture decisions, and implementation guidance.
3. Tailor the advice to the user's specific constraints (fleet size, hardware capabilities, legacy platform, rollback requirements).

---

## Bundled Assets

| Asset | Scenario |
|-------|---------|
| [`references/PKI-migration.md`](references/PKI-migration.md) | Large-scale fleet migration (250k+ devices) using Cumulocity EST enrollment, bulk CSV registration, HMAC-derived OTPs, and atomic rollback watchdogs |