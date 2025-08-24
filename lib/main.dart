import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_demo/app.dart';
import 'package:firebase_demo/fcm_service.dart';
import 'package:flutter/material.dart';

import 'firebase_options.dart';

Future<void> main() async {
  final FCMService fcmService = FCMService();

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await fcmService.initialize();
  print(await fcmService.getFcmToken());
  await fcmService.onTokenRefresh();

  runApp(const LiveScoreApp());
}






