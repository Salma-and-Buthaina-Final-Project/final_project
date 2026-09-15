import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:final_project/constants/colors.dart';
import 'package:final_project/constants/fonts.dart';
import 'package:final_project/utils/screen_size.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    final user = Supabase.instance.client.auth.currentUser;

    final String name =
        user?.userMetadata?['name']?.toString() ?? '';

    final String email = user?.email ?? '';

    nameController = TextEditingController(text: name);
    emailController = TextEditingController(text: email);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> updateUserInfo() async {
    final String newName = nameController.text.trim();

    if (newName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء كتابة الاسم'),
        ),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(
          data: {
            'name': newName,
          },
        ),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('تم تحديث المعلومات بنجاح'),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'حدث خطأ: $e',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = screenWidth(context);
    final height = screenHeight(context);

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: thmanyahFont,
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: backgroundColor,

          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            centerTitle: true,

            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_forward_ios_rounded,
                color: whiteColor,
                size: width * 0.05,
              ),
            ),

            title: Text(
              'معلوماتي الشخصية',
              style: TextStyle(
                fontFamily: thmanyahFont,
                fontSize: width * 0.06,
                fontWeight: FontWeight.w700,
                color: whiteColor,
              ),
            ),
          ),

          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.055,
                vertical: height * 0.025,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // =================================================
                  // PROFILE ICON
                  // =================================================
                  Center(
                    child: Container(
                      width: width * 0.24,
                      height: width * 0.24,
                      decoration: BoxDecoration(
                        color: homeLightBlueColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: whiteColor,
                          width: 3,
                        ),
                      ),
                      child: Icon(
                        Icons.person_rounded,
                        color: homeDarkTextColor,
                        size: width * 0.14,
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.04),

                  // =================================================
                  // NAME TITLE
                  // =================================================
                  Text(
                    'الاسم',
                    style: TextStyle(
                      fontFamily: thmanyahFont,
                      fontSize: width * 0.043,
                      fontWeight: FontWeight.w700,
                      color: whiteColor,
                    ),
                  ),

                  SizedBox(height: height * 0.01),

                  // =================================================
                  // NAME FIELD
                  // =================================================
                  TextField(
                    controller: nameController,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: thmanyahFont,
                      fontSize: width * 0.041,
                      fontWeight: FontWeight.w500,
                      color: homeDarkTextColor,
                    ),
                    decoration: _inputDecoration(
                      width: width,
                      hint: 'الاسم',
                      icon: Icons.person_outline_rounded,
                      iconColor: homeLightBlueColor,
                    ),
                  ),

                  SizedBox(height: height * 0.025),

                  // =================================================
                  // EMAIL TITLE
                  // =================================================
                  Text(
                    'البريد الإلكتروني',
                    style: TextStyle(
                      fontFamily: thmanyahFont,
                      fontSize: width * 0.043,
                      fontWeight: FontWeight.w700,
                      color: whiteColor,
                    ),
                  ),

                  SizedBox(height: height * 0.01),

                  // =================================================
                  // EMAIL FIELD
                  // =================================================
                  TextField(
                    controller: emailController,

                    // نخلي الإيميل للعرض فقط
                    readOnly: true,

                    textDirection: TextDirection.ltr,
                    textAlign: TextAlign.left,

                    style: TextStyle(
                      fontFamily: thmanyahFont,
                      fontSize: width * 0.041,
                      fontWeight: FontWeight.w500,
                      color: homeDarkTextColor,
                    ),

                    decoration: _inputDecoration(
                      width: width,
                      hint: 'البريد الإلكتروني',
                      icon: Icons.email_outlined,
                      iconColor: homePurpleColor,
                    ),
                  ),

                  SizedBox(height: height * 0.015),

                  Text(
                    'البريد الإلكتروني مرتبط بحسابك ولا يمكن تعديله من هنا.',
                    style: TextStyle(
                      fontFamily: thmanyahFont,
                      fontSize: width * 0.032,
                      fontWeight: FontWeight.w400,
                      color: secondaryTextColor,
                    ),
                  ),

                  SizedBox(height: height * 0.04),

                  // =================================================
                  // SAVE BUTTON
                  // =================================================
                  SizedBox(
                    height: height * 0.065,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : updateUserInfo,

                      style: ElevatedButton.styleFrom(
                        backgroundColor: homePrimaryColor,
                        foregroundColor: whiteColor,
                        elevation: 0,

                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            width * 0.04,
                          ),
                        ),
                      ),

                      child: isLoading
                          ? SizedBox(
                              width: width * 0.055,
                              height: width * 0.055,
                              child:
                                  const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: whiteColor,
                              ),
                            )
                          : Text(
                              'حفظ التعديلات',
                              style: TextStyle(
                                fontFamily: thmanyahFont,
                                fontSize: width * 0.043,
                                fontWeight: FontWeight.w700,
                                color: whiteColor,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // INPUT DECORATION
  // =========================================================
  InputDecoration _inputDecoration({
    required double width,
    required String hint,
    required IconData icon,
    required Color iconColor,
  }) {
    return InputDecoration(
      hintText: hint,

      hintStyle: TextStyle(
        fontFamily: thmanyahFont,
        color: homeGreyColor,
        fontSize: width * 0.038,
      ),

      prefixIcon: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: homeDarkTextColor,
            size: 20,
          ),
        ),
      ),

      filled: true,
      fillColor: cardColor,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 16,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: homeBorderColor,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: homeBorderColor,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: homePrimaryColor,
          width: 1.5,
        ),
      ),
    );
  }
}