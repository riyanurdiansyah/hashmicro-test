import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hashmicro/domain/models/absen_m.dart';
import 'package:hashmicro/domain/network/dashboard_net.dart';
import 'package:hashmicro/services/routes/routes_name.dart';
import 'package:hashmicro/ui/widget/home.dart';
import 'package:hashmicro/ui/widget/master_lokasi.dart';
import 'package:hashmicro/viewmodels/controllers/dashboard_c.dart';

import '../utils/app_bottomsheet.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _dashboardC = Get.find<DashboardC>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.toNamed(AppRouteName.drawer),
          icon: const Icon(
            CupertinoIcons.square_grid_2x2_fill,
            color: Colors.white,
          ),
        ),
        title: Obx(
          () => Text(
            _dashboardC.indexTab.value == 0 ? "Home" : "Master Location",
            style: GoogleFonts.nunito(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
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
          Obx(
            () => _dashboardC.indexTab.value == 0
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Obx(
                      () => CupertinoSwitch(
                        activeColor: Colors.teal[100],
                        trackColor: Colors.grey.shade200,
                        thumbColor: _dashboardC.isServiceEnabled.value
                            ? Colors.white
                            : Colors.grey.shade600,
                        value: _dashboardC.isServiceEnabled.value,
                        onChanged: (bool value) {
                          _dashboardC.listenLocation();
                        },
                      ),
                    ),
                  ),
          )
        ],
      ),
      body: Obx(
        () => IndexedStack(
          index: _dashboardC.indexTab.value,
          children: const [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Home(),
            ),
            MasterLokasi(),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(
        () => _dashboardC.indexTab.value == 0
            ? SizedBox(
                width: Get.width / 1.2,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Card(
                        elevation: 4,
                        child: InkWell(
                          onTap: () => AppBottomSheet.bottomCheckin(1),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Icon(
                                  Icons.input_rounded,
                                  color: Colors.grey.shade600,
                                ),
                                Text(
                                  "CHECKIN",
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Card(
                        elevation: 4,
                        child: InkWell(
                          // onTap: DateTime.now().hour < 18
                          //     ? null
                          //     : () => AppBottomSheet.bottomCheckin(2),

                          onTap: () => AppBottomSheet.bottomCheckin(2),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "CHECKOUT",
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(
                                  Icons.output_rounded,
                                  color: Colors.grey.shade600,
                                ),
                              ],
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
    );
  }
}
