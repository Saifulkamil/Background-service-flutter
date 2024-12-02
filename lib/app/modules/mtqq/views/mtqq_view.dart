import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:notif/app/services/mqtt_service.dart';

import '../controllers/mtqq_controller.dart';

class MtqqView extends GetView<MtqqController> {
  const MtqqView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('MtqqView'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            SizedBox(
              width: Get.width / 1.5,
              child: TextField(
                controller: MqttService.hostController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Host',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                if (MqttService.client?.connectionStatus?.state ==
                    MqttConnectionState.connected) {
                  MqttService.client?.disconnect();
                } else {
                  MqttService.connect();
                }
              },
              child: Obx(() => Text(MqttService.mqttText.value)),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: Get.width / 1.5,
              child: TextField(
                controller: MqttService.topicPubController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'topic',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              width: Get.width / 1.5,
              child: TextField(
                controller: MqttService.messegeController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'message',
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
              onPressed: () async {
                if (MqttService.client?.connectionStatus?.state ==
                    MqttConnectionState.connected) {
                  // MqttService.onSubscribed(MqttService.topicController.text);
                  MqttService.publish(MqttService.topicPubController.text,
                      MqttService.messegeController.text);
                  MqttService.messegeController.clear();
                }
              },
              child: Obx(() => Text(MqttService.pubText.value)),
            ),
            const SizedBox(
              height: 20,
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
                  MqttService.subscribe(MqttService.topicSubController.text);
                  MqttService.topicSubController.clear();
                }
              },
              child: Obx(() => Text(MqttService.subText.value)),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(() => Expanded(
                  child: ListView.builder(
                    itemCount: MqttService.messagesList.length,
                    itemBuilder: (context, index) {
                      return Obx(() => ListTile(
                            title: Text(MqttService.messagesList[index]),
                            trailing: IconButton(
                              onPressed: () {
                                MqttService.messagesList.removeAt(index);
                              },
                              icon: const Icon(Icons.delete),
                            ),
                          ));
                    },
                  ),
                ))
          ],
        ));
  }
}
