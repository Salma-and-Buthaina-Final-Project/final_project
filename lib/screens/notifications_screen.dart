import 'package:flutter/material.dart';
import 'package:final_project/constants/colors.dart';
import 'package:final_project/constants/fonts.dart';
import 'package:final_project/screens/add_condition_screen.dart';
import 'package:final_project/utils/screen_size.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  Widget build(BuildContext context) {
    final width = screenWidth(context);
    final height = screenHeight(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundColor,

        appBar: AppBar(
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,

          title: Text(
            'الإشعارات',
            style: TextStyle(
              fontFamily: thmanyahFont,
              fontSize: width * 0.055,
              fontWeight: FontWeight.w700,
              color: whiteColor,
            ),
          ),

          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: whiteColor,
            ),
          ),
        ),

        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.05,
              vertical: height * 0.025,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'اليوم',
                  style: TextStyle(
                    fontFamily: thmanyahFont,
                    fontSize: width * 0.045,
                    fontWeight: FontWeight.w700,
                    color: whiteColor,
                  ),
                ),

                SizedBox(height: height * 0.015),

                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(width * 0.045),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AddConditionScreen(),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(width * 0.045),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(width * 0.045),
                        border: Border.all(color: homeBorderColor),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: width * 0.14,
                                height: width * 0.14,
                                decoration: const BoxDecoration(
                                  color: homeLightBlueColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.favorite_rounded,
                                  color: homePrimaryColor,
                                  size: width * 0.07,
                                ),
                              ),
                            ],
                          ),

                          SizedBox(width: width * 0.035),

                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'كيف حالتك اليوم؟',
                                  style: TextStyle(
                                    fontFamily: thmanyahFont,
                                    fontSize: width * 0.043,
                                    fontWeight: FontWeight.w700,
                                    color: homeDarkTextColor,
                                  ),
                                ),

                                SizedBox(height: height * 0.006),

                                Text(
                                  'خذ لحظة لتسجيل حالتك الصحية وأعراضك اليوم.',
                                  style: TextStyle(
                                    fontFamily: thmanyahFont,
                                    fontSize: width * 0.034,
                                    height: 1.5,
                                    color: homeSecondaryTextColor,
                                  ),
                                ),

                                SizedBox(height: height * 0.01),

                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_time_rounded,
                                      size: width * 0.037,
                                      color: homeGreyColor,
                                    ),
                                    SizedBox(width: width * 0.012),
                                    Text(
                                      '8:00 مساءً',
                                      style: TextStyle(
                                        fontFamily: thmanyahFont,
                                        fontSize: width * 0.03,
                                        color: homeGreyColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: width * 0.035,
                            color: homeGreyColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
