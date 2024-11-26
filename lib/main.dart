import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:notif/app/modules/home/controllers/home_controller.dart';
import 'package:notif/permision.dart';
import 'package:permission_handler/permission_handler.dart';

import 'app/routes/app_pages.dart';

Future<void> main() async {
  final homeC = Get.put<HomeController>(HomeController(), permanent: true);

  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then(
    (value) {
      if (value) {
        Permission.notification.request();
      }
    },
  );
  await requestExactAlarmPermission();
  await homeC.initializeService();
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
