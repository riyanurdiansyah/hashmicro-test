import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:latlong2/latlong.dart';
import '../../domain/models/user_m.dart';
import '../../domain/network/dashboard_net.dart';
import '../../utils/app_dialog.dart';

class AbsenC extends GetxController {
  final _dashboardNet = DashboardNet();

  final Rx<UserM> _user = UserM().obs;
  Rx<UserM> get user => _user;

  final Rx<bool> _isServiceEnabled = false.obs;
  Rx<bool> get isServiceEnabled => _isServiceEnabled;

  StreamSubscription<LocationData>? _locationSub;
  Location location = Location();

  Rx<double> minZoom = 12.0.obs;
  Rx<double> maxZoom = 20.0.obs;
  Rx<double> zoom = 18.0.obs;

  Rx<double> latMaster = 0.0.obs;
  Rx<double> lngMaster = 0.0.obs;

  final RxList<XFile> _listImg = <XFile>[].obs;
  RxList<XFile> get listImg => _listImg;

  var args = 0.obs;
  var workFrom = 0.obs;

  LocationData? locData;

  // LatLng defaultLok = LatLng(-6.322362, 106.777194);

  MapController? mapController;

  @override
  void onInit() async {
    super.onInit();
    mapController = MapController();
    await checkPermissionLocation();
    await checkPermissionCamera();
    args.value = Get.arguments[0];
    workFrom.value = Get.arguments[1];
  }

  Future<void> checkPermissionLocation() async {
    var locationPermission = await Permission.location.status;
    if (locationPermission.isGranted) {
    } else if (locationPermission.isDenied) {
      checkPermissionLocation();
    } else {
      openAppSettings();
    }
  }

  Future<void> checkPermissionCamera() async {
    var cameraPermission = await Permission.camera.status;
    if (cameraPermission.isGranted) {
    } else if (cameraPermission.isDenied) {
      checkPermissionCamera();
    } else {
      openAppSettings();
    }
  }

  Future showCamera() async {
    final ImagePicker _picker = ImagePicker();
    final data = await _picker.pickImage(source: ImageSource.camera);

    if (data != null) {
      if (_listImg.length < 3) {
        _listImg.add(data);
      } else {
        _listImg.removeLast();
        _listImg.add(data);
      }
    }
  }

  void fnTakePhoto() {
    checkPermissionCamera();
  }

  void fnRemoveImg(int i) {
    _listImg.removeAt(i);
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> fnStreamUserById() {
    return _dashboardNet.streamUserById();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> fnStreamMasterLokasi() {
    return _dashboardNet.streamMasterLokasi();
  }

  void calculateDistance() {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((latMaster - user.value.lat!) * p) / 2 +
        c(user.value.lat! * p) *
            c(latMaster * p) *
            (1 - c((lngMaster - user.value.lng!) * p)) /
            2;
    var hasil = (12742 * asin(sqrt(a))) * 1000;
    if (hasil > 50) {
      AppDialog.dialogWithRoute(
        "Ooppss..",
        "Jarak maksimal adalah 50M untuk melakukan absen",
      );
    } else {
      AppDialog.dialogConfirmCheckin(user.value);
    }
  }

  List<LatLng> drawCircle(LatLng point, double radius, [int dir = 1]) {
    var d2r = pi / 180; // degrees to radians
    var r2d = 180 / pi; // radians to degrees
    var earthsradius = 6371000; // radius of the earth in meters

    var points = 32;

    // find the raidus in lat/lon
    var rlat = (radius / earthsradius) * r2d;
    var rlng = rlat / cos(point.latitude * d2r);

    List<LatLng> extp = [];
    int start = 0;
    int end = points + 1;
    if (dir == -1) {
      start = points + 1;
      end = 0;
    }
    for (var i = start; (dir == 1 ? i < end : i > end); i = i + dir) {
      var theta = pi * (i / (points / 2));
      double ey = point.longitude +
          (rlng * cos(theta)); // center a + radius x * cos(theta)
      double ex = point.latitude +
          (rlat * sin(theta)); // center b + radius y * sin(theta)
      extp.add(LatLng(ex, ey));
    }
    return extp;
  }

  void saveUserById(DocumentSnapshot<Map<String, dynamic>>? data) {
    user.value = UserM.fromJson(data!.data()!);
  }

  void changeService() {
    isServiceEnabled.value = !_isServiceEnabled.value;
  }

  Future<void> listenLocation() async {
    _isServiceEnabled.value = !_isServiceEnabled.value;
    _locationSub = location.onLocationChanged.handleError((onError) {
      _locationSub?.cancel();
      _locationSub == null;
    }).listen(
      (LocationData locationData) async {
        locData = locationData;
        if (_isServiceEnabled.value) {
          await _dashboardNet.saveListenLocation(locationData);
          if (mapController != null) {
            mapController!.move(
                LatLng(locationData.latitude!, locationData.longitude!), 16);
          }
        } else {
          _locationSub?.pause();
        }
      },
    );
  }

  void fnCheckCheckin() async {
    final response = await _dashboardNet.checkCheckinData();
    if (response!) {
      calculateDistance();
    } else {
      AppDialog.dialogWithRoute("Ooppss...", "Kamu sudah checkin hari ini");
    }
  }

  Future fnCheckCheckout() async {
    final response = await _dashboardNet.checkCheckoutData();
    if (response!) {
      calculateDistance();
    } else {
      AppDialog.dialogWithRoute("Ooppss...", "Kamu sudah checkout hari ini");
    }
  }

  void fnSaveCheckin(UserM user) {
    _dashboardNet.saveCheckin(user);
    Get.back();
  }

  void fnSaveCheckout(UserM user) {
    _dashboardNet.saveCheckout(user);
    Get.back();
  }
}
