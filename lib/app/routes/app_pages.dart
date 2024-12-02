import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/mtqq/bindings/mtqq_binding.dart';
import '../modules/mtqq/views/mtqq_view.dart';
import '../modules/play_video/bindings/play_video_binding.dart';
import '../modules/play_video/views/play_video_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.PLAY_VIDEO,
      page: () => const PlayVideoView(),
      binding: PlayVideoBinding(),
    ),
    GetPage(
      name: _Paths.MTQQ,
      page: () => const MtqqView(),
      binding: MtqqBinding(),
    ),
  ];
}
