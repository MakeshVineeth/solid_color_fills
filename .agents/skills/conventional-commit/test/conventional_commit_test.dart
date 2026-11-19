import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Conventional Commit Validation', () {
    final commitRegex = RegExp(
      r'^(feat|fix|refactor|perf|test|docs|chore|style|ci)(\([a-zA-Z0-9_\-]+\))?(!)?:\s+[a-z0-9].{0,72}$',
    );

    test('valid commit messages pass convention', () {
      final validSamples = [
        'feat(wallpaper): add home screen target application',
        'fix(color_picker): normalize 6-digit hex input values',
        'refactor(collections): decouple data source from UI grid card',
        'docs(adr): add architecture decision record for Android 16',
        'chore(deps): upgrade dependencies to latest versions',
      ];

      for (final msg in validSamples) {
        expect(commitRegex.hasMatch(msg), isTrue, reason: 'Failed on: $msg');
      }
    });

    test('invalid commit messages fail convention', () {
      final invalidSamples = [
        'Updated color picker', // No type/scope
        'feat: Added new button', // Capitalized subject
        'fix(calc): fixed bug.', // Ends with period
        '', // Empty
      ];

      for (final msg in invalidSamples) {
        expect(commitRegex.hasMatch(msg), isFalse, reason: 'Should fail on: $msg');
      }
    });
  });
}
