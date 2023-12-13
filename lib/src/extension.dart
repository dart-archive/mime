// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'default_extension_map.dart';

/// Add an override for common extensions since different extensions may map
/// to the same MIME type.
final Map<String, String> _preferredExtensionsMap = <String, String>{
  'application/vnd.ms-excel': 'xls',
  'application/vnd.ms-powerpoint': 'ppt',
  'image/jpeg': 'jpg',
  'image/tiff': 'tif',
  'image/svg+xml': 'svg',
  'text/calendar': 'ics',
  'text/javascript': 'js',
  'text/plain': 'txt',
  'text/sgml': 'sgml',
  'text/x-pascal': 'pas',
  'video/mp4': 'mp4',
  'video/mpeg': 'mpg',
  'video/quicktime': 'mov',
  'video/x-matroska': 'mkv',
};

/// The extension for a given MIME type.
///
/// If there are multiple extensions for [mimeType], return preferred extension
/// if defined, otherwise an extension chosen by the library.
/// If no extension is found, `null` is returned.
String? extensionFromMime(String mimeType) {
  final mimeTypeLC = mimeType.toLowerCase();
  if (_preferredExtensionsMap.containsKey(mimeTypeLC)) {
    return _preferredExtensionsMap[mimeTypeLC]!;
  }

  for (final entry in defaultExtensionMap.entries) {
    if (entry.value == mimeTypeLC) return entry.key;
  }
  return null;
}
