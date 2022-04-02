import 'package:get/get.dart';

import '../controllers/absen_c.dart';

class AbsenBind extends Bindings {
  @override
  void dependencies() {
    Get.put(AbsenC());
  }
}
