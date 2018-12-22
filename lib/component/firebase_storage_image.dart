import 'dart:ui' show Codec;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show SynchronousFuture;

class FirebaseStorageImage extends ImageProvider<FirebaseStorageImage> {
  final Uri storageLocation;
  final double scale;
  final int maxSizeBytes;

  FirebaseStorageImage(
    this.storageLocation, {
    this.scale = 1.0,
    this.maxSizeBytes = 1000 * 1000 * 1000,
  })  : assert(storageLocation != null),
        assert(scale != null),
        assert(maxSizeBytes != null);

  @override
  Future<FirebaseStorageImage> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture<FirebaseStorageImage>(this);

  @override
  ImageStreamCompleter load(FirebaseStorageImage key) =>
      MultiFrameImageStreamCompleter(
          codec: _fetch(key),
          scale: key.scale,
          informationCollector: (StringBuffer information) {
            information.writeln('Image provider: $this');
            information.write('Image key: $key');
          });

  static Future<Codec> _fetch(FirebaseStorageImage key) async {
    final storage =
        FirebaseStorage(storageBucket: _getBucketUrl(key.storageLocation))
            .ref()
            .child(key.storageLocation.path);

    final bytes = await storage.getData(key.maxSizeBytes);

    return await PaintingBinding.instance.instantiateImageCodec(bytes);
  }

  static String _getBucketUrl(Uri uri) => '${uri.scheme}://${uri.authority}';
}
