import 'package:final_project/constants/colors.dart';
import 'package:final_project/screens/home_screen.dart';
import 'package:final_project/screens/signup_screen.dart';
import 'package:final_project/services/database.dart';
import 'package:final_project/utils/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:final_project/screens/forgot_password_screen.dart';
import 'package:final_project/constants/fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = screenWidth(context);
    final height = screenHeight(context);

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(fontFamily: thmanyahFont),
        inputDecorationTheme: Theme.of(context).inputDecorationTheme
            .copyWith(hintStyle: const TextStyle(fontFamily: thmanyahFont)),
      ),
      child: Scaffold(
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
                padding: EdgeInsets.symmetric(horizontal: width * 0.07),
                child: Column(
                  children: [
                    SizedBox(height: height * 0.045),

                    // الشعار
                    Image.asset(
                      "assets/logo.png",
                      width: width * 0.28,
                      height: height * 0.13,
                      fit: BoxFit.contain,
                    ),

                    SizedBox(height: height * 0.015),

                    // العنوان
                    Text(
                      "تسجيل الدخول",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: width * 0.07,
                        fontWeight: FontWeight.bold,
                        color: mainTextColor,
                      ),
                    ),

                    SizedBox(height: height * 0.006),

                    Text(
                      "مرحباً بك في حالتي",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: width * 0.035,
                        color: secondaryTextColor,
                      ),
                    ),

                    SizedBox(height: height * 0.035),

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

                    SizedBox(height: height * 0.002),

                    // نسيت كلمة المرور
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ForgotPasswordScreen(),
                            ),
                          );
                        },
                        child: Text(
                          "نسيت كلمة المرور؟",
                          style: TextStyle(
                            color: whiteColor,
                            fontSize: width * 0.032,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.008),

                    // زر تسجيل الدخول
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
                            borderRadius: BorderRadius.circular(width * 0.04),
                          ),
                        ),
                        onPressed: () async {
                          try {
                            await Database().loginUser(
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                            );

                            if (!mounted) return;

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          } catch (e) {
                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  e.toString(),
                                  style: const TextStyle(
                                    fontFamily: thmanyahFont,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        child: Center(
                          child: Text(
                            "تسجيل الدخول",
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

                    // ليس لديك حساب؟ إنشاء حساب
                    Container(
                      width: width,
                      height: height * 0.065,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(width * 0.04),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        textDirection: TextDirection.rtl,
                        children: [
                          Text(
                            "ليس لديك حساب؟",
                            style: TextStyle(
                              fontSize: width * 0.032,
                              color: inputTextColor,
                            ),
                          ),

                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignupScreen(),
                                ),
                              );
                            },
                            child: Text(
                              "إنشاء حساب",
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
        fontFamily: thmanyahFont,
      ),

      prefixIcon: Icon(icon, color: primaryColor, size: width * 0.05),

      suffixIcon: suffix,

      filled: true,
      fillColor: cardColor,

      contentPadding: EdgeInsets.symmetric(horizontal: width * 0.04),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(width * 0.04),
        borderSide: const BorderSide(color: borderColor),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(width * 0.04),
        borderSide: const BorderSide(color: borderColor),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(width * 0.04),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
    );
  }
}
