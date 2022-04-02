import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hashmicro/utils/app_text.dart';
import 'package:hashmicro/viewmodels/controllers/dashboard_c.dart';

import '../services/routes/routes_name.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _dashboardC = Get.find<DashboardC>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: null,
        automaticallyImplyLeading: false,
        title: Text(
          "Menu",
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
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            onTap: () => _dashboardC.changeTab(0),
            leading: const Icon(
              Icons.home_rounded,
            ),
            title: AppText.labelW600(
              "Home",
              14,
              Colors.black,
            ),
          ),
          ListTile(
            onTap: () => _dashboardC.changeTab(1),
            leading: const Icon(
              Icons.location_city_rounded,
            ),
            title: AppText.labelW600(
              "Master Location",
              14,
              Colors.black,
            ),
          )
        ],
      ),
    );
  }
}
