import 'package:flutter/cupertino.dart';

class AppText {
  static labelNormal(
    String title,
    double fontSize,
    Color colors, {
    String? familiy,
  }) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.normal,
        fontFamily: familiy ?? 'Montserrat',
        fontSize: fontSize,
        color: colors,
      ),
    );
  }

  static labelW500(
    String title,
    double fontSize,
    Color colors, {
    String? familiy,
  }) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontFamily: familiy ?? 'Montserrat',
        fontSize: fontSize,
        color: colors,
      ),
    );
  }

  static labelW600(
    String title,
    double fontSize,
    Color colors, {
    String? familiy,
  }) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: familiy ?? 'Montserrat',
        fontSize: fontSize,
        color: colors,
      ),
    );
  }

  static labelW700(
    String title,
    double fontSize,
    Color colors, {
    String? familiy,
  }) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w700,
        fontFamily: familiy ?? 'Montserrat',
        fontSize: fontSize,
        color: colors,
      ),
    );
  }

  static labelW800(
    String title,
    double fontSize,
    Color colors, {
    String? familiy,
  }) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w800,
        fontFamily: familiy ?? 'Montserrat',
        fontSize: fontSize,
        color: colors,
      ),
    );
  }

  static labelW900(
    String title,
    double fontSize,
    Color colors, {
    String? familiy,
  }) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w900,
        fontFamily: familiy ?? 'Montserrat',
        fontSize: fontSize,
        color: colors,
      ),
    );
  }

  static labelBold(
    String title,
    double fontSize,
    Color colors, {
    String? familiy,
  }) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontFamily: familiy ?? 'Montserrat',
        fontSize: fontSize,
        color: colors,
      ),
    );
  }
}
