import 'package:flutter/material.dart';

double screenWidth(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;

  // يمنع التصميم من التضخم على الشاشات الكبيرة والويب
  return width > 600 ? 600 : width;
}

double screenHeight(BuildContext context) {
  return MediaQuery.sizeOf(context).height;
}

bool isSmallScreen(BuildContext context) {
  return MediaQuery.sizeOf(context).width < 360;
}

bool isMobile(BuildContext context) {
  return MediaQuery.sizeOf(context).width < 600;
}

bool isTablet(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  return width >= 600 && width < 1024;
}

bool isDesktop(BuildContext context) {
  return MediaQuery.sizeOf(context).width >= 1024;
}