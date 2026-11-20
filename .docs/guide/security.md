# Security Guide (OWASP Mobile Top 10)

This document details the security posture and defenses implemented in Solid Color Fills.

---

## 1. Network Traffic (OWASP M5, M8)
- Android `network_security_config.xml` explicitly enforces `cleartextTrafficPermitted="false"`.
- External URLs (e.g. GitHub repository, privacy policy) use strict HTTPS.

## 2. Data Storage & Privacy (OWASP M6, M9)
- `android:allowBackup="false"` in `AndroidManifest.xml` prevents arbitrary app data extraction via ADB.
- User wallpaper choices, favorites, and settings are strictly kept local on-device. Zero telemetry or personal data is collected or transmitted off-device.

## 3. Sensitive Screen Protection (OWASP M7)
- `WindowSecurityManager` enables `FLAG_SECURE` (`flutter_windowmanager_plus`) when sensitive or privacy-conscious views are rendered, blocking screenshots and task switcher leaks.

## 4. Input Sanitization (OWASP M4)
- User hex color inputs are validated and normalized using strict regular expressions in `InputValidator`.
- Length and character restrictions prevent malformed string crashes or buffer overflow vulnerabilities.

## 5. Pre-Commit Verification
- Automated PII and secrets scanner (`scan_pii.dart`) runs before every commit to verify that no keys, tokens, or developer credentials leak into version control.
