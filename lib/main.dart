import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'app/di/injection_container.dart';
import 'app/stampzy_app.dart';
import 'core/services/location_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  List<CameraDescription> cameras = [];
  try {
    cameras = await availableCameras();
  } catch (e) {
    debugPrint('Error fetching cameras in main: $e');
  }

  await initDependencies(cameras: cameras);
  
  // Request location permissions at app start
  await LocationService.requestPermission();
  
  runApp(const StampzyApp());
}
