#!/usr/bin/env python3
"""Pre-commit PII and Secrets Scanner for Solid Color Fills."""

import os
import re
import sys

PATTERNS = {
    'Private Key': re.compile(r'-----BEGIN (?:RSA |DSA |EC |OPENSSH )?PRIVATE KEY-----'),
    'Generic Secret': re.compile(r'(?:api_key|apikey|secret_key|app_secret|auth_token)\s*[:=]\s*[\'"][0-9a-zA-Z\-_]{16,}[\'"]', re.IGNORECASE),
    'Google API Key': re.compile(r'AIza[0-9A-Za-z\-_]{35}'),
    'GitHub Token': re.compile(r'(?:ghp|gho|ghu|ghs|ghr)_[A-Za-z0-9_]{36,255}'),
    'AWS Access Key': re.compile(r'(?:AKIA|ASIA)[0-9A-Z]{16}'),
    'Bearer Token': re.compile(r'bearer\s+[a-zA-Z0-9_\-\.]{20,}', re.IGNORECASE),
    'Personal Email': re.compile(r'\b[A-Za-z0-9._%+-]+@(?!example\.com|users\.noreply\.github\.com)[A-Za-z0-9.-]+\.[A-Za-z]{2,}\b', re.IGNORECASE),
    'Hardcoded Password': re.compile(r'(?:password|passwd|pwd)\s*[:=]\s*[\'"][^\'"]{6,}[\'"]', re.IGNORECASE),
}

IGNORED_EXTENSIONS = {'.png', '.jpg', '.jpeg', '.zip', '.ico', '.keystore', '.jks', '.lock'}

def main():
    repo_root = os.path.abspath(os.path.join(os.path.dirname(__file__), '..', '..', '..'))
    target_dirs = ['lib', 'test', 'android/app/src']
    findings = []
    files_scanned = 0

    for target in target_dirs:
        dir_path = os.path.join(repo_root, target)
        if not os.path.exists(dir_path):
            continue

        for root, _, files in os.walk(dir_path):
            for file in files:
                ext = os.path.splitext(file)[1].lower()
                if ext in IGNORED_EXTENSIONS or file.endswith('.g.dart'):
                    continue

                file_path = os.path.join(root, file)
                files_scanned += 1

                try:
                    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                        for line_idx, line in enumerate(f, 1):
                            if 'ALLOW_PII_TEST' in line:
                                continue
                            for label, pattern in PATTERNS.items():
                                if pattern.search(line):
                                    rel_path = os.path.relpath(file_path, repo_root)
                                    findings.append(f"[{label}] {rel_path}:{line_idx} - {line.strip()}")
                except Exception as e:
                    print(f"Warning: Could not read {file_path}: {e}", file=sys.stderr)

    if findings:
        print("\n❌ PII / Secrets Scan FAILED! Potential sensitive data found:", file=sys.stderr)
        for f in findings:
            print(f"  - {f}", file=sys.stderr)
        print("\nPlease sanitize before committing.\n", file=sys.stderr)
        sys.exit(1)
    else:
        print(f"✅ PII & Secrets scan clean: {files_scanned} files checked. No secrets found.")
        sys.exit(0)

if __name__ == '__main__':
    main()
