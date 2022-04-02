import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:hashmicro/domain/models/absen_m.dart';
import 'package:hashmicro/domain/models/user_m.dart';
import 'package:hashmicro/domain/repositories/dashboard_repo.dart';
import 'package:location/location.dart';

import '../../utils/app_dialog.dart';
import '../../viewmodels/controllers/session_c.dart';

class DashboardNet extends DashboardRepo {
  final _sC = Get.find<SessionC>();

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> streamAbsenById() {
    return FirebaseFirestore.instance
        .collection("/absen")
        .where("id", isEqualTo: _sC.id.value)
        .snapshots();
  }

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUserById() {
    return FirebaseFirestore.instance
        .collection("/users")
        .doc(_sC.id.value)
        .snapshots();
  }

  @override
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamMasterLokasi() {
    return FirebaseFirestore.instance
        .collection("/master")
        .doc("lokasi")
        .snapshots();
  }

  @override
  Future saveListenLocation(
    LocationData locationData,
  ) async {
    try {
      await FirebaseFirestore.instance
          .collection('/users')
          .doc(_sC.id.value)
          .update(
        {
          "lat": locationData.latitude,
          "lng": locationData.longitude,
        },
      );
    } catch (e) {
      AppDialog.dialogWithRoute("Ooppss...", e.toString());
    }
  }

  @override
  Future<bool?> checkCheckinData() async {
    try {
      final response = await FirebaseFirestore.instance
          .collection("/absen")
          .where(
            "id",
            isEqualTo: _sC.id.value,
          )
          .get();

      final data = response.docs
          .where((e) =>
              DateTime.parse(e['date']).year == DateTime.now().year &&
              DateTime.parse(e['date']).month == DateTime.now().month &&
              DateTime.parse(e['date']).day == DateTime.now().day)
          .toList();

      if (data.isNotEmpty) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      AppDialog.dialogWithRoute("Ooppss...", e.toString());
      return false;
    }
  }

  @override
  Future<bool?> checkCheckoutData() async {
    try {
      final response = await FirebaseFirestore.instance
          .collection("/absen")
          .where(
            "id",
            isEqualTo: _sC.id.value,
          )
          .get();

      final data = response.docs
          .where((e) =>
              DateTime.parse(e['date']).year == DateTime.now().year &&
              DateTime.parse(e['date']).month == DateTime.now().month &&
              DateTime.parse(e['date']).day == DateTime.now().day)
          .toList();

      if (data.isNotEmpty) {
        if (data[0]['timeOut'] != "-") {
          return false;
        } else {
          return true;
        }
      } else {
        return true;
      }
    } catch (e) {
      AppDialog.dialogWithRoute("Ooppss...", e.toString());
      return false;
    }
  }

  @override
  Future saveCheckin(UserM user) async {
    final body = {
      "id": _sC.id.value,
      "image": "-",
      "date": DateTime.now().toIso8601String(),
      "timeIn": DateTime.now().toIso8601String(),
      "timeOut": "-",
      "remote": false,
      "name": _sC.name.value,
      "latCheckin": user.lat,
      "lngCheckin": user.lng,
    };
    AppDialog.dialogWithRoute("Berhasil", "Absen sudah direkam");
    try {
      await FirebaseFirestore.instance.collection("/absen").add(body);
    } catch (e) {
      AppDialog.dialogWithRoute("Ooppss...", e.toString());
    }
  }

  @override
  Future saveCheckout(UserM user) async {
    final body = {
      "timeOut": DateTime.now().toIso8601String(),
      "latCheckout": user.lat,
      "lngCheckout": user.lng,
    };
    try {
      final response = await FirebaseFirestore.instance
          .collection("/absen")
          .where("id", isEqualTo: _sC.id.value)
          .get();

      final data = response.docs
          .where((e) =>
              DateTime.parse(e['date']).year == DateTime.now().year &&
              DateTime.parse(e['date']).month == DateTime.now().month &&
              DateTime.parse(e['date']).day == DateTime.now().day)
          .toList();
      await FirebaseFirestore.instance
          .collection("/absen")
          .doc(data[0].id)
          .update(body);
      AppDialog.dialogWithRoute("Berhasil", "Absen sudah direkam");
    } catch (e) {
      AppDialog.dialogWithRoute("Ooppss...", e.toString());
    }
  }

  @override
  Future saveMasterLocation(double lat, double lng) async {
    final body = {
      "lat": lat,
      "lng": lng,
    };
    try {
      await FirebaseFirestore.instance
          .collection("/master")
          .doc("lokasi")
          .update(body);
      AppDialog.dialogWithRoute("Success", "Master Location has been Saved");
    } catch (e) {
      AppDialog.dialogWithRoute("Ooppss...", e.toString());
    }
  }
}
