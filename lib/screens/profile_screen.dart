import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:final_project/constants/colors.dart';
import 'package:final_project/constants/fonts.dart';
import 'package:final_project/utils/screen_size.dart';
import 'package:final_project/widgets/custom_bottom_navigation.dart';

import 'package:final_project/screens/login_screen.dart';
import 'package:final_project/screens/appointment_screen.dart';
import 'package:final_project/screens/personal_info_screen.dart';
import 'package:final_project/screens/help_support_screen.dart';
import 'package:final_project/screens/privacy_policy_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String selectedProfileImage = 'assets/default.png';

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  // =========================================================
  // LOAD PROFILE IMAGE
  // =========================================================
  void _loadProfileImage() {
    final user = Supabase.instance.client.auth.currentUser;

    final savedImage = user?.userMetadata?['profile_image']?.toString();

    if (savedImage != null && savedImage.isNotEmpty) {
      selectedProfileImage = savedImage;
    }
  }

  // =========================================================
  // CHANGE PROFILE IMAGE
  // =========================================================
  Future<void> _changeProfileImage(String imagePath) async {
    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(data: {'profile_image': imagePath}),
      );

      if (!mounted) return;

      setState(() {
        selectedProfileImage = imagePath;
      });

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'حدث خطأ أثناء تغيير الصورة',
            style: TextStyle(fontFamily: thmanyahFont),
          ),
        ),
      );
    }
  }

  // =========================================================
  // PROFILE IMAGE OPTIONS
  // =========================================================
  void _showProfileImageOptions() {
    final width = screenWidth(context);

    showModalBottomSheet(
      context: context,
      backgroundColor: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(width * 0.06)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: EdgeInsets.all(width * 0.06),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'اختر صورة الملف الشخصي',
                  style: TextStyle(
                    fontFamily: thmanyahFont,
                    fontSize: width * 0.05,
                    fontWeight: FontWeight.w700,
                    color: homeDarkTextColor,
                  ),
                ),

                SizedBox(height: width * 0.06),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _profileImageOption(
                      width: width,
                      imagePath: 'assets/girl.png',
                      title: 'فتاة',
                    ),

                    _profileImageOption(
                      width: width,
                      imagePath: 'assets/boy.png',
                      title: 'ولد',
                    ),

                    _profileImageOption(
                      width: width,
                      imagePath: 'assets/default.png',
                      title: 'افتراضي',
                    ),
                  ],
                ),

                SizedBox(height: width * 0.04),
              ],
            ),
          ),
        );
      },
    );
  }

  // =========================================================
  // PROFILE IMAGE OPTION
  // =========================================================
  Widget _profileImageOption({
    required double width,
    required String imagePath,
    required String title,
  }) {
    final bool isSelected = selectedProfileImage == imagePath;

    return GestureDetector(
      onTap: () {
        _changeProfileImage(imagePath);
      },
      child: Column(
        children: [
          Container(
            width: width * 0.20,
            height: width * 0.20,
            padding: EdgeInsets.all(width * 0.008),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? homePrimaryColor : homeBorderColor,
                width: isSelected ? 3 : 1,
              ),
            ),
            child: ClipOval(child: Image.asset(imagePath, fit: BoxFit.cover)),
          ),

          SizedBox(height: width * 0.02),

          Text(
            title,
            style: TextStyle(
              fontFamily: thmanyahFont,
              fontSize: width * 0.035,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              color: homeDarkTextColor,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // LOGOUT CONFIRMATION
  // =========================================================
  void _showLogoutDialog() {
    final width = screenWidth(context);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(width * 0.05),
            ),

            title: Center(
              child: Text(
                'تسجيل الخروج',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: thmanyahFont,
                  fontWeight: FontWeight.w700,
                  color: homeDarkTextColor,
                ),
              ),
            ),

            content: Text(
              'هل أنت متأكد من تسجيل الخروج؟',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: thmanyahFont, color: homeGreyColor),
            ),

            actionsPadding: EdgeInsets.only(
              right: width * 0.04,
              left: width * 0.04,
              bottom: width * 0.04,
            ),

            actions: [
              Row(
                children: [
                  // =================================================
                  // CANCEL BUTTON
                  // =================================================
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      child: Center(
                        child: Text(
                          'إلغاء',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: thmanyahFont,
                            fontWeight: FontWeight.w600,
                            color: homeGreyColor,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: width * 0.02),

                  // =================================================
                  // LOGOUT BUTTON
                  // =================================================
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        Navigator.pop(dialogContext);

                        await Supabase.instance.client.auth.signOut();

                        if (!mounted) return;

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      child: Center(
                        child: Text(
                          'تسجيل الخروج',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: thmanyahFont,
                            fontWeight: FontWeight.w700,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = screenWidth(context);
    final height = screenHeight(context);

    // المستخدم المسجل دخوله حاليًا
    final user = Supabase.instance.client.auth.currentUser;

    // الاسم المحفوظ في Supabase
    final String name = user?.userMetadata?['name']?.toString() ?? 'المستخدم';

    // البريد الإلكتروني
    final String email = user?.email ?? '';

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
                    child: GestureDetector(
                      onTap: _showProfileImageOptions,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            width: width * 0.24,
                            height: width * 0.24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: whiteColor, width: 3),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                selectedProfileImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          Positioned(
                            bottom: 0,
                            left: 0,
                            child: Container(
                              width: width * 0.075,
                              height: width * 0.075,
                              decoration: BoxDecoration(
                                color: homePrimaryColor,
                                shape: BoxShape.circle,
                                border: Border.all(color: whiteColor, width: 2),
                              ),
                              child: Icon(
                                Icons.edit_rounded,
                                color: whiteColor,
                                size: width * 0.04,
                              ),
                            ),
                          ),
                        ],
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const PersonalInfoScreen(),
                              ),
                            );
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
                            // سيتم ربط صفحة الإشعارات لاحقًا
                          },
                        ),

                        _divider(width),

                        // =================================================
                        // HELP & SUPPORT
                        // =================================================
                        _profileItem(
                          width: width,
                          height: height,
                          icon: Icons.help_outline_rounded,
                          title: 'المساعدة والدعم',
                          iconColor: homePurpleColor,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HelpSupportScreen(),
                              ),
                            );
                          },
                        ),

                        _divider(width),

                        // =================================================
                        // PRIVACY POLICY
                        // =================================================
                        _profileItem(
                          width: width,
                          height: height,
                          icon: Icons.privacy_tip_outlined,
                          title: 'سياسة الخصوصية',
                          iconColor: homePinkColor,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const PrivacyPolicyScreen(),
                              ),
                            );
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
                      onPressed: _showLogoutDialog,
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
