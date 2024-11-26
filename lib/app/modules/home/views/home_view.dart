import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:notif/app/modules/home/views/notif.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HomeView'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                FlutterBackgroundService().invoke("setAsForeground");
              },
              child: Text("Foreground service"),
            ),
            ElevatedButton(
              onPressed: () {
                FlutterBackgroundService().invoke("setAsBackground");
              },
              child: Text("Background service"),
            ),
            Obx(() => ElevatedButton(
                  onPressed: () async {
                    final service = FlutterBackgroundService();
                    bool isRunning = await service.isRunning();
                    if (isRunning) {
                      service.invoke("setAsStop");
                    } else {
                      service.startService();
                    }
                    if (!isRunning) {
                      controller.seriveText.value = "Service Stop";
                    } else {
                      controller.seriveText.value = "Service Start";
                    }
                  },
                  child: Text(controller.seriveText.value),
                )),
            ElevatedButton(
              onPressed: () {
                NotificationService.showNotification(
                  title: 'Notifikasi Test',
                  body: 'Ini adalah notifikasi test!',
                );
              },
              child: const Text('Tampilkan Notifikasi'),
            ),
          ],
        ),
      ),
    );
  }
}
