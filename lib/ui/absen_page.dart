import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../utils/app_constanta.dart';
import '../viewmodels/controllers/absen_c.dart';

class AbsenPage extends StatelessWidget {
  const AbsenPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _aC = Get.find<AbsenC>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Absen",
          style: GoogleFonts.nunito(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.blue.shade600,
                Colors.blue.shade300,
              ],
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Obx(
              () => CupertinoSwitch(
                activeColor: Colors.teal[100],
                trackColor: Colors.grey.shade200,
                thumbColor: _aC.isServiceEnabled.value
                    ? Colors.white
                    : Colors.grey.shade600,
                value: _aC.isServiceEnabled.value,
                onChanged: (bool value) {
                  _aC.listenLocation();
                },
              ),
            ),
          ),
        ],
      ),
      body: Obx(
        () {
          if (_aC.isServiceEnabled.value) {
            return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              stream: _aC.fnStreamMasterLokasi(),
              builder: (ctx, snapshotMaster) {
                if (snapshotMaster.hasData) {
                  return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                    stream: _aC.fnStreamUserById(),
                    builder: (ctx, snapshot) {
                      if (snapshot.hasData) {
                        _aC.saveUserById(snapshot.data!);
                        return FlutterMap(
                          mapController: _aC.mapController,
                          options: MapOptions(
                            minZoom: _aC.minZoom.value,
                            maxZoom: _aC.maxZoom.value,
                            zoom: _aC.zoom.value,
                            center: LatLng(
                                snapshot.data!['lat'], snapshot.data!['lng']),
                          ),
                          nonRotatedLayers: [
                            TileLayerOptions(
                              urlTemplate: mapBoxUrl,
                              additionalOptions: {
                                'access_token': mapBoxToken,
                                'id': mapBoxStyle,
                              },
                            ),
                            MarkerLayerOptions(
                              markers: List.generate(
                                1,
                                (index) => Marker(
                                  width: 30,
                                  height: 30,
                                  point: LatLng(
                                    snapshot.data!['lat'],
                                    snapshot.data!['lng'],
                                  ),
                                  builder: (_) => GestureDetector(
                                    onTap: () {},
                                    child: Image.asset(
                                      "assets/images/pin.png",
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            CircleLayerOptions(
                              circles: <CircleMarker>[
                                CircleMarker(
                                  point: LatLng(
                                      snapshotMaster.data!.data()!['lat'],
                                      snapshotMaster.data!.data()!['lng']),
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
                                  point: LatLng(
                                      snapshotMaster.data!.data()!['lat'],
                                      snapshotMaster.data!.data()!['lng']),
                                  builder: (_) => Image.asset(
                                    "assets/images/hash.png",
                                  ),
                                ),
                              ],
                            ),
                            MarkerLayerOptions(
                              markers: [
                                Marker(
                                  width: 40,
                                  height: 40,
                                  point: LatLng(
                                    snapshot.data!['lat'],
                                    snapshot.data!['lng'],
                                  ),
                                  builder: (_) => Image.asset(
                                    "assets/images/pin.png",
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text(
                            snapshot.error.toString(),
                            style: GoogleFonts.aBeeZee(
                              fontSize: 14,
                              color: Colors.grey.shade600,
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
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: Get.width,
                  child: SvgPicture.asset(
                    "assets/svg/map.svg",
                    width: 250,
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  "Ooppss...",
                  style: GoogleFonts.aBeeZee(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                Text(
                  "Aktifkan lokasi terlebih dahulu",
                  style: GoogleFonts.aBeeZee(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        width: Get.width,
        child: Obx(
          () => _aC.isServiceEnabled.value
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        _aC.listImg.length,
                        (index) => SizedBox(
                          width: 90,
                          height: 110,
                          child: Stack(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 8),
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.blueGrey.shade300,
                                  borderRadius: BorderRadius.circular(6),
                                  image: DecorationImage(
                                    image: FileImage(
                                      File(_aC.listImg[index].path),
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                right: 1,
                                child: InkWell(
                                  onTap: () => _aC.fnRemoveImg(index),
                                  child: Container(
                                    width: 25,
                                    height: 25,
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade400,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close_rounded,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: InkWell(
                            onTap: () async {
                              if (_aC.args.value == 1) {
                                _aC.fnCheckCheckin();
                              } else {
                                _aC.fnCheckCheckout();
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Colors.blue.shade400,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              width: Get.width,
                              height: 50,
                              child: Text(
                                _aC.args.value == 1 ? "Checkin" : "Checkout",
                                style: GoogleFonts.nunito(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (_aC.workFrom.value == 0 &&
                            _aC.isServiceEnabled.value)
                          const SizedBox(
                            width: 10,
                          ),
                        if (_aC.workFrom.value == 0 &&
                            _aC.isServiceEnabled.value)
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                _aC.showCamera();
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade400,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                width: Get.width,
                                height: 50,
                                child: const Icon(
                                  Icons.add_a_photo_rounded,
                                  size: 25,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                )
              : const SizedBox(),
        ),
      ),
    );
  }
}
