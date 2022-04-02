import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/routes/routes_name.dart';

class AppBottomSheet {
  static bottomCheckin(
    int flag,
  ) {
    return Get.bottomSheet(
      Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10,
            ),
            Container(
              height: 4,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            ListTile(
              onTap: () {
                Get.back();
                Get.toNamed(AppRouteName.absen, arguments: [flag, 0]);
              },
              title: Text(
                "Remote",
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey.shade500,
                size: 15,
              ),
            ),
            ListTile(
              onTap: () {
                Get.back();
                Get.toNamed(AppRouteName.absen, arguments: [flag, 1]);
              },
              title: Text(
                "Office",
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.grey.shade500,
                size: 15,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
