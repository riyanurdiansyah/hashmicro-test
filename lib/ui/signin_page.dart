import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hashmicro/utils/app_style_textfield.dart';
import '../utils/app_text.dart';
import '../utils/app_validator.dart';
import '../viewmodels/controllers/auth_c.dart';

class SigninPage extends StatelessWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _authC = Get.put(AuthC());
    return Scaffold(
      key: _authC.scaffoldSignin,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: kToolbarHeight,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                AppText.labelBold(
                  'Welcome',
                  26,
                  Colors.blue,
                ),
                const SizedBox(height: 25),
                Form(
                  key: _authC.signinKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(height: Get.size.height * 0.03),
                      TextFormField(
                        controller: _authC.txEmailController,
                        keyboardType: TextInputType.emailAddress,
                        style: AppStyleTextfield.authTextFieldStyle(),
                        textInputAction: TextInputAction.next,
                        decoration: AppStyleTextfield.authFormInput('Email'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) => AppValidator.requiredField(
                          value!,
                          errorMsg: "Email tidak boleh kosong",
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(
                        () => TextFormField(
                          controller: _authC.txPassController,
                          style: AppStyleTextfield.authTextFieldStyle(),
                          decoration:
                              AppStyleTextfield.authFormInput('Password')
                                  .copyWith(
                            suffixIcon: IconButton(
                              icon: Icon(
                                Icons.visibility,
                                color: _authC.isHidePassword.value == true
                                    ? Colors.grey[600]
                                    : Colors.blue,
                                size: Get.size.shortestSide < 600 ? 22 : 42,
                              ),
                              onPressed: () {
                                _authC.hidePassword();
                              },
                            ),
                          ),
                          obscureText: _authC.isHidePassword.value,
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password tidak boleh kosong';
                            } else if (value.length < 2) {
                              return 'Tidak boleh kurang dari 2 karakter';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Obx(
                        () => SizedBox(
                          width: Get.size.width,
                          height: Get.size.shortestSide < 600 ? 45 : 75,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.blue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                            child: AppText.labelBold(
                              "Masuk",
                              16,
                              Colors.white,
                            ),
                            onPressed: _authC.isLoading.value
                                ? null
                                : () => _authC.fnLogin(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Obx(
              () => _authC.isLoading.value
                  ? Center(
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.transparent,
                        width: 50,
                        height: 50,
                        child: GetPlatform.isAndroid
                            ? const CircularProgressIndicator()
                            : const CupertinoActivityIndicator(),
                      ),
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
