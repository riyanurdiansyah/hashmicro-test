import 'package:get/get.dart';
import 'package:hashmicro/ui/absen_page.dart';
import 'package:hashmicro/ui/dashboard_page.dart';
import 'package:hashmicro/ui/drawer_page.dart';
import 'package:hashmicro/ui/signin_page.dart';
import 'package:hashmicro/ui/splash_page.dart';
import 'package:hashmicro/viewmodels/bindings/absen_bind.dart';
import 'package:hashmicro/viewmodels/bindings/auth_bind.dart';
import 'package:hashmicro/viewmodels/bindings/dashboard_bind.dart';
import 'package:hashmicro/viewmodels/bindings/splash_bind.dart';
import 'routes_name.dart';

class AppRoute {
  static final routes = [
    GetPage(
      name: AppRouteName.splash,
      page: () => const SplashPage(),
      binding: SplashBind(),
    ),
    GetPage(
      name: AppRouteName.signin,
      page: () => const SigninPage(),
      binding: AuthBind(),
      transition: Transition.noTransition,
    ),
    GetPage(
      name: AppRouteName.dashboard,
      page: () => const DashboardPage(),
      binding: DashboardBind(),
      transition: Transition.circularReveal,
    ),
    GetPage(
      name: AppRouteName.drawer,
      page: () => const DrawerPage(),
      transition: Transition.leftToRight,
    ),
    GetPage(
      name: AppRouteName.absen,
      page: () => const AbsenPage(),
      binding: AbsenBind(),
      transitionDuration: const Duration(milliseconds: 450),
      transition: Transition.downToUp,
    ),
  ];
}
