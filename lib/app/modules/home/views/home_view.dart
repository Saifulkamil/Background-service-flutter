import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:notif/app/modules/home/views/notif.dart';
import 'package:notif/app/routes/app_pages.dart';
import '../../../services/mqtt_service.dart';
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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              width: Get.width / 1.5,
              child: TextField(
                controller: MqttService.hostController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'topic',
                ),
              ),
            ),
            SizedBox(
              height:10,
            ),
            SizedBox(
              width: Get.width / 1.5,
              child: TextField(
                controller: MqttService.topicSubController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'topic Subcribe',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (MqttService.client?.connectionStatus?.state ==
                    MqttConnectionState.connected) {
                  MqttService.client?.disconnect();
                } else {
                  MqttService.connect();
                  MqttService.subscribe(MqttService.topicSubController.text);
                }
              },
              child: Obx(() => Text(MqttService.mqttText.value)),
            ),
            SizedBox(
              height: 100,
            ),
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
                    23, "haiii", "notif ini sepol", "content");
              },
              child: const Text('Tampilkan Notifikasi'),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                Get.toNamed(Routes.MTQQ);
              },
              child: const Text('MQTT TESTING'),
            ),
          ],
        ),
      ),
    );
  }
}
