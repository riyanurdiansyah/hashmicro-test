import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hashmicro/domain/models/absen_m.dart';
import 'package:location/location.dart';

import '../models/user_m.dart';

abstract class DashboardRepo {
  Stream<QuerySnapshot<Map<String, dynamic>>> streamAbsenById();

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUserById();

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamMasterLokasi();

  Future saveListenLocation(LocationData locationData);

  Future<bool?> checkCheckinData();

  Future<bool?> checkCheckoutData();

  Future saveCheckin(UserM user);

  Future saveCheckout(UserM user);

  Future saveMasterLocation(double lat, double lng);
}
