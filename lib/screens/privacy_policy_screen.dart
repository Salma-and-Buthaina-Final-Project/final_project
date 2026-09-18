import 'package:flutter/material.dart';

import 'package:final_project/constants/colors.dart';
import 'package:final_project/constants/fonts.dart';
import 'package:final_project/utils/screen_size.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final width = screenWidth(context);
    final height = screenHeight(context);

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(
          context,
        ).textTheme.apply(fontFamily: thmanyahFont),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: backgroundColor,

          // =====================================================
          // APP BAR
          // =====================================================
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            centerTitle: true,
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: whiteColor,
                size: width * 0.05,
              ),
            ),
            title: Text(
              'سياسة الخصوصية',
              style: TextStyle(
                fontFamily: thmanyahFont,
                fontSize: width * 0.06,
                fontWeight: FontWeight.w700,
                color: whiteColor,
              ),
            ),
          ),

          // =====================================================
          // BODY
          // =====================================================
          body: SafeArea(
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
                  Container(
                    padding: EdgeInsets.all(width * 0.05),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(
                        width * 0.045,
                      ),
                      border: Border.all(
                        color: homeBorderColor,
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: width * 0.18,
                          height: width * 0.18,
                          decoration: const BoxDecoration(
                            color: homePinkColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.privacy_tip_outlined,
                            color: homeDarkTextColor,
                            size: width * 0.085,
                          ),
                        ),

                        SizedBox(height: height * 0.015),

                        Text(
                          'خصوصيتك تهمنا',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: thmanyahFont,
                            fontSize: width * 0.052,
                            fontWeight: FontWeight.w700,
                            color: homeDarkTextColor,
                          ),
                        ),

                        SizedBox(height: height * 0.006),

                        Text(
                          'توضح هذه الصفحة كيفية التعامل مع بياناتك داخل تطبيق حالتي.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: thmanyahFont,
                            fontSize: width * 0.035,
                            color: homeGreyColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: height * 0.025),

                  // =================================================
                  // PRIVACY SECTIONS
                  // =================================================
                  _privacyCard(
                    width: width,
                    icon: Icons.person_outline_rounded,
                    color: homeLightBlueColor,
                    title: 'البيانات التي نجمعها',
                    text:
                        'قد يتعامل التطبيق مع المعلومات التي تدخلها أثناء استخدامه، مثل بيانات الحساب والأعراض والمواعيد والملاحظات التي تضيفها.',
                  ),

                  SizedBox(height: height * 0.015),

                  _privacyCard(
                    width: width,
                    icon: Icons.storage_outlined,
                    color: homePurpleColor,
                    title: 'حفظ البيانات',
                    text:
                        'تُحفظ بيانات الحساب والبيانات المرتبطة باستخدام التطبيق في قاعدة البيانات المستخدمة بواسطة التطبيق، وذلك لتوفير وظائف الحساب واسترجاع معلوماتك عند تسجيل الدخول.',
                  ),

                  SizedBox(height: height * 0.015),

                  _privacyCard(
                    width: width,
                    icon: Icons.medical_information_outlined,
                    color: homeGreenColor,
                    title: 'البيانات الصحية',
                    text:
                        'يتيح لك التطبيق تسجيل معلومات مرتبطة بالأعراض والمراجعات الصحية. تُستخدم هذه المعلومات لعرض سجلك وملخصاتك داخل التطبيق.',
                  ),

                  SizedBox(height: height * 0.015),

                  _privacyCard(
                    width: width,
                    icon: Icons.lock_outline_rounded,
                    color: homeYellowColor,
                    title: 'حماية البيانات',
                    text:
                        'نسعى إلى التعامل مع البيانات بطريقة آمنة، وينبغي المحافظة على سرية بيانات تسجيل الدخول وعدم مشاركتها مع الآخرين.',
                  ),

                  SizedBox(height: height * 0.015),

                  _privacyCard(
                    width: width,
                    icon: Icons.share_outlined,
                    color: homePinkColor,
                    title: 'مشاركة البيانات',
                    text:
                        'لا يهدف تطبيق حالتي إلى بيع بيانات المستخدم الشخصية. وقد تعتمد بعض وظائف التطبيق على خدمات تقنية خارجية لازمة لتشغيله.',
                  ),

                  SizedBox(height: height * 0.015),

                  _privacyCard(
                    width: width,
                    icon: Icons.manage_accounts_outlined,
                    color: homeLightBlueColor,
                    title: 'بيانات حسابك',
                    text:
                        'يمكنك الاطلاع على بعض معلومات حسابك وتعديل البيانات المتاحة للتعديل من خلال صفحة معلوماتي الشخصية داخل التطبيق.',
                  ),

                  SizedBox(height: height * 0.015),

                  _privacyCard(
                    width: width,
                    icon: Icons.info_outline_rounded,
                    color: homePurpleColor,
                    title: 'تنبيه',
                    text:
                        'تطبيق حالتي مخصص للمساعدة في تسجيل الأعراض وتنظيم المعلومات، ولا يُعد بديلاً عن التشخيص أو الاستشارة الطبية المتخصصة.',
                  ),

                  SizedBox(height: height * 0.03),

                  Center(
                    child: Text(
                      'آخر تحديث: سبتمبر 2026',
                      style: TextStyle(
                        fontFamily: thmanyahFont,
                        fontSize: width * 0.032,
                        color: secondaryTextColor,
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.03),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // PRIVACY CARD
  // =========================================================
  Widget _privacyCard({
    required double width,
    required IconData icon,
    required Color color,
    required String title,
    required String text,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(width * 0.04),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(width * 0.04),
        border: Border.all(color: homeBorderColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: width * 0.11,
            height: width * 0.11,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: homeDarkTextColor,
              size: width * 0.055,
            ),
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
                    fontSize: width * 0.041,
                    fontWeight: FontWeight.w700,
                    color: homeDarkTextColor,
                  ),
                ),

                SizedBox(height: width * 0.012),

                Text(
                  text,
                  style: TextStyle(
                    fontFamily: thmanyahFont,
                    fontSize: width * 0.034,
                    fontWeight: FontWeight.w400,
                    color: homeGreyColor,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}