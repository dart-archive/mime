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

/// Lookup file extension for a given MIME type.
///
/// If there are multiple extensions for [mimeType], return preferred extension
/// if defined, or the first occurrence in the map.
/// If no extension is found, `null` is returned.
String? extensionFromMime(String mimeType) {
  final mimeTypeLC = mimeType.toLowerCase();
  if (_preferredExtensionsMap.containsKey(mimeTypeLC)) {
    return _preferredExtensionsMap[mimeTypeLC]!;
  }
  return defaultExtensionMap.entries
      .firstWhereOrNull((entry) => entry.value == mimeTypeLC)
      ?.key;
}

/// Allow for a user-specified MIME type-extension mapping that overrides the
/// default.
void addMimeType(String mimeType, String extension) {
  _preferredExtensionsMap[mimeType.toLowerCase()] = extension.toLowerCase();
}

extension _IterableExtension<T> on Iterable<T> {
  /// The first element satisfying [test], or `null` if there are none.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}