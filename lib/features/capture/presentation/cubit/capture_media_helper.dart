import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class CaptureMediaHelper {
  static Future<String> persistImage(File sourceFile, DateTime now) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final Directory imagesDir = Directory(
      path.join(appDir.path, 'stampzy_captures'),
    );
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    final String ext = path.extension(sourceFile.path).isEmpty
        ? '.jpg'
        : path.extension(sourceFile.path);
    final String filename = 'stamp_${now.millisecondsSinceEpoch}$ext';
    final String destinationPath = path.join(imagesDir.path, filename);

    final File copied = await File(sourceFile.path).copy(destinationPath);
    return copied.path;
  }

  static Future<String> persistRenderedImage(
    Uint8List renderedBytes,
    DateTime now,
  ) async {
    final Directory appDir = await getApplicationDocumentsDirectory();
    final Directory imagesDir = Directory(
      path.join(appDir.path, 'stampzy_captures'),
    );
    if (!await imagesDir.exists()) {
      await imagesDir.create(recursive: true);
    }

    final String filename = 'stamp_${now.millisecondsSinceEpoch}.png';
    final String destinationPath = path.join(imagesDir.path, filename);
    final File file = File(destinationPath);
    await file.writeAsBytes(renderedBytes, flush: true);
    return file.path;
  }

  static Future<bool> ensureCameraPermission() async {
    final PermissionStatus status = await Permission.camera.request();
    return status.isGranted || status.isLimited;
  }

  static Future<bool> ensureGalleryPermission() async {
    if (Platform.isIOS) {
      final PermissionStatus status = await Permission.photos.request();
      return status.isGranted || status.isLimited;
    }

    final PermissionStatus photosStatus = await Permission.photos.request();
    if (photosStatus.isGranted || photosStatus.isLimited) {
      return true;
    }

    final PermissionStatus storageStatus = await Permission.storage.request();
    return storageStatus.isGranted || storageStatus.isLimited;
  }
}
