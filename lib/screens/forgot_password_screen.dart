import 'package:final_project/constants/colors.dart';
import 'package:final_project/utils/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();

  bool isLoading = false;

  Future<void> resetPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("اكتبي البريد الإلكتروني")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await Supabase.instance.client.auth.resetPasswordForEmail(
        email,
        redirectTo: 'halati://reset-password',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك"),
        ),
      );
    } on AuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("حدث خطأ أثناء إرسال الرابط")),
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
  void dispose() {
    emailController.dispose();
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
              padding: EdgeInsets.symmetric(horizontal: width * 0.07),
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

                  SizedBox(height: height * 0.03),

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
                    "نسيت كلمة المرور؟",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width * 0.07,
                      fontWeight: FontWeight.bold,
                      color: mainTextColor,
                    ),
                  ),

                  SizedBox(height: height * 0.01),

                  Text(
                    "أدخلي بريدك الإلكتروني وسنرسل لك رابطًا لإعادة تعيين كلمة المرور",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width * 0.035,
                      color: secondaryTextColor,
                    ),
                  ),

                  SizedBox(height: height * 0.04),

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

                  SizedBox(height: height * 0.025),

                  // زر إرسال الرابط
                  SizedBox(
                    width: width,
                    height: height * 0.065,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : resetPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: whiteColor,
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(width * 0.04),
                        ),
                      ),
                      child: isLoading
                          ? SizedBox(
                              width: width * 0.055,
                              height: width * 0.055,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: whiteColor,
                              ),
                            )
                          : Text(
                              "إرسال الرابط",
                              style: TextStyle(
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),

                  SizedBox(height: height * 0.02),

                  // الرجوع لتسجيل الدخول
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
                          "تذكرت كلمة المرور؟",
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
  }) {
    final width = screenWidth(context);

    return InputDecoration(
      hintText: hint,

      hintStyle: TextStyle(color: hintTextColor, fontSize: width * 0.034),

      prefixIcon: Icon(icon, color: primaryColor, size: width * 0.05),

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
