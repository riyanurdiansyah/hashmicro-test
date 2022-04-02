import 'package:flutter/cupertino.dart';

import '../domain/models/drawer_item_m.dart';

const mapBoxUrl =
    'https://api.mapbox.com/styles/v1/riyanurdiansyah/ckzuyk2fw000t14rxqq0ihk05/tiles/256/{z}/{x}/{y}@2x?access_token={access_token}';
const mapBoxToken =
    "pk.eyJ1Ijoicml5YW51cmRpYW5zeWFoIiwiYSI6ImNrenR4bHI1ZjF0N3cycHBlZ3BqZWVnbDYifQ.jXKBY_ELaTu1NhkRAk-J-Q";
const mapBoxStyle = "mapbox://styles/mapbox/navigation-day-v1";

const home = DrawerItem(title: "Home", icon: CupertinoIcons.house_fill);
const cuti = DrawerItem(title: "Cuti", icon: CupertinoIcons.archivebox_fill);
const izin =
    DrawerItem(title: "Izin", icon: CupertinoIcons.bag_fill_badge_plus);
const reimb =
    DrawerItem(title: "Reimbrs", icon: CupertinoIcons.money_pound_circle_fill);

List<DrawerItem> listNavbar = [
  home,
  izin,
  cuti,
  reimb,
];
