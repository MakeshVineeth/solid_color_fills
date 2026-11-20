#!/usr/bin/env python3
"""Evaluation suite for Conventional Commits 1.0.0 compliance."""

import re
import sys

COMMIT_REGEX = re.compile(
    r'^(feat|fix|refactor|perf|test|docs|chore|style|ci)(\([a-zA-Z0-9_\-]+\))?(!)?:\s+[a-z0-9].{0,72}$'
)

TEST_CASES = [
    # (message, should_pass)
    ("feat(wallpaper): implement custom canvas encoder", True),
    ("fix(color_picker): clamp rgb values between 0 and 255", True),
    ("refactor(core): decouple preferences service contract", True),
    ("docs(adr): add architecture decision record 0006", True),
    ("test(responsive): add tablet and tv multi device tests", True),
    ("chore(deps): upgrade packages to latest major versions", True),
    ("ci(workflow): add pre commit scan pii step", True),
    ("feat!: breaking change without scope", True),
    ("Updated color picker", False),
    ("feat: Added capitalized subject", False),
    ("fix(calc): period at end.", False),
    ("", False),
    ("random commit message without structure", False),
]

def run_evals():
    passed = 0
    failed = 0

    print("Running Conventional Commit Evaluation Suite...")
    for msg, expected in TEST_CASES:
        actual = bool(COMMIT_REGEX.match(msg))
        if actual == expected:
            passed += 1
            print(f"  ✓ PASS: '{msg}' -> {actual}")
        else:
            failed += 1
            print(f"  ✗ FAIL: '{msg}' (expected {expected}, got {actual})")

    print(f"\nResult: {passed}/{len(TEST_CASES)} passed.")
    if failed > 0:
        sys.exit(1)
    sys.exit(0)

if __name__ == '__main__':
    run_evals()
