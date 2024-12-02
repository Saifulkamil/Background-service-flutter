import 'package:get/get.dart';

import '../controllers/play_video_controller.dart';

class PlayVideoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlayVideoController>(
      () => PlayVideoController(),
    );
  }
}
