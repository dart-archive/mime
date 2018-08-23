import 'dart:async';

import 'package:mime/mime.dart';
import 'package:test/test.dart';

void main() {
  test("error is emitted from stream during parse ", () async {
    final input = """
--xxxh\r
Content-Disposition: form-data; name="a"\r
Content-Type: application/json; charset=utf-8',\r
[\r
{"key": "value1"}]\r
--xxx--\r\n
"""
        .codeUnits;

    try {
      final controller = Stream.fromIterable([input])
          .transform(MimeMultipartTransformer("xxx"));
      await controller.toList();
      fail('unreachable');
    } on MimeMultipartException catch (e) {
      expect(e.message, contains("Failed to parse"));
    }
  });
}
