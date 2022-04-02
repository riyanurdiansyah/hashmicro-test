import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashmicro/domain/network/auth_net.dart';
import 'package:hashmicro/session/session.dart';

import '../../services/routes/routes_name.dart';
import 'session_c.dart';

class AuthC extends GetxController {
  final _sC = Get.find<SessionC>();
  final _signinKey = GlobalKey<FormState>();
  GlobalKey<FormState> get signinKey => _signinKey;

  final _scaffoldSignin = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> get scaffoldSignin => _scaffoldSignin;

  final _txEmailController = TextEditingController().obs;
  TextEditingController get txEmailController => _txEmailController.value;

  final _txPassController = TextEditingController().obs;
  TextEditingController get txPassController => _txPassController.value;

  final Rx<bool> _isHidePassword = true.obs;
  Rx<bool> get isHidePassword => _isHidePassword;

  final Rx<bool> _isLoading = false.obs;
  Rx<bool> get isLoading => _isLoading;

  final _authNet = AuthNet();

  void hidePassword() {
    _isHidePassword.value = !_isHidePassword.value;
  }

  void changeLoading() {
    _isLoading.value = !_isLoading.value;
  }

  void fnLogin() async {
    FocusScope.of(_scaffoldSignin.currentContext!).requestFocus(FocusNode());
    if (_signinKey.currentState!.validate()) {
      changeLoading();
      final response = await _authNet.signin(
        _txEmailController.value.text,
        _txPassController.value.text,
      );

      Future.delayed(
        const Duration(seconds: 3),
        () async {
          changeLoading();
          if (response != null) {
            final data = await _authNet.getInfoUser(response);
            if (data != null) {
              await AppSession.saveSession(data);

              await _sC.saveSessionToController();

              return Get.offAllNamed(AppRouteName.dashboard);
            }
          }
        },
      );
    }
  }
}
