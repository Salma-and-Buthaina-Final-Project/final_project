import 'package:final_project/constants/colors.dart';
import 'package:final_project/utils/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;

  Future<void> updatePassword() async {
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("عبّي جميع الحقول")));
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("كلمتا المرور غير متطابقتين")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await Supabase.instance.client.auth.updateUser(
        UserAttributes(password: password),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("تم تغيير كلمة المرور بنجاح")),
      );

      Navigator.popUntil(context, (route) => route.isFirst);
    } on AuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message)));
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
    passwordController.dispose();
    confirmPasswordController.dispose();
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
                  SizedBox(height: height * 0.07),

                  Image.asset(
                    "assets/logo.png",
                    width: width * 0.28,
                    height: height * 0.13,
                  ),

                  SizedBox(height: height * 0.02),

                  Text(
                    "تعيين كلمة مرور جديدة",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: width * 0.065,
                      fontWeight: FontWeight.bold,
                      color: mainTextColor,
                    ),
                  ),

                  SizedBox(height: height * 0.04),

                  TextField(
                    controller: passwordController,
                    obscureText: obscurePassword,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: "كلمة المرور الجديدة",
                      filled: true,
                      fillColor: cardColor,
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: primaryColor,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(width * 0.04),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.02),

                  TextField(
                    controller: confirmPasswordController,
                    obscureText: obscureConfirmPassword,
                    textAlign: TextAlign.right,
                    decoration: InputDecoration(
                      hintText: "تأكيد كلمة المرور",
                      filled: true,
                      fillColor: cardColor,
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: primaryColor,
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            obscureConfirmPassword = !obscureConfirmPassword;
                          });
                        },
                        icon: Icon(
                          obscureConfirmPassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(width * 0.04),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.03),

                  SizedBox(
                    width: width,
                    height: height * 0.065,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : updatePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: whiteColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(width * 0.04),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: whiteColor)
                          : Text(
                              "حفظ كلمة المرور",
                              style: TextStyle(
                                fontSize: width * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
}
