import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
final RegExp phoneNumberValidatorRegExp =
    RegExp(r"^(^\+62|62|^08)(\d{3,4}-?){2}\d{3,4}$");

Color identityColor = Color.fromRGBO(90, 87, 171, 1);

// number format rupiah

String formatRupiah(String money) =>
    NumberFormat.currency(locale: 'id', symbol: 'Rp.', decimalDigits: 0)
        .format(int.parse(money));

/// ------------
/// Device Size
/// ------------
double deviceWidth() => ScreenUtil.screenWidth;
double deviceHeight() => ScreenUtil.screenHeight;

double getWidthScreen(context) => MediaQuery.of(context).size.width;
double getHeightScreen(context) => MediaQuery.of(context).size.height;

/// ----------------
/// Status Bar Color
/// ----------------
void setStatusBar({Brightness brightness = Brightness.dark}) {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, statusBarIconBrightness: brightness));
}

/// -----------------------------------
/// Font and size scaling screen utils
/// -----------------------------------
/// Initialize screen util
void setupScreenUtil(BuildContext context) =>
    ScreenUtil.init(context, allowFontScaling: true);

// Setting height and width
double setWidth(double width) => ScreenUtil().setWidth(width);
double setHeight(double height) => ScreenUtil().setHeight(height);

// Setting fontsize
double setFontSize(double size) =>
    ScreenUtil().setSp(size, allowFontScalingSelf: true);
