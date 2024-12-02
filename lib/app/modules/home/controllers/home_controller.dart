import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:notif/app/modules/home/views/notif.dart';
import 'package:notif/app/modules/play_video/views/play_video_view.dart';
import 'package:notif/app/routes/app_pages.dart';
import 'package:notif/app/services/mqtt_service.dart';

class HomeController extends GetxController {
  final messageController = TextEditingController();
  RxString seriveText = "Service stop".obs;
  @override
  void onInit() {
    super.onInit();
    listenToNotifications();
  }

  Future<void> listenToNotifications() async {
    print("Listening to notification");
    NotificationService.onCliknotif.stream.listen((event) {
      Get.to(() => const PlayVideoView());
      // Get.dialog(
      //   AlertDialog(
      //     title: Text('Notification'),
      //     content: Text("event.body"),
      //     actions: [
      //       TextButton(
      //         onPressed: () {
      //           Get.back();
      //         },
      //         child: Text('OK'),
      //       ),
      //     ],
      //   ),
      // );
    });
  }

  Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    await service.configure(
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onServiceStart,
        onBackground: onIosBackground,
      ),
      androidConfiguration: AndroidConfiguration(
        onStart: onServiceStart,
        isForegroundMode: true,
        autoStart: false,
        // foregroundServiceTypes: [AndroidForegroundType.location]
      ),
    );
  }

  @pragma('vm:entry-point')
  Future<bool> onIosBackground(ServiceInstance service) async {
    WidgetsFlutterBinding.ensureInitialized();
    DartPluginRegistrant.ensureInitialized();
    return true;
  }
}

// Fungsi top-level untuk background service
@pragma('vm:entry-point')
void onServiceStart(ServiceInstance service) async {
  var text = "service background";

  DartPluginRegistrant.ensureInitialized();

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      text = "service foreground";
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
      text = "service background";
    });
  }

  service.on('setAsStop').listen((event) {
    service.stopSelf();
  });
  var index = 1;
  // Connect to MQTT when service starts
  await MqttService.connect();

  Timer.periodic(Duration(seconds: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      print(text);
      // Keep subscription active
      if (MqttService.client?.connectionStatus?.state ==
          MqttConnectionState.connected) {
        MqttService.subscribe('notip');
      } else {
        // Reconnect if connection lost
        await MqttService.connect();
      }
    }
    service.invoke("update");
  });
  // Timer.periodic(
  //   Duration(seconds: 1),
  //   (timer) async {
  //     print(index);
  //     if (service is AndroidServiceInstance) {
  //       // MqttService.subscribe(MqttService.topicSubController.text);

  //       // if (index == 10) {
  //       //   NotificationService.showNotification(
  //       //       23, "haiii", "notif ini sepol", "content");
  //       //   index = 1;
  //       // }
  //       // index++;
  //       // service.setForegroundNotificationInfo(
  //       //     title: "title", content: "content");
  //       //   // print("object");
  //     }
  //     print(text);
  //     service.invoke("update");
  //   },
  // );
}
