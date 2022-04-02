import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../utils/app_bottomsheet.dart';
import '../../viewmodels/controllers/dashboard_c.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _dashboardC = Get.find<DashboardC>();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 15,
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _dashboardC.fnStreamAbsenById(),
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  _dashboardC.saveRekap(snapshot.data!.docs);
                  return Card(
                    elevation: 2,
                    color: Colors.blue.shade400,
                    semanticContainer: true,
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -225,
                          bottom: -15,
                          width: Get.width,
                          height: Get.height / 5,
                          child: SvgPicture.asset(
                            "assets/svg/result.svg",
                            colorBlendMode: BlendMode.clear,
                            width: 150,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(15),
                          width: Get.width,
                          height: Get.height / 5,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: CircularPercentIndicator(
                                  backgroundColor: Colors.grey.shade400,
                                  progressColor: Colors.white,
                                  animation: true,
                                  reverse: true,
                                  radius: 60.0,
                                  lineWidth: 12.0,
                                  percent: _dashboardC.persentase.value / 100,
                                  center: Text(
                                    "${_dashboardC.persentase.round()} %",
                                    style: GoogleFonts.aBeeZee(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Persentase Ketepatan Waktu Bulan Ini",
                                      style: GoogleFonts.nunito(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "Persentase anda ${_dashboardC.persentase.value.round()}%",
                                      style: GoogleFonts.nunito(
                                        fontSize: 12,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Container(
                                      alignment: Alignment.center,
                                      width: 75,
                                      height: 25,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Text(
                                        "Detail",
                                        style: GoogleFonts.nunito(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue.shade500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Aktivitas Terakhir",
                  style: GoogleFonts.nunito(
                    fontSize: 18,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Lihat semua",
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: Colors.blue.shade500,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
              stream: _dashboardC.fnStreamAbsenById(),
              builder: (ctx, snapshot) {
                if (snapshot.hasData) {
                  _dashboardC.saveAbsen(snapshot.data!.docs);
                  return Column(
                    children: List.generate(
                      _dashboardC.listAbsen.length <= 3
                          ? _dashboardC.listAbsen.length
                          : 3,
                      (i) => TimelineTile(
                        afterLineStyle: LineStyle(
                          color: Colors.grey.shade400,
                        ),
                        beforeLineStyle: LineStyle(
                          color: Colors.grey.shade400,
                        ),
                        indicatorStyle: IndicatorStyle(
                          indicatorXY: 0.15,
                          width: 15,
                          indicator: Container(
                            decoration: BoxDecoration(
                              color: Colors.blue.shade400,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        isFirst: i == 0,
                        isLast: _dashboardC.listAbsen.length <= 3
                            ? i == _dashboardC.listAbsen.length - 1
                            : i == 2,
                        endChild: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 5, horizontal: 10),
                                    height: 25,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color:
                                          Colors.grey.shade400.withOpacity(0.8),
                                    ),
                                    child: RichText(
                                      text: TextSpan(
                                          text: DateFormat.MMMd('id').format(
                                            DateTime.parse(
                                              _dashboardC.listAbsen[i].date!,
                                            ),
                                          ),
                                          style: GoogleFonts.nunito(
                                            fontSize: 12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: _dashboardC
                                                      .listAbsen[i].remote!
                                                  ? " - Remote"
                                                  : " - Office",
                                              style: GoogleFonts.nunito(
                                                fontSize: 12,
                                                color: _dashboardC
                                                        .listAbsen[i].remote!
                                                    ? Colors.red
                                                    : Colors.blue.shade600,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          ]),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Checkin :",
                                        style: GoogleFonts.nunito(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      Text(
                                        _dashboardC.listAbsen[i].timeIn! == "-"
                                            ? "-"
                                            : "${DateFormat('HH:mm:ss', 'id').format(
                                                DateTime.parse(
                                                  _dashboardC
                                                      .listAbsen[i].timeIn!,
                                                ),
                                              )} ${DateTime.parse(
                                                _dashboardC
                                                    .listAbsen[i].timeIn!,
                                              ).timeZoneName}",
                                        style: GoogleFonts.nunito(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(
                                        "Checkout :",
                                        style: GoogleFonts.nunito(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      Text(
                                        _dashboardC.listAbsen[i].timeOut! == "-"
                                            ? "-"
                                            : "${DateFormat('HH:mm:ss', 'id').format(
                                                DateTime.parse(
                                                  _dashboardC
                                                      .listAbsen[i].timeOut!,
                                                ),
                                              )} ${DateTime.parse(
                                                _dashboardC
                                                    .listAbsen[i].timeOut!,
                                              ).timeZoneName}",
                                        style: GoogleFonts.nunito(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              _dashboardC.listAbsen[i].image! == "-"
                                  ? const SizedBox()
                                  : Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            _dashboardC.listAbsen[i].image!,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    )
                            ],
                          ),
                        ),
                      ),
                    ),
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
            )
          ],
        ),
      ),
    );
  }
}
