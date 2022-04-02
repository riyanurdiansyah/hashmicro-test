import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hashmicro/viewmodels/controllers/dashboard_c.dart';
import 'package:latlong2/latlong.dart';

import '../../utils/app_bottomsheet.dart';
import '../../utils/app_constanta.dart';

class MasterLokasi extends StatefulWidget {
  const MasterLokasi({Key? key}) : super(key: key);

  @override
  State<MasterLokasi> createState() => _MasterLokasiState();
}

class _MasterLokasiState extends State<MasterLokasi> {
  @override
  Widget build(BuildContext context) {
    final _dashboardC = Get.find<DashboardC>();
    return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      stream: _dashboardC.fnStreamUserById(),
      builder: (context, snapshotUser) {
        if (snapshotUser.hasData) {
          _dashboardC.saveUser(snapshotUser.data);
          return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: _dashboardC.fnStreamMasterLokasi(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Obx(
                  () => Scaffold(
                    body: FlutterMap(
                      mapController: _dashboardC.mapController,
                      options: MapOptions(
                        minZoom: _dashboardC.minZoom.value,
                        maxZoom: _dashboardC.maxZoom.value,
                        zoom: _dashboardC.zoom.value,
                        center: LatLng(
                            snapshot.data!['lat'], snapshot.data!['lng']),
                        onTap: (tapPosition, latLng) {
                          _dashboardC.onTapMasterLokasi(latLng);
                        },
                      ),
                      nonRotatedLayers: [
                        TileLayerOptions(
                          urlTemplate: mapBoxUrl,
                          additionalOptions: {
                            'access_token': mapBoxToken,
                            'id': mapBoxStyle,
                          },
                        ),
                        CircleLayerOptions(
                          circles: <CircleMarker>[
                            CircleMarker(
                              point: LatLng(snapshot.data!.data()!['lat'],
                                  snapshot.data!.data()!['lng']),
                              color: Colors.blue.shade500.withOpacity(0.2),
                              borderStrokeWidth: 2,
                              useRadiusInMeter: true,
                              radius: 50,
                              borderColor: Colors.blue.shade200,
                            ),
                          ],
                        ),
                        MarkerLayerOptions(
                          markers: [
                            Marker(
                              width: 50,
                              height: 50,
                              point: LatLng(snapshot.data!.data()!['lat'],
                                  snapshot.data!.data()!['lng']),
                              builder: (_) => Image.asset(
                                "assets/images/hash.png",
                                width: 15,
                              ),
                            ),
                          ],
                        ),
                        if (_dashboardC.onTapMaster.value)
                          MarkerLayerOptions(
                            markers: [
                              Marker(
                                width: 40,
                                height: 40,
                                point: LatLng(
                                  _dashboardC.latTemp.value,
                                  _dashboardC.lngTemp.value,
                                ),
                                builder: (_) => Image.asset(
                                  "assets/images/pin.png",
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerFloat,
                    floatingActionButton: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(
                          () => _dashboardC.onTapMaster.value
                              ? SizedBox(
                                  width: Get.width / 1.2,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Card(
                                          elevation: 4,
                                          child: InkWell(
                                            onTap: () =>
                                                _dashboardC.removeOnTap(),
                                            child: Container(
                                              height: 40,
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.all(8),
                                              child: Text(
                                                "REMOVE",
                                                style: GoogleFonts.nunito(
                                                  fontSize: 14,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Card(
                                          color: Colors.blue.shade300,
                                          elevation: 4,
                                          child: InkWell(
                                            onTap: () => _dashboardC
                                                .saveMasterLocationToDB(),
                                            child: Container(
                                              height: 40,
                                              alignment: Alignment.center,
                                              padding: const EdgeInsets.all(8),
                                              child: Text(
                                                "SAVE",
                                                style: GoogleFonts.nunito(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : const SizedBox(),
                        ),
                        _dashboardC.isServiceEnabled.value
                            ? SizedBox(
                                width: Get.width / 1.2,
                                child: Card(
                                  elevation: 4,
                                  child: InkWell(
                                    onTap: () =>
                                        _dashboardC.setCurrentLocMaster(),
                                    child: Container(
                                      height: 40,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        "SET MASTER CURRENT LOCATION",
                                        style: GoogleFonts.nunito(
                                          fontSize: 14,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                );
              } else {
                return Container(
                  height: 125,
                  alignment: Alignment.center,
                  child: GetPlatform.isAndroid
                      ? const CircularProgressIndicator()
                      : const CupertinoActivityIndicator(),
                );
              }
            },
          );
        } else {
          return Container(
            height: 125,
            alignment: Alignment.center,
            child: GetPlatform.isAndroid
                ? const CircularProgressIndicator()
                : const CupertinoActivityIndicator(),
          );
        }
      },
    );
  }
}
