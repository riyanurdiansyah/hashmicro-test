import 'package:get/get.dart';

import '../../session/session.dart';

class SessionC extends GetxController {
  var id = "".obs;
  var name = "".obs;
  var role = 00.obs;

  Future<void> saveSessionToController() async {
    id.value = await AppSession.getSessionUid();
    name.value = await AppSession.getSessionName();
    role.value = await AppSession.getSessionRole();
  }
}
