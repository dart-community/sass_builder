import 'dart:convert';

import 'package:build/build.dart';
import 'package:sass/sass.dart';

/// An [AsyncCallable] reading absolute URLs from the build system.
AsyncCallable readAssetCallable(BuildStep step) {
  return AsyncCallable.fromSignature(
      r'read-string($asset, $dataUriMimeType: "")', (values) async {
    final [rawAssetId, rawDataUriMimeType] = values;

    // Note: We only accept absolute URLs here. We could try to resolve URLs
    // against the input id, but that would break if this function is used in
    // imported SCSS files.
    final id =
        AssetId.resolve(Uri.parse(rawAssetId.assertString('asset').text));
    final dataUriMimeType =
        rawDataUriMimeType.assertString('dataUriMimeType').text;

    final contents = await step.readAsString(id);
    if (dataUriMimeType.isEmpty) {
      return SassString(contents);
    }

    return SassString(
        Uri.dataFromString(contents, encoding: utf8, mimeType: dataUriMimeType)
            .toString());
  });
}
