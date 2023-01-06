// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:collection/collection.dart';

import 'default_extension_map.dart';

/// Add an override for common extensions since different extensions may map
/// to the same MIME type.
final Map<String, String> _preferredExtensionsMap = <String, String>{
  'application/vnd.ms-excel': 'xls',
  'image/jpeg': 'jpg',
  'text/x-c': 'c'
};

/// Lookup file extension by a given MIME type.
/// If no extension is found, `null` is returned.
String? lookupExtension(String mimeType) {
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

bool hasPreferredExtension(String mimeType) =>
    _preferredExtensionsMap.containsKey(mimeType.toLowerCase());