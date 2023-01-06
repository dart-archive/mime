// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:mime/mime.dart';
import 'package:mime/src/default_extension_map.dart';
import 'package:test/test.dart';

void main() {
  group('global-lookup-mime-type', () {
    test('valid-mime-type', () {
      expect(lookupExtension('text/x-dart'), equals('dart'));
      expect(lookupExtension('text/javascript'), equals('js'));
      expect(lookupExtension('application/pdf'), equals('pdf'));
      expect(lookupExtension('application/vnd.ms-excel'), equals('xls'));
      expect(lookupExtension('application/xhtml+xml'), equals('xht'));
      expect(lookupExtension('image/jpeg'), equals('jpg'));
      expect(lookupExtension('image/png'), equals('png'));
      expect(lookupExtension('text/css'), equals('css'));
      expect(lookupExtension('text/html'), equals('htm'));
      // expect(lookupExtension('text/plain'), equals('txt'));
      expect(lookupExtension('text/x-c'), equals('c'));
    });

    test('invalid-mime-type', () {
      expect(lookupExtension('invalid-mime-type'), isNull);
    });

    test('unknown-mime-type', () {
      expect(lookupExtension('application/to-be-invented'), isNull);
    });
  });

  group('add-mime-type', () {
    test('new-mime-type', () {
      expect(lookupExtension('custom/type'), isNull);
      addMimeType('custom/type', 'ct');
      expect(lookupExtension('custom/type'), equals('ct'));
    });

    test('overridden-mime-type', () {
      expect(lookupExtension('image/jpeg'), equals('jpg'));
      addMimeType('image/jpeg', 'jpeg');
      expect(lookupExtension('image/jpeg'), equals('jpeg'));
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
