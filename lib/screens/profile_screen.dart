import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:final_project/constants/colors.dart';
import 'package:final_project/constants/fonts.dart';
import 'package:final_project/utils/screen_size.dart';
import 'package:final_project/widgets/custom_bottom_navigation.dart';

import 'package:final_project/screens/login_screen.dart';
import 'package:final_project/screens/appointment_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = screenWidth(context);
    final height = screenHeight(context);

    // المستخدم المسجل دخوله حاليًا
    final user = Supabase.instance.client.auth.currentUser;

    // الاسم المحفوظ في Supabase
    final String name = user?.userMetadata?['name']?.toString() ?? 'المستخدم';

    // الإيميل
    final String email = user?.email ?? '';

    return Theme(
      // =====================================================
      // خط ثمانية للصفحة كاملة
      // =====================================================
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
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.055,
                vertical: height * 0.025,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // =================================================
                  // TITLE
                  // =================================================
                  Center(
                    child: Text(
                      'حسابي',
                      style: TextStyle(
                        fontFamily: thmanyahFont,
                        fontSize: width * 0.07,
                        fontWeight: FontWeight.w700,
                        color: whiteColor,
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.03),

                  // =================================================
                  // PROFILE IMAGE
                  // =================================================
                  Center(
                    child: Container(
                      width: width * 0.24,
                      height: width * 0.24,
                      decoration: BoxDecoration(
                        color: homeLightBlueColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: whiteColor, width: 3),
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        color: homeDarkTextColor,
                        size: width * 0.14,
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.015),

                  // =================================================
                  // NAME
                  // =================================================
                  Center(
                    child: Text(
                      name,
                      style: TextStyle(
                        fontFamily: thmanyahFont,
                        fontSize: width * 0.06,
                        fontWeight: FontWeight.w700,
                        color: whiteColor,
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.005),

                  // =================================================
                  // EMAIL
                  // =================================================
                  Center(
                    child: Text(
                      email,
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        fontFamily: thmanyahFont,
                        fontSize: width * 0.035,
                        fontWeight: FontWeight.w500,
                        color: secondaryTextColor,
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.035),

                  // =================================================
                  // ACCOUNT OPTIONS
                  // =================================================
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(width * 0.045),
                      border: Border.all(color: homeBorderColor),
                    ),
                    child: Column(
                      children: [
                        // =================================================
                        // PERSONAL INFORMATION
                        // =================================================
                        _profileItem(
                          width: width,
                          height: height,
                          icon: Icons.person_outline_rounded,
                          title: 'معلوماتي الشخصية',
                          iconColor: homeLightBlueColor,
                          onTap: () {
                            // نربطها لاحقًا
                          },
                        ),

                        _divider(width),

                        // =================================================
                        // APPOINTMENT
                        // =================================================
                        _profileItem(
                          width: width,
                          height: height,
                          icon: Icons.calendar_month_outlined,
                          title: 'موعد المراجعة',
                          iconColor: homeGreenColor,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AppointmentScreen(),
                              ),
                            );
                          },
                        ),

                        _divider(width),

                        // =================================================
                        // NOTIFICATIONS
                        // =================================================
                        _profileItem(
                          width: width,
                          height: height,
                          icon: Icons.notifications_none_rounded,
                          title: 'الإشعارات',
                          iconColor: homeYellowColor,
                          onTap: () {
                            // نربطها لاحقًا
                          },
                        ),

                        _divider(width),

                        // =================================================
                        // HELP
                        // =================================================
                        _profileItem(
                          width: width,
                          height: height,
                          icon: Icons.help_outline_rounded,
                          title: 'المساعدة والدعم',
                          iconColor: homePurpleColor,
                          onTap: () {
                            // نربطها لاحقًا
                          },
                        ),

                        _divider(width),

                        // =================================================
                        // PRIVACY
                        // =================================================
                        _profileItem(
                          width: width,
                          height: height,
                          icon: Icons.privacy_tip_outlined,
                          title: 'سياسة الخصوصية',
                          iconColor: homePinkColor,
                          onTap: () {
                            // نربطها لاحقًا
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: height * 0.03),

                  // =================================================
                  // LOGOUT BUTTON
                  // =================================================
                  SizedBox(
                    height: height * 0.065,
                    child: ElevatedButton(
                      onPressed: () async {
                        await Supabase.instance.client.auth.signOut();

                        if (!context.mounted) return;

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: cardColor,
                        foregroundColor: Colors.red,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(width * 0.04),
                          side: const BorderSide(color: homePinkColor),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            color: Colors.red,
                            size: width * 0.055,
                          ),

                          SizedBox(width: width * 0.02),

                          Text(
                            'تسجيل الخروج',
                            style: TextStyle(
                              fontFamily: thmanyahFont,
                              fontSize: width * 0.042,
                              fontWeight: FontWeight.w700,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.03),
                ],
              ),
            ),
          ),

          // =====================================================
          // CUSTOM BOTTOM NAVIGATION
          // =====================================================
          bottomNavigationBar: const CustomBottomNavigation(selectedIndex: 4),
        ),
      ),
    );
  }

  // =========================================================
  // PROFILE ITEM
  // =========================================================
  Widget _profileItem({
    required double width,
    required double height,
    required IconData icon,
    required String title,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.035,
            vertical: height * 0.014,
          ),
          child: Row(
            children: [
              // =================================================
              // ICON
              // =================================================
              Container(
                width: width * 0.105,
                height: width * 0.105,
                decoration: BoxDecoration(
                  color: iconColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: homeDarkTextColor,
                  size: width * 0.052,
                ),
              ),

              SizedBox(width: width * 0.03),

              // =================================================
              // TITLE
              // =================================================
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: thmanyahFont,
                    fontSize: width * 0.041,
                    fontWeight: FontWeight.w600,
                    color: homeDarkTextColor,
                  ),
                ),
              ),

              // =================================================
              // ARROW
              // =================================================
              Icon(
                Icons.arrow_back_ios_new_rounded,
                color: homeGreyColor,
                size: width * 0.04,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================================================
  // DIVIDER
  // =========================================================
  Widget _divider(double width) {
    return Divider(
      height: 1,
      thickness: 1,
      color: homeBorderColor,
      indent: width * 0.04,
      endIndent: width * 0.04,
    );
  }
}
