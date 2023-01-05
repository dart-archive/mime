// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test/test.dart';
import 'package:mime/mime.dart';

void main() {
  group('lookup-mime-type', () {
    test('valid-mime-type', () {
      expect(lookupExtension('application/dart'), equals('dart'));
      expect(lookupExtension('application/javascript'), equals('js'));
      expect(lookupExtension('application/pdf'), equals('pdf'));
      expect(lookupExtension('application/vnd.ms-excel'), equals('xls'));
      expect(lookupExtension('application/xhtml+xml'), equals('xhtml'));
      expect(lookupExtension('image/jpeg'), equals('jpg'));
      expect(lookupExtension('image/png'), equals('png'));
      expect(lookupExtension('text/css'), equals('css'));
      expect(lookupExtension('text/html'), equals('html'));
      expect(lookupExtension('text/plain'), equals('txt'));
      expect(lookupExtension('text/x-c'), equals('c'));
    });

    test('invalid-mime-type', () {
      expect(lookupExtension('invalid-content-type'), isNull);
      expect(lookupExtension('invalid/content-type'), isNull);
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