// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:mime/mime.dart';
import 'package:mime/src/default_extension_map.dart';
import 'package:test/test.dart';

void main() {
  group('global-lookup-mime-type', () {
    test('valid-mime-type', () {
      expect(extensionFromMime('text/x-dart'), equals('dart'));
      expect(extensionFromMime('text/javascript'), equals('js'));
      expect(extensionFromMime('application/pdf'), equals('pdf'));
      expect(extensionFromMime('application/vnd.ms-excel'), equals('xls'));
      expect(extensionFromMime('application/xhtml+xml'), equals('xht'));
      expect(extensionFromMime('image/jpeg'), equals('jpg'));
      expect(extensionFromMime('image/png'), equals('png'));
      expect(extensionFromMime('text/css'), equals('css'));
      expect(extensionFromMime('text/html'), equals('htm'));
      // expect(extensionFromMime('text/plain'), equals('txt'));
      expect(extensionFromMime('text/x-c'), equals('c'));
    });

    test('invalid-mime-type', () {
      expect(extensionFromMime('invalid-mime-type'), 'invalid-mime-type');
      expect(extensionFromMime('invalid/mime/type'), 'invalid/mime/type');

      expect(
          extensionFromMime('invalid-mime-type', orElse: 'invalid'), 'invalid');
      expect(
          extensionFromMime('invalid/mime/type', orElse: 'invalid'), 'invalid');

      expect(extensionFromMimeOrNull('invalid-mime-type'), isNull);
      expect(extensionFromMimeOrNull('invalid/mime/type'), isNull);
    });

    test('unknown-mime-type', () {
      expect(extensionFromMime('application/to-be-invented'),
          'application/to-be-invented');

      expect(extensionFromMimeOrNull('application/to-be-invented'), isNull);
    });
  });

  group('add-mime-type', () {
    test('new-mime-type', () {
      expect(extensionFromMimeOrNull('custom/type'), isNull);
      addMimeType('custom/type', 'ct');
      expect(extensionFromMime('custom/type'), equals('ct'));
    });

    test('overridden-mime-type', () {
      expect(extensionFromMime('image/jpeg'), equals('jpg'));
      addMimeType('image/jpeg', 'jpeg');
      expect(extensionFromMime('image/jpeg'), equals('jpeg'));
    });

    test('check-preferred-present-for-non-unique', () {
      final mimeTypeToExtMap = <String, List<String>>{};
      for (var entry in defaultExtensionMap.entries) {
        final extensions = mimeTypeToExtMap.putIfAbsent(entry.value, () => []);
        extensions.add(entry.key);
      }
      final mimeTypesWithMultipleExtensions = Map.fromEntries(mimeTypeToExtMap
          .entries
          .where((element) => element.value.length > 1));
      for (var mimeType in mimeTypesWithMultipleExtensions.keys) {
        expect(
          hasPreferredExtension(mimeType),
          isTrue,
          reason: 'mimeType $mimeType with multiple extension, '
              'does not have preferred extension defined',
        );
      }
    });
  });
}
