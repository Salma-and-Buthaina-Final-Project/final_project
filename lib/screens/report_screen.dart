import 'package:flutter/material.dart';
import 'package:final_project/constants/colors.dart';
import 'package:final_project/constants/fonts.dart';
import 'package:final_project/utils/screen_size.dart';
import 'package:final_project/screens/home_screen.dart';
import 'package:final_project/screens/history_screen.dart';
import 'package:final_project/screens/add_condition_screen.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int selectedIndex = 3;

  final List<Map<String, dynamic>> symptoms = [
    {
      'title': 'صداع',
      'count': 4,
      'progress': 1.0,
      'color': homePinkColor,
      'icon': Icons.psychology_alt_outlined,
    },
    {
      'title': 'ألم في المعدة',
      'count': 3,
      'progress': 0.75,
      'color': homePurpleColor,
      'icon': Icons.sick_outlined,
    },
    {
      'title': 'غثيان',
      'count': 2,
      'progress': 0.50,
      'color': homeLightBlueColor,
      'icon': Icons.sentiment_dissatisfied_outlined,
    },
    {
      'title': 'ألم في الظهر',
      'count': 2,
      'progress': 0.50,
      'color': homeYellowColor,
      'icon': Icons.accessibility_new_rounded,
    },
    {
      'title': 'ضيق تنفس',
      'count': 1,
      'progress': 0.25,
      'color': homeGreenColor,
      'icon': Icons.air_rounded,
    },
  ];

  final List<String> medicines = [
    'باراسيتامول',
    'أوميبرازول',
    'مسكن للألم',
  ];

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
              // PAGE CONTENT
              // =====================================================
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    right: width * 0.055,
                    left: width * 0.055,
                    top: height * 0.025,
                    bottom: height * 0.03,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // =================================================
                      // TITLE
                      // =================================================
                      Center(
                        child: Text(
                          'التقرير الصحي',
                          style: TextStyle(
                            fontFamily: thmanyahFont,
                            fontSize: width * 0.07,
                            fontWeight: FontWeight.w700,
                            color: whiteColor,
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.025),

                      // =================================================
                      // DATE RANGE
                      // =================================================
                      InkWell(
                        onTap: () {
                          // نربط اختيار التاريخ لاحقاً
                        },
                        borderRadius: BorderRadius.circular(
                          width * 0.04,
                        ),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: width * 0.04,
                            vertical: height * 0.018,
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
                              // Calendar
                              Container(
                                width: width * 0.11,
                                height: width * 0.11,
                                decoration: const BoxDecoration(
                                  color: homeLightBlueColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.calendar_month_outlined,
                                  color: homeDarkTextColor,
                                  size: width * 0.055,
                                ),
                              ),

                              SizedBox(width: width * 0.03),

                              Expanded(
                                child: Text(
                                  '1 سبتمبر 2026 - 15 سبتمبر 2026',
                                  style: TextStyle(
                                    fontFamily: thmanyahFont,
                                    fontSize: width * 0.039,
                                    fontWeight: FontWeight.w600,
                                    color: homeDarkTextColor,
                                  ),
                                ),
                              ),

                              Icon(
                                Icons.keyboard_arrow_down_rounded,
                                color: homeDarkTextColor,
                                size: width * 0.06,
                              ),
                            ],
                          ),
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
                              number: '5',
                              title: 'أنواع الأعراض',
                              color: homePinkColor,
                            ),
                          ),

                          SizedBox(width: width * 0.025),

                          Expanded(
                            child: _statCard(
                              width: width,
                              height: height,
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
                              number: '12',
                              title: 'مرات التكرار',
                              color: homePurpleColor,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: height * 0.035),

                      // =================================================
                      // MOST FREQUENT SYMPTOMS
                      // =================================================
                      Text(
                        'أكثر الأعراض تكراراً',
                        style: TextStyle(
                          fontFamily: thmanyahFont,
                          fontSize: width * 0.055,
                          fontWeight: FontWeight.w700,
                          color: whiteColor,
                        ),
                      ),

                      SizedBox(height: height * 0.018),

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.04,
                          vertical: height * 0.02,
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
                        child: Column(
                          children: List.generate(
                            symptoms.length,
                            (index) {
                              final symptom = symptoms[index];

                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: index == symptoms.length - 1
                                      ? 0
                                      : height * 0.018,
                                ),
                                child: _symptomProgress(
                                  width: width,
                                  height: height,
                                  title: symptom['title'],
                                  count: symptom['count'],
                                  progress: symptom['progress'],
                                  color: symptom['color'],
                                  icon: symptom['icon'],
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.035),

                      // =================================================
                      // MEDICINES
                      // =================================================
                      Text(
                        'الأدوية المستخدمة',
                        style: TextStyle(
                          fontFamily: thmanyahFont,
                          fontSize: width * 0.055,
                          fontWeight: FontWeight.w700,
                          color: whiteColor,
                        ),
                      ),

                      SizedBox(height: height * 0.015),

                      Wrap(
                        spacing: width * 0.025,
                        runSpacing: height * 0.012,
                        children: medicines.map((medicine) {
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.04,
                              vertical: height * 0.012,
                            ),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(
                                width * 0.035,
                              ),
                              border: Border.all(
                                color: homeBorderColor,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: width * 0.065,
                                  height: width * 0.065,
                                  decoration: const BoxDecoration(
                                    color: homeGreenColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.medication_outlined,
                                    color: homeDarkTextColor,
                                    size: width * 0.035,
                                  ),
                                ),

                                SizedBox(width: width * 0.018),

                                Text(
                                  medicine,
                                  style: TextStyle(
                                    fontFamily: thmanyahFont,
                                    fontSize: width * 0.037,
                                    fontWeight: FontWeight.w600,
                                    color: homeDarkTextColor,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),

                      SizedBox(height: height * 0.035),

                      // =================================================
                      // EXPORT / SHARE BUTTONS
                      // =================================================
                      Row(
                        children: [
                          // EXPORT PDF
                          Expanded(
                            child: SizedBox(
                              height: height * 0.065,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // PDF functionality later
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: homePrimaryColor,
                                  foregroundColor: whiteColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      width * 0.04,
                                    ),
                                  ),
                                ),
                                icon: Icon(
                                  Icons.download_rounded,
                                  color: whiteColor,
                                  size: width * 0.055,
                                ),
                                label: Text(
                                  'تصدير PDF',
                                  style: TextStyle(
                                    fontFamily: thmanyahFont,
                                    fontSize: width * 0.039,
                                    fontWeight: FontWeight.w700,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          SizedBox(width: width * 0.03),

                          // SHARE
                          Expanded(
                            child: SizedBox(
                              height: height * 0.065,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // Share functionality later
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor: homePrimaryColor,
                                  foregroundColor: whiteColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      width * 0.04,
                                    ),
                                  ),
                                ),
                                icon: Icon(
                                  Icons.ios_share_rounded,
                                  color: whiteColor,
                                  size: width * 0.05,
                                ),
                                label: Text(
                                  'مشاركة PDF',
                                  style: TextStyle(
                                    fontFamily: thmanyahFont,
                                    fontSize: width * 0.039,
                                    fontWeight: FontWeight.w700,
                                    color: whiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
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

  // =========================================================
  // STAT CARD
  // =========================================================

  Widget _statCard({
    required double width,
    required double height,
    required String number,
    required String title,
    required Color color,
  }) {
    return Container(
      height: height * 0.14,
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.015,
        vertical: height * 0.018,
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
          Text(
            number,
            style: TextStyle(
              fontFamily: thmanyahFont,
              fontSize: width * 0.07,
              fontWeight: FontWeight.w700,
              color: homeDarkTextColor,
            ),
          ),

          SizedBox(height: height * 0.006),

          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              maxLines: 1,
              style: TextStyle(
                fontFamily: thmanyahFont,
                fontSize: width * 0.034,
                fontWeight: FontWeight.w600,
                color: homeDarkTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // SYMPTOM PROGRESS
  // =========================================================

  Widget _symptomProgress({
    required double width,
    required double height,
    required String title,
    required int count,
    required double progress,
    required Color color,
    required IconData icon,
  }) {
    return Row(
      children: [
        // Symptom icon
        Container(
          width: width * 0.09,
          height: width * 0.09,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: homeDarkTextColor,
            size: width * 0.045,
          ),
        ),

        SizedBox(width: width * 0.025),

        // Symptom name
        SizedBox(
          width: width * 0.20,
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: thmanyahFont,
              fontSize: width * 0.037,
              fontWeight: FontWeight.w600,
              color: homeDarkTextColor,
            ),
          ),
        ),

        SizedBox(width: width * 0.02),

        // Progress
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: height * 0.014,
              backgroundColor: homeBorderColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                color,
              ),
            ),
          ),
        ),

        SizedBox(width: width * 0.025),

        // Count
        SizedBox(
          width: width * 0.055,
          child: Text(
            '$count',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: thmanyahFont,
              fontSize: width * 0.042,
              fontWeight: FontWeight.w700,
              color: homeDarkTextColor,
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // BOTTOM NAVIGATION
  // =========================================================

  Widget _bottomNavigation(double width, double height) {
    return SizedBox(
      height: 125,
      child: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          // White navigation shape
          ClipPath(
            clipper: TriangleNavigationClipper(),
            child: Container(
              height: 115,
              width: double.infinity,
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

                  // مساحة للزر +
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
          // PLUS BUTTON
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

  // =========================================================
  // NAV ITEM
  // =========================================================

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
        // الرئيسية
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HomeScreen(),
            ),
          );
          return;
        }

        // السجل
        if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const HistoryScreen(),
            ),
          );
          return;
        }

        // التقرير
        if (index == 3) {
          setState(() {
            selectedIndex = 3;
          });
          return;
        }

        // الحساب - نربطه لاحقاً
        if (index == 4) {
          setState(() {
            selectedIndex = 4;
          });
        }
      },
      child: SizedBox(
        height: 88,
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
                isSelected ? selectedIcon : icon,
                size: 27,
                color: isSelected
                    ? homePrimaryColor
                    : homeDarkTextColor,
              ),
            ),

            const SizedBox(height: 3),

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
// TRIANGLE BOTTOM NAV CLIPPER
// =============================================================

class TriangleNavigationClipper extends CustomClipper<Path> {
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