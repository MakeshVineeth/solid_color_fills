import 'dart:io';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Clean Architecture Architectural Rules', () {
    test('domain layer files must never import Flutter UI framework', () {
      final repoRoot = Directory.current;
      final libDir = Directory('${repoRoot.path}/lib');
      if (!libDir.existsSync()) return;

      final domainFiles = libDir
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.contains('/domain/') || f.path.contains('\\domain\\'));

      for (final file in domainFiles) {
        final content = file.readAsStringSync();
        expect(
          content.contains("import 'package:flutter/material.dart'"),
          isFalse,
          reason: 'Domain file ${file.path} must not import flutter/material.dart',
        );
        expect(
          content.contains("import 'package:flutter/widgets.dart'"),
          isFalse,
          reason: 'Domain file ${file.path} must not import flutter/widgets.dart',
        );
      }
    });
  });
}
