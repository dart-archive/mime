[![Build Status](https://travis-ci.org/dart-lang/mime.svg?branch=master)](https://travis-ci.org/dart-lang/mime)

Package for working with MIME type definitions and for processing
streams of MIME multipart media types.

## Determining the MIME type for a file

The `MimeTypeResolver` class can be used to determine the MIME type of
a file. It supports both using the extension of the file name and
looking at magic bytes from the beginning of the file.

There is a builtin instance of `MimeTypeResolver` accessible through
the top level function `lookupMimeType`. This builtin instance has
the most common file name extensions and magic bytes registered.

```dart
print(lookupMimeType('test.html'));  // Will print text/html
print(lookupMimeType('test', [0xFF, 0xD8]));  // Will print image/jpeg
print(lookupMimeType('test.html', [0xFF, 0xD8]));  // Will print image/jpeg
```

You can build you own resolver by creating an instance of
`MimeTypeResolver` and adding file name extensions and magic bytes
using `addExtension` and `addMagicNumber`.

## Processing MIME multipart media types

The class `MimeMultipartTransformer` is used to process a `Stream` of
bytes encoded using a MIME multipart media types encoding. The
transformer provides a new `Stream` of `MimeMultipart` objects each of
which have the headers and the content of each part. The content of a
part is provided as a stream of bytes.

Below is an example showing how to process an HTTP request and print
the length of the content of each part.

```dart
// HTTP request with content type multipart/form-data.
HttpRequest request = ...;
// Determine the boundary form the content type header
String boundary = request.headers.contentType.parameters['boundary'];

// Process the body just calculating the length of each part.
request
    .transform(new MimeMultipartTransformer(boundary))
    .map((part) => part.fold(0, (p, d) => p + d))
    .listen((length) => print('Part with length $length'));
```

Take a look at the `HttpBodyHandler` in the [http_server][http_server]
package for handling different content types in an HTTP request.

## Features and bugs

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://github.com/dart-lang/sample/issues
[http_server]: https://pub.dartlang.org/packages/http_server
