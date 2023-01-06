// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:mime/mime.dart';
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
      addMimeType('custom/type', 'ct');
      expect(lookupExtension('custom/type'), equals('ct'));
    });

    test('overridden-mime-type', () {
      addMimeType('image/jpeg', 'jpeg');
      expect(lookupExtension('image/jpeg'), equals('jpeg'));
    });
  });
}