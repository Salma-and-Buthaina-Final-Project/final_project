import 'package:flutter/material.dart';

import 'package:final_project/constants/colors.dart';
import 'package:final_project/constants/fonts.dart';
import 'package:final_project/utils/screen_size.dart';
import 'package:final_project/widgets/custom_bottom_navigation.dart';

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
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

    return Theme(
      // =====================================================
      // خط ثمانية للصفحة كاملة
      // =====================================================
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: thmanyahFont,
        ),
      ),

      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: backgroundColor,

          // =====================================================
          // BODY
          // =====================================================
          body: SafeArea(
            bottom: false,
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
                  // EXPORT / SHARE
                  // =================================================
                  Row(
                    children: [
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
          // CUSTOM BOTTOM NAVIGATION
          // =====================================================
          bottomNavigationBar: const CustomBottomNavigation(
            selectedIndex: 3,
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
}