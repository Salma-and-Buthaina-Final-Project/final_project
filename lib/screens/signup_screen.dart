import 'package:final_project/constants/colors.dart';
import 'package:final_project/services/database.dart';
import 'package:final_project/utils/screen_size.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = screenWidth(context);
    final height = screenHeight(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      resizeToAvoidBottomInset: false,

      body: Stack(
        children: [
          // الخلفية
          Positioned.fill(
            child: Image.asset(
              "assets/background.png",
              width: width,
              height: height,
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.07,
              ),
              child: Column(
                children: [
                  SizedBox(height: height * 0.015),

                  // زر الرجوع
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: width * 0.10,
                      height: width * 0.10,
                      decoration: const BoxDecoration(
                        color: cardColor,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(
                          Icons.arrow_back_ios_new,
                          size: width * 0.04,
                          color: darkBlueColor,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.005),

                  // الشعار
                  Image.asset(
                    "assets/logo.png",
                    width: width * 0.25,
                    height: height * 0.105,
                    fit: BoxFit.contain,
                  ),

                  SizedBox(height: height * 0.005),

                  // العنوان
                  Text(
                    "إنشاء حساب",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width * 0.07,
                      fontWeight: FontWeight.bold,
                      color: mainTextColor,
                    ),
                  ),

                  SizedBox(height: height * 0.006),

                  Text(
                    "ابدأ رحلتك لمتابعة حالتك الصحية",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width * 0.035,
                      color: secondaryTextColor,
                    ),
                  ),

                  SizedBox(height: height * 0.03),

                  // الاسم
                  SizedBox(
                    width: width,
                    height: height * 0.065,
                    child: TextField(
                      controller: nameController,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: width * 0.037,
                        color: inputTextColor,
                      ),
                      decoration: inputDecoration(
                        context: context,
                        hint: "الاسم الكامل",
                        icon: Icons.person_outline,
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.015),

                  // البريد الإلكتروني
                  SizedBox(
                    width: width,
                    height: height * 0.065,
                    child: TextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: width * 0.037,
                        color: inputTextColor,
                      ),
                      decoration: inputDecoration(
                        context: context,
                        hint: "البريد الإلكتروني",
                        icon: Icons.email_outlined,
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.015),

                  // كلمة المرور
                  SizedBox(
                    width: width,
                    height: height * 0.065,
                    child: TextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: width * 0.037,
                        color: inputTextColor,
                      ),
                      decoration: inputDecoration(
                        context: context,
                        hint: "كلمة المرور",
                        icon: Icons.lock_outline,
                        suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            color: primaryColor,
                            size: width * 0.05,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.025),

                  // زر إنشاء حساب
                  SizedBox(
                    width: width,
                    height: height * 0.065,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: whiteColor,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            width * 0.04,
                          ),
                        ),
                      ),
                      onPressed: () async {
                        try {
                          await Database().signupUser(
                            name: nameController.text.trim(),
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );

                          if (!mounted) return;

                          Navigator.pop(context);
                        } catch (e) {
                          if (!mounted) return;

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.toString()),
                            ),
                          );
                        }
                      },
                      child: Center(
                        child: Text(
                          "إنشاء حساب",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.02),

                  // لديك حساب بالفعل؟ تسجيل الدخول
                  Container(
                    width: width,
                    height: height * 0.065,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(
                        width * 0.04,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      textDirection: TextDirection.rtl,
                      children: [
                        Text(
                          "لديك حساب بالفعل؟",
                          style: TextStyle(
                            fontSize: width * 0.032,
                            color: inputTextColor,
                          ),
                        ),

                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "تسجيل الدخول",
                            style: TextStyle(
                              fontSize: width * 0.032,
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  InputDecoration inputDecoration({
    required BuildContext context,
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    final width = screenWidth(context);

    return InputDecoration(
      hintText: hint,

      hintStyle: TextStyle(
        color: hintTextColor,
        fontSize: width * 0.034,
      ),

      prefixIcon: Icon(
        icon,
        color: primaryColor,
        size: width * 0.05,
      ),

      suffixIcon: suffix,

      filled: true,
      fillColor: cardColor,

      contentPadding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          width * 0.04,
        ),
        borderSide: const BorderSide(
          color: borderColor,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          width * 0.04,
        ),
        borderSide: const BorderSide(
          color: borderColor,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(
          width * 0.04,
        ),
        borderSide: const BorderSide(
          color: primaryColor,
          width: 1.5,
        ),
      ),
    );
  }
}