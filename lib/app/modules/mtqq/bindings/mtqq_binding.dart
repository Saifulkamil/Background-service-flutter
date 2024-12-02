import 'package:get/get.dart';

import '../controllers/mtqq_controller.dart';

class MtqqBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MtqqController>(
      () => MtqqController(),
    );
  }
}
