import 'package:get/get.dart';
import 'package:hashmicro/viewmodels/controllers/dashboard_c.dart';

class DashboardBind extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardC());
  }
}
