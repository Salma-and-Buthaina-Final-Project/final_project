import 'package:flutter/material.dart';

import 'package:final_project/constants/colors.dart';
import 'package:final_project/constants/fonts.dart';
import 'package:final_project/utils/screen_size.dart';

import 'package:final_project/screens/history_screen.dart';
import 'package:final_project/screens/report_screen.dart';
import 'package:final_project/screens/add_condition_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // الصفحة الحالية هي الرئيسية دائماً
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final width = screenWidth(context);
    final height = screenHeight(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // =====================================================
              // CONTENT
              // =====================================================
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.055,
                    vertical: height * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // =================================================
                      // HEADER
                      // =================================================
                      Row(
                        children: [
                          // Person
                          Container(
                            width: width * 0.13,
                            height: width * 0.13,
                            decoration: BoxDecoration(
                              color: lightBlueColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: whiteColor,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.person_outline_rounded,
                              color: homeDarkTextColor,
                              size: width * 0.07,
                            ),
                          ),

                          SizedBox(width: width * 0.03),

                          // Greeting
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'مرحباً بكِ',
                                  style: TextStyle(
                                    fontFamily: thmanyahFont,
                                    fontSize: width * 0.038,
                                    fontWeight: FontWeight.w500,
                                    color: whiteColor,
                                  ),
                                ),
                                Text(
                                  'كيف حالك اليوم؟',
                                  style: TextStyle(
                                    fontFamily: thmanyahFont,
                                    fontSize: width * 0.055,
                                    fontWeight: FontWeight.w700,
                                    color: whiteColor,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Notification
                          Container(
                            width: width * 0.13,
                            height: width * 0.13,
                            decoration: BoxDecoration(
                              color: lightBlueColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: whiteColor,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.notifications_none_rounded,
                              color: homeDarkTextColor,
                              size: width * 0.065,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: height * 0.025),

                      // =================================================
                      // APPOINTMENT CARD
                      // =================================================
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.045,
                          vertical: height * 0.022,
                        ),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(
                            width * 0.05,
                          ),
                          border: Border.all(
                            color: homeBorderColor,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: width * 0.13,
                              height: width * 0.13,
                              decoration: const BoxDecoration(
                                color: homePurpleColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.calendar_month_outlined,
                                color: homeDarkTextColor,
                                size: width * 0.065,
                              ),
                            ),

                            SizedBox(width: width * 0.035),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'موعدك القادم',
                                    style: TextStyle(
                                      fontFamily: thmanyahFont,
                                      fontSize: width * 0.043,
                                      fontWeight: FontWeight.w700,
                                      color: homeDarkTextColor,
                                    ),
                                  ),
                                  SizedBox(
                                    height: height * 0.004,
                                  ),
                                  Text(
                                    'متابعة صحية',
                                    style: TextStyle(
                                      fontFamily: thmanyahFont,
                                      fontSize: width * 0.036,
                                      fontWeight: FontWeight.w500,
                                      color: homeDarkTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '15 سبتمبر 2026',
                                  style: TextStyle(
                                    fontFamily: thmanyahFont,
                                    fontSize: width * 0.034,
                                    fontWeight: FontWeight.w600,
                                    color: homeDarkTextColor,
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.004,
                                ),
                                Text(
                                  '10:30 ص',
                                  style: TextStyle(
                                    fontFamily: thmanyahFont,
                                    fontSize: width * 0.034,
                                    fontWeight: FontWeight.w500,
                                    color: homeDarkTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: height * 0.025),

                      // =================================================
                      // STATISTICS
                      // =================================================
                      Row(
                        children: [
                          Expanded(
                            child: _statCard(
                              width: width,
                              height: height,
                              icon: Icons.favorite_border_rounded,
                              number: '5',
                              title: 'أعراض مسجلة',
                              color: homePinkColor,
                            ),
                          ),

                          SizedBox(width: width * 0.025),

                          Expanded(
                            child: _statCard(
                              width: width,
                              height: height,
                              icon: Icons.show_chart_rounded,
                              number: '6.2',
                              title: 'متوسط الشدة',
                              color: homeGreenColor,
                            ),
                          ),

                          SizedBox(width: width * 0.025),

                          Expanded(
                            child: _statCard(
                              width: width,
                              height: height,
                              icon: Icons.calendar_today_outlined,
                              number: '12',
                              title: 'هذا الشهر',
                              color: homePurpleColor,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: height * 0.035),

                      // =================================================
                      // LATEST SYMPTOMS TITLE
                      // =================================================
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'آخر الأعراض',
                            style: TextStyle(
                              fontFamily: thmanyahFont,
                              fontSize: width * 0.055,
                              fontWeight: FontWeight.w700,
                              color: whiteColor,
                            ),
                          ),

                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const HistoryScreen(),
                                ),
                              );
                            },
                            child: Text(
                              'عرض الكل',
                              style: TextStyle(
                                fontFamily: thmanyahFont,
                                fontSize: width * 0.037,
                                fontWeight: FontWeight.w600,
                                color: whiteColor,
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: height * 0.015),

                      // =================================================
                      // SYMPTOM 1
                      // =================================================
                      _symptomCard(
                        width: width,
                        height: height,
                        title: 'صداع',
                        date: '12 سبتمبر 2026',
                        severity: '7',
                        color: homePinkColor,
                        icon: Icons.psychology_alt_outlined,
                      ),

                      SizedBox(height: height * 0.012),

                      // =================================================
                      // SYMPTOM 2
                      // =================================================
                      _symptomCard(
                        width: width,
                        height: height,
                        title: 'ألم في المعدة',
                        date: '10 سبتمبر 2026',
                        severity: '10',
                        color: homePinkColor,
                        icon: Icons.sick_outlined,
                      ),

                      SizedBox(height: height * 0.025),
                    ],
                  ),
                ),
              ),

              // =====================================================
              // BOTTOM NAVIGATION
              // =====================================================
              _bottomNavigation(width, height),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // STAT CARD
  // =============================================================

  Widget _statCard({
    required double width,
    required double height,
    required IconData icon,
    required String number,
    required String title,
    required Color color,
  }) {
    return Container(
      height: height * 0.145,
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.015,
        vertical: height * 0.015,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          width * 0.045,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: homeDarkTextColor,
            size: width * 0.055,
          ),

          SizedBox(height: height * 0.004),

          Text(
            number,
            style: TextStyle(
              fontFamily: thmanyahFont,
              fontSize: width * 0.06,
              fontWeight: FontWeight.w700,
              color: homeDarkTextColor,
            ),
          ),

          SizedBox(height: height * 0.002),

          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              maxLines: 1,
              style: TextStyle(
                fontFamily: thmanyahFont,
                fontSize: width * 0.033,
                fontWeight: FontWeight.w600,
                color: homeDarkTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // SYMPTOM CARD
  // =============================================================

  Widget _symptomCard({
    required double width,
    required double height,
    required String title,
    required String date,
    required String severity,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.016,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(
          width * 0.04,
        ),
        border: Border.all(
          color: homeBorderColor,
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: width * 0.12,
            height: width * 0.12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: homeDarkTextColor,
              size: width * 0.06,
            ),
          ),

          SizedBox(width: width * 0.03),

          // Name + date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: thmanyahFont,
                    fontSize: width * 0.045,
                    fontWeight: FontWeight.w700,
                    color: homeDarkTextColor,
                  ),
                ),

                SizedBox(height: height * 0.003),

                Text(
                  date,
                  style: TextStyle(
                    fontFamily: thmanyahFont,
                    fontSize: width * 0.034,
                    fontWeight: FontWeight.w500,
                    color: homeDarkTextColor,
                  ),
                ),
              ],
            ),
          ),

          // Severity
          Container(
            width: width * 0.105,
            height: width * 0.105,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Text(
              severity,
              style: TextStyle(
                fontFamily: thmanyahFont,
                fontSize: width * 0.045,
                fontWeight: FontWeight.w700,
                color: homeDarkTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // BOTTOM NAVIGATION
  // =============================================================

  Widget _bottomNavigation(
    double width,
    double height,
  ) {
    return SizedBox(
      height: 125,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // =====================================================
          // WHITE BAR
          // =====================================================
          ClipPath(
            clipper: TriangleNavigationClipper(),
            child: Container(
              width: double.infinity,
              height: 115,
              color: cardColor,
              padding: const EdgeInsets.only(
                top: 40,
              ),
              child: Row(
                children: [
                  // الرئيسية
                  Expanded(
                    child: _navItem(
                      width: width,
                      icon: Icons.home_outlined,
                      selectedIcon: Icons.home_rounded,
                      label: 'الرئيسية',
                      index: 0,
                    ),
                  ),

                  // السجل
                  Expanded(
                    child: _navItem(
                      width: width,
                      icon: Icons.calendar_today_outlined,
                      selectedIcon: Icons.calendar_month_rounded,
                      label: 'السجل',
                      index: 1,
                    ),
                  ),

                  // مكان زر +
                  const Expanded(
                    child: SizedBox(),
                  ),

                  // التقرير
                  Expanded(
                    child: _navItem(
                      width: width,
                      icon: Icons.bar_chart_outlined,
                      selectedIcon: Icons.bar_chart_rounded,
                      label: 'التقرير',
                      index: 3,
                    ),
                  ),

                  // حسابي
                  Expanded(
                    child: _navItem(
                      width: width,
                      icon: Icons.person_outline_rounded,
                      selectedIcon: Icons.person_rounded,
                      label: 'حسابي',
                      index: 4,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // =====================================================
          // ADD BUTTON
          // =====================================================
          Positioned(
            top: 4,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const AddConditionScreen(),
                  ),
                );
              },
              child: Container(
                width: width * 0.18,
                height: width * 0.18,
                decoration: const BoxDecoration(
                  color: homePrimaryColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add_rounded,
                  color: whiteColor,
                  size: width * 0.10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // NAV ITEM
  // =============================================================

  Widget _navItem({
    required double width,
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required int index,
  }) {
    final bool isSelected = selectedIndex == index;

    return InkWell(
      onTap: () {
        // =====================================================
        // HOME
        // =====================================================
        if (index == 0) {
          // نحن أصلاً في Home
          // لذلك ما نغير selectedIndex ولا نفتح صفحة جديدة
          return;
        }

        // =====================================================
        // HISTORY
        // =====================================================
        if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const HistoryScreen(),
            ),
          );
          return;
        }

        // =====================================================
        // REPORT
        // =====================================================
        if (index == 3) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  const ReportScreen(),
            ),
          );
          return;
        }

        // =====================================================
        // PROFILE
        // =====================================================
        if (index == 4) {
          // نربط صفحة الحساب لاحقاً
          return;
        }
      },

      child: SizedBox(
        height: 88,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // =================================================
            // ICON BACKGROUND
            // =================================================
            AnimatedContainer(
              duration: const Duration(
                milliseconds: 200,
              ),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 5,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? homeLightBlueColor
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                isSelected
                    ? selectedIcon
                    : icon,
                size: 27,
                color: isSelected
                    ? homePrimaryColor
                    : homeDarkTextColor,
              ),
            ),

            const SizedBox(height: 3),

            // =================================================
            // LABEL
            // =================================================
            Text(
              label,
              style: TextStyle(
                fontFamily: thmanyahFont,
                fontSize: width * 0.032,
                fontWeight: isSelected
                    ? FontWeight.w700
                    : FontWeight.w600,
                color: isSelected
                    ? homePrimaryColor
                    : homeDarkTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// TRIANGLE NAVIGATION CLIPPER
// =============================================================

class TriangleNavigationClipper
    extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, 40);

    path.lineTo(
      size.width * 0.36,
      40,
    );

    // رأس المثلث للأعلى
    path.lineTo(
      size.width * 0.50,
      0,
    );

    path.lineTo(
      size.width * 0.64,
      40,
    );

    path.lineTo(
      size.width,
      40,
    );

    path.lineTo(
      size.width,
      size.height,
    );

    path.lineTo(
      0,
      size.height,
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(
    covariant CustomClipper<Path> oldClipper,
  ) {
    return false;
  }
}
