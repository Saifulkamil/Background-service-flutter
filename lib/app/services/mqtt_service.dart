import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:notif/app/modules/home/views/notif.dart';

class MqttService {
  static final hostController = TextEditingController(text: "broker.mqtt.cool");

  static final topicPubController = TextEditingController(text: "notip");
  static final topicSubController = TextEditingController(text: "notip");
  static final messegeController = TextEditingController();
  static MqttServerClient? client;
  static Function(String)? onMessageReceived;
  static RxString mqttText = "Connect".obs;
  static RxString pubText = "Publish".obs;
  static RxString subText = "Subcribe".obs;

  static Future<bool> connect() async {
    client = MqttServerClient(
        hostController.text.isEmpty ? "broker.mqtt.cool" : hostController.text,
        'flutter_client');
    client!.port = 1883;
    client!.keepAlivePeriod = 60;
    client!.onConnected = onConnected;
    client!.onDisconnected = onDisconnected;
    client!.onSubscribed = onSubscribed;
    client!.logging(on: true);

    final connMessage = MqttConnectMessage()
        .withClientIdentifier(
            'flutter_client_${DateTime.now().millisecondsSinceEpoch}')
        .startClean()
        .withWillQos(MqttQos.atLeastOnce);

    client!.connectionMessage = connMessage;

    try {
      await client!.connect();
      if (client!.connectionStatus!.state == MqttConnectionState.connected) {
        mqttText.value = "Connected to ${hostController.text}";
        return true;
      }
      mqttText.value = "Failed, try Connected to broker";
      return false;
    } catch (e) {
      print('Connection failed: $e');
      mqttText.value = "Failed, try Connected to broker";

      return false;
    }
  }

  static void onConnected() {
    print('Connected to MQTT Broker');
  }

  static void onDisconnected() {
    mqttText.value = "Connect";
    print('Disconnected from MQTT Broker');
  }

  static void onSubscribed(String topic) {
    subText.value = "Subcribe ${topic}";
    print('Subscribed to topic: $topic');
  }

  static RxList<String> messagesList = <String>[].obs;

  /// Menangani langganan ke topik MQTT
  static Future<void> subscribe(String topic) async {
    if (client == null ||
        client!.connectionStatus?.state != MqttConnectionState.connected) {
      print("Client not connected, attempting to reconnect...");
      bool connected = await connect();
      if (!connected) {
        print("Failed to reconnect");
        return;
      }
    }

    client!.subscribe(topic, MqttQos.atLeastOnce);
    print("Subscribed to $topic");

    client!.updates?.listen((List<MqttReceivedMessage<MqttMessage>> messages) {
      final message = messages[0].payload as MqttPublishMessage;
      final payload =
          MqttPublishPayload.bytesToStringAsString(message.payload.message);
      messagesList.add(payload);

      // Tampilkan notifikasi
      NotificationService.showNotification(
        1,
        "Notifikasi",
        payload.isEmpty ? "Pesan kosong" : payload,
        "content",
      );
    });
  }

  /// Publikasi pesan ke topik tertentu
  static void publish(String topic, String message) {
    if (client?.connectionStatus?.state == MqttConnectionState.connected) {
      final builder = MqttClientPayloadBuilder();
      builder.addString(message);
      client!.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
      print("Published message: $message to topic: $topic");
    } else {
      print("Failed to publish, client not connected.");
    }
  }

  /// Unsubscribe dari topik
  static void unsubscribe(String topic) {
    if (client?.connectionStatus?.state == MqttConnectionState.connected) {
      client!.unsubscribe(topic);
      print('Unsubscribed from topic: $topic');
    }
  }
}
