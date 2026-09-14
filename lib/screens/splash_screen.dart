import 'package:final_project/constants/colors.dart';
import 'package:final_project/constants/fonts.dart';
import 'package:final_project/screens/signup_screen.dart';
import 'package:final_project/utils/screen_size.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
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
          // Background
          Positioned.fill(
            child: Image.asset(
              'assets/background.png',
              width: width,
              height: height,
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.07,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: height * 0.06,
                            ),

                            // Animated Logo
                            ScaleTransition(
                              scale: _scaleAnimation,
                              child: Image.asset(
                                'assets/logo.png',
                                width: width * 0.55,
                                fit: BoxFit.contain,
                              ),
                            ),

                            SizedBox(
                              height: height * 0.005,
                            ),

                            // App Name
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'حالتي',
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: width * 0.15,
                                  fontWeight: FontWeight.w900,
                                  fontFamily: thmanyahFont,
                                  color: mainTextColor,
                                ),
                              ),
                            ),

                            SizedBox(
                              height: height * 0.03,
                            ),

                            // Subtitle
                            Text(
                              'صحتك أقرب إليك',
                              textAlign: TextAlign.center,
                              textDirection: TextDirection.rtl,
                              style: TextStyle(
                                fontSize: width * 0.045,
                                fontWeight: FontWeight.w400,
                                fontFamily: thmanyahFont,
                                color: secondaryTextColor,
                              ),
                            ),

                            SizedBox(
                              height: height * 0.05,
                            ),

                            // Hadith
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.02,
                              ),
                              child: Text(
                                '«تَدَاوَوْا، فَإِنَّ اللَّهَ عَزَّ وَجَلَّ '
                                'لَمْ يَضَعْ دَاءً إِلَّا وَضَعَ لَهُ دَوَاءً»',
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  fontSize: width * 0.045,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: thmanyahFont,
                                  height: 1.8,
                                  color: secondaryTextColor,
                                ),
                              ),
                            ),

                            SizedBox(
                              height: height * 0.05,
                            ),

                            // Start Button
                            SizedBox(
                              width: double.infinity,
                              height: height * 0.065,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: primaryColor,
                                  foregroundColor: whiteColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                      width * 0.04,
                                    ),
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SignupScreen(),
                                    ),
                                  );
                                },
                                child: Text(
                                  'ابدأ الآن',
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontSize: width * 0.04,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: thmanyahFont,
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: height * 0.05,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}