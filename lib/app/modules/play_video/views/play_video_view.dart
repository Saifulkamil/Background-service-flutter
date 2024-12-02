import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/play_video_controller.dart';

class PlayVideoView extends GetView<PlayVideoController> {
  const PlayVideoView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PlayVideoView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PlayVideoView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
