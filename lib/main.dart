import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pp_bluetooth_kit_flutter/ble/pp_bluetooth_kit_manager.dart';
import 'package:pp_bluetooth_kit_flutter/utils/pp_bluetooth_kit_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_screen.dart';
import 'onboarding_screen.dart';

import 'app_state.dart';



Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PPBluetoothKitLogger.addListener(callBack: (log) {
    print('SDK-Log:$log');
  });


  final configPath = 'config/lefu.config';
  String content = await rootBundle.loadString(configPath);
  PPBluetoothKitManager.initSDK(
    'lefu0eb0a285268f22c7',
    'oA0pdd57IJxmFqgvh1iQt4XyDxyQy8XDkTRTbsYFo0I=',
    content,
  );
  final prefs = await SharedPreferences.getInstance();
  final done = prefs.getBool('onboarding_done') ?? false;

  final deviceSettingPath = 'config/Device.json';
  try {
    String jsonStr = await rootBundle.loadString(deviceSettingPath);
    PPBluetoothKitManager.setDeviceSetting(jsonStr);
    print("Device settings loaded successfully");
  } catch (e) {
    print("Error loading device settings: $e");
  }
  await AppState.instance.load();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SAUYT.SCALE',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: FutureBuilder<SharedPreferences>(
        future: SharedPreferences.getInstance(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          final done = snapshot.data!.getBool('onboarding_done') ?? false;
          return done ? const MainScreen() : const OnboardingScreen();
        },
      ),
    );
  }
}