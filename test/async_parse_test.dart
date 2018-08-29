import 'dart:async';

import 'package:mime/mime.dart';
import 'package:test/test.dart';

void main() {
  test("Can parse valid data in chunks", () async {
    final controller = StreamController<List<int>>();
    final transformedStream =
        controller.stream.transform(MimeMultipartTransformer("xxx"));
    controller.add(_goodData.sublist(0, 10));

    // push the chunk to the next event
    Future(() {
      controller.add(_goodData.sublist(10));
      controller.close();
    });

    final parts = await transformedStream.toList();
    expect(parts.length, 2);
  });

  test(
      "If parsing fails on first part, error is emitted from stream and no further parts are parsed",
      () async {
    final controller = StreamController<List<int>>();
    final transformedStream =
        controller.stream.transform(MimeMultipartTransformer("xxx"));
    controller.add(_malformedFirstPart.sublist(0, 10));

    // push the chunk to the next event
    Future(() {
      controller.add(_malformedFirstPart.sublist(10));
      controller.close();
    });

    try {
      await transformedStream.toList();
      fail('unreachable');
    } on MimeMultipartException catch (e) {
      expect(e.message, contains("Failed to parse"));
    }

    expect(controller.done, completes);
  });

  test(
      "If parsing fails on 2nd part, error is emitted from stream after receiving first part",
      () async {
    final controller = StreamController<List<int>>();
    final transformedStream =
        controller.stream.transform(MimeMultipartTransformer("xxx"));
    controller.add(_malformedSecondPart.sublist(0, 10));

    final parts = <MimeMultipart>[];
    var error;
    transformedStream.listen((part) {
      parts.add(part);
    }, onError: (e, st) {
      error = e;
    });

    // push the chunk to the next event
    Future(() {
      controller.add(_malformedSecondPart.sublist(10));
      controller.close();
    });

    await controller.done;
    expect(parts.length, 1);
    expect(error.toString(), contains("MimeMultipartException"));
  });
}

// Invalid header for 1st part
final _malformedFirstPart = """
--xxx\r
Content-Disposition: form-data; name="a"\r
Content-Type: application/json; charset=invalid'\r
\r
[\r
{"key": "value1"}]\r
--xxx\r 
Content-Disposition: form-data; name="b"\r
\r 
xyhz\r
--xxx--\r
"""
    .codeUnits;

// Missing content from 2nd part
final _malformedSecondPart = """
--xxx\r
Content-Disposition: form-data; name="a"\r
Content-Type: application/json; charset=utf-8\r
\r
[\r
{"key": "value1"}]\r
--xxx\r 
Content-Disposition: form-data; name="b"'\r
\r
foobar\r
--xxx--\r
"""
    .codeUnits;

// Correctly formed, 2 part data
final _goodData = """
--xxx\r
Content-Disposition: form-data; name="a"\r
Content-Type: application/json; charset=utf-8\r
\r
[{"key": "value1"}]\r
--xxx\r
Content-Disposition: form-data; name="a"\r
Content-Type: text/plain\r
\r
text\r
--xxx--\r
"""
    .codeUnits;
