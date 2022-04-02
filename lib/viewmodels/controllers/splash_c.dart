import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../services/routes/routes_name.dart';
import '../../session/session.dart';
import 'session_c.dart';

class SplashC extends GetxController {
  final _sC = Get.find<SessionC>();
  @override
  void onInit() {
    super.onInit();
    Future.delayed(
      const Duration(seconds: 2),
      () async {
        final uid = await AppSession.getSessionUid();
        if (uid != null) {
          await _sC.saveSessionToController();
          return Get.offAllNamed(AppRouteName.dashboard);
        } else {
          return Get.offAllNamed(AppRouteName.signin);
        }
      },
    );
  }
}
