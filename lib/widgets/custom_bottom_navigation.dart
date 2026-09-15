import 'package:flutter/material.dart';

import 'package:final_project/constants/colors.dart';
import 'package:final_project/constants/fonts.dart';

import 'package:final_project/screens/home_screen.dart';
import 'package:final_project/screens/history_screen.dart';
import 'package:final_project/screens/add_condition_screen.dart';
import 'package:final_project/screens/report_screen.dart';
import 'package:final_project/screens/profile_screen.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int selectedIndex;

  const CustomBottomNavigation({
    super.key,
    required this.selectedIndex,
  });

  void _navigate(
    BuildContext context,
    Widget page,
    int index,
  ) {
    if (selectedIndex == index) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 125,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // =================================================
          // BAR + TRIANGLE
          // =================================================
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipPath(
              clipper: TriangleNavigationClipper(),
              child: Container(
                height: 115,
                color: cardColor,
              ),
            ),
          ),

          // =================================================
          // NAV ITEMS
          // =================================================
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 88,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // الرئيسية
                _navItem(
                  context: context,
                  icon: Icons.home_rounded,
                  label: 'الرئيسية',
                  index: 0,
                  page: const HomeScreen(),
                ),

                // السجل
                _navItem(
                  context: context,
                  icon: Icons.article_rounded,
                  label: 'السجل',
                  index: 1,
                  page: const HistoryScreen(),
                ),

                // مكان زر +
                SizedBox(
                  width: width * 0.18,
                ),

                // التقرير
                _navItem(
                  context: context,
                  icon: Icons.bar_chart_rounded,
                  label: 'التقرير',
                  index: 3,
                  page: const ReportScreen(),
                ),

                // حسابي
                _navItem(
                  context: context,
                  icon: Icons.person_outline_rounded,
                  label: 'حسابي',
                  index: 4,
                  page: const ProfileScreen(),
                ),
              ],
            ),
          ),

          // =================================================
          // PLUS BUTTON
          // =================================================
          Positioned(
            top: 4,
            child: GestureDetector(
              onTap: () {
                _navigate(
                  context,
                  const AddConditionScreen(),
                  2,
                );
              },
              child: Container(
                width: width * 0.18,
                height: width * 0.18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: homePrimaryColor,

                  // نفس الحد الأبيض
                  border: Border.all(
                    color: whiteColor,
                    width: 5,
                  ),

                  // نفس الـ Shadow
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
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

  // =========================================================
  // NAV ITEM
  // =========================================================
  Widget _navItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
    required Widget page,
  }) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _navigate(
          context,
          page,
          index,
        );
      },
      child: SizedBox(
        width: 65,
        height: 70,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
                icon,
                size: 27,
                color: isSelected
                    ? homePrimaryColor
                    : homeDarkTextColor,
              ),
            ),

            const SizedBox(height: 2),

            Text(
              label,
              maxLines: 1,
              style: TextStyle(
                fontFamily: thmanyahFont,
                fontSize: 11,
                fontWeight: isSelected
                    ? FontWeight.bold
                    : FontWeight.w500,
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

// ===========================================================
// TRIANGLE BOTTOM NAVIGATION SHAPE ▲
// ===========================================================

class TriangleNavigationClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, 40);

    // قبل المثلث
    path.lineTo(
      size.width * 0.36,
      40,
    );

    // رأس المثلث للأعلى
    path.lineTo(
      size.width * 0.50,
      0,
    );

    // بعد المثلث
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