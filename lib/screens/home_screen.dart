import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:final_project/constants/colors.dart';
import 'package:final_project/constants/fonts.dart';
import 'package:final_project/utils/screen_size.dart';

import 'package:final_project/screens/history_screen.dart';
import 'package:final_project/screens/appointment_screen.dart';
import 'package:final_project/widgets/custom_bottom_navigation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final width = screenWidth(context);
    final height = screenHeight(context);

    // المستخدم المسجل دخوله حالياً
    final user = Supabase.instance.client.auth.currentUser;

    // اسم المستخدم من Supabase
    final String name = user?.userMetadata?['name']?.toString() ?? 'المستخدم';

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(fontFamily: thmanyahFont),
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
            child: Column(
              children: [
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
                                border: Border.all(color: whiteColor, width: 2),
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
                                    'مرحباً بكِ $name',
                                    style: TextStyle(
                                      fontFamily: thmanyahFont,
                                      fontSize: width * 0.043,
                                      fontWeight: FontWeight.w600,
                                      color: whiteColor,
                                    ),
                                  ),
                                  Text(
                                    'كيف حالتك اليوم؟',
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
                                border: Border.all(color: whiteColor, width: 2),
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
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AppointmentScreen(),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(width * 0.05),
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: width * 0.045,
                              vertical: height * 0.022,
                            ),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(width * 0.05),
                              border: Border.all(color: homeBorderColor),
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
                                      SizedBox(height: height * 0.004),
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
                                    SizedBox(height: height * 0.004),
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
                                    builder: (context) => const HistoryScreen(),
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
              ],
            ),
          ),

          // =====================================================
          // CUSTOM BOTTOM NAVIGATION
          // =====================================================
          bottomNavigationBar: const CustomBottomNavigation(selectedIndex: 0),
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
        borderRadius: BorderRadius.circular(width * 0.045),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: homeDarkTextColor, size: width * 0.055),

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
        borderRadius: BorderRadius.circular(width * 0.04),
        border: Border.all(color: homeBorderColor),
      ),
      child: Row(
        children: [
          Container(
            width: width * 0.12,
            height: width * 0.12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: homeDarkTextColor, size: width * 0.06),
          ),

          SizedBox(width: width * 0.03),

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

          Container(
            width: width * 0.105,
            height: width * 0.105,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
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
}
