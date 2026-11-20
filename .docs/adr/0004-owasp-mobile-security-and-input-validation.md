# 4. OWASP Mobile Security Hardening & Input Validation

Date: 2026-11-19

## Status
Accepted

## Context
Mobile apps must comply with OWASP Mobile Top 10 security standards, ensuring user privacy, blocking cleartext traffic, preventing improper input evaluation, and safeguarding local data.

## Decision
1. **Network Security (OWASP M5, M8)**: Implemented `network_security_config.xml` explicitly disallowing cleartext HTTP (`cleartextTrafficPermitted="false"`).
2. **Data Backup Protection (OWASP M6)**: Set `android:allowBackup="false"` to prevent unauthorized extraction of application state via ADB backups.
3. **Input Sanitization (OWASP M4)**: Created `InputValidator` to validate and normalize all user hex inputs before parsing.
4. **Sensitive Screen Protection (OWASP M7)**: Integrated `flutter_windowmanager_plus` for `FLAG_SECURE` support.

## Consequences
- Solid Color Fills meets OWASP Mobile Top 10 security benchmarks.
- No network traffic is permitted in cleartext.
