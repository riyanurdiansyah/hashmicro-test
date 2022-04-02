import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:get/get.dart';
import 'package:hashmicro/domain/network/dashboard_net.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../domain/models/absen_m.dart';
import '../../domain/models/user_m.dart';

class DashboardC extends GetxController {
  @override
  void onInit() async {
    super.onInit();

    await checkPermissionLocation();
  }

  final _dashboardNet = DashboardNet();

  final RxList<AbsenM> _listRekap = <AbsenM>[].obs;
  RxList<AbsenM> get listRekap => _listRekap;

  final RxList<AbsenM> _listAbsen = <AbsenM>[].obs;
  RxList<AbsenM> get listAbsen => _listAbsen;

  final Rx<double> _persentase = 0.0.obs;
  Rx<double> get persentase => _persentase;

  Stream<QuerySnapshot<Map<String, dynamic>>> fnStreamAbsenById() {
    return _dashboardNet.streamAbsenById();
  }

  final Rx<int> _indexTab = 0.obs;
  Rx<int> get indexTab => _indexTab;

  final Rx<bool> _onTapMaster = false.obs;
  Rx<bool> get onTapMaster => _onTapMaster;

  Rx<double> minZoom = 16.0.obs;
  Rx<double> maxZoom = 20.0.obs;
  Rx<double> zoom = 17.0.obs;

  final Rx<double> _latTemp = 0.0.obs;
  Rx<double> get latTemp => _latTemp;

  final Rx<double> _lngTemp = 0.0.obs;
  Rx<double> get lngTemp => _lngTemp;

  final Rx<UserM> _user = UserM().obs;
  Rx<UserM> get user => _user;

  MapController mapController = MapController();

  final Rx<bool> _isServiceEnabled = false.obs;
  Rx<bool> get isServiceEnabled => _isServiceEnabled;

  StreamSubscription<LocationData>? _locationSub;
  Location location = Location();

  LocationData? locData;

  Future<void> checkPermissionLocation() async {
    var locationPermission = await Permission.location.status;
    if (locationPermission.isGranted) {
    } else if (locationPermission.isDenied) {
      checkPermissionLocation();
    } else {
      openAppSettings();
    }
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> fnStreamMasterLokasi() {
    return _dashboardNet.streamMasterLokasi();
  }

  Stream<DocumentSnapshot<Map<String, dynamic>>> fnStreamUserById() {
    return _dashboardNet.streamUserById();
  }

  void saveRekap(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    _listRekap.clear();
    final absensiBulan = docs
        .where((e) => DateTime.parse(e['date']).month == DateTime.now().month)
        .toList();
    for (var data in absensiBulan) {
      _listRekap.add(AbsenM.fromJson(data.data()));
    }
    final underNine =
        _listRekap.where((e) => DateTime.parse(e.timeIn!).hour < 9).toList();
    final atNine = _listRekap
        .where((e) =>
            DateTime.parse(e.timeIn!).hour == 9 &&
            DateTime.parse(e.timeIn!).minute <= 15)
        .toList();
    _persentase.value =
        ((underNine.length + atNine.length) / _listRekap.length) * 100;
  }

  void saveAbsen(List<QueryDocumentSnapshot<Map<String, dynamic>>> docs) {
    _listAbsen.clear();
    for (var data in docs) {
      _listAbsen.add(AbsenM.fromJson(data.data()));
    }
    _listAbsen.sort(
      (a, b) => b.date!.compareTo(
        a.date!,
      ),
    );
  }

  void changeTab(int i) {
    _indexTab.value = i;
    Get.back();
  }

  void onTapMasterLokasi(LatLng latLngOnTap) {
    latTemp.value = latLngOnTap.latitude;
    lngTemp.value = latLngOnTap.longitude;
    onTapMaster.value = true;
  }

  void saveMasterLocationToDB() {
    _dashboardNet.saveMasterLocation(latTemp.value, lngTemp.value);
    changeCamera();
    removeOnTap();
  }

  void setCurrentLocMaster() {
    latTemp.value = user.value.lat!;
    lngTemp.value = user.value.lng!;
    saveMasterLocationToDB();
  }

  void removeOnTap() {
    _onTapMaster.value = false;
  }

  void changeCamera() {
    mapController.move(LatLng(latTemp.value, lngTemp.value), 17);
  }

  void saveUser(DocumentSnapshot<Map<String, dynamic>>? data) {
    user.value = UserM.fromJson(data!.data()!);
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
        } else {
          _locationSub?.pause();
        }
      },
    );
  }
}
