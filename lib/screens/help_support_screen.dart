import 'package:flutter/material.dart';

import 'package:final_project/constants/colors.dart';
import 'package:final_project/constants/fonts.dart';
import 'package:final_project/utils/screen_size.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

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
              'المساعدة والدعم',
              style: TextStyle(
                fontFamily: thmanyahFont,
                fontSize: width * 0.065,
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
                  // HEADER CARD
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
                            color: homePurpleColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.help_outline_rounded,
                            color: homeDarkTextColor,
                            size: width * 0.09,
                          ),
                        ),

                        SizedBox(height: height * 0.015),

                        Text(
                          'كيف يمكننا مساعدتك؟',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: thmanyahFont,
                            fontSize: width * 0.052,
                            fontWeight: FontWeight.w700,
                            color: homeDarkTextColor,
                          ),
                        ),

                        SizedBox(height: height * 0.005),

                        Text(
                          'ستجد هنا إجابات عن أكثر الأسئلة شيوعًا حول تطبيق حالتي.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: thmanyahFont,
                            fontSize: width * 0.035,
                            fontWeight: FontWeight.w400,
                            color: homeGreyColor,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: height * 0.03),

                  // =================================================
                  // FAQ TITLE
                  // =================================================
                  Text(
                    'الأسئلة الشائعة',
                    style: TextStyle(
                      fontFamily: thmanyahFont,
                      fontSize: width * 0.052,
                      fontWeight: FontWeight.w700,
                      color: whiteColor,
                    ),
                  ),

                  SizedBox(height: height * 0.015),

                  // =================================================
                  // QUESTION 1
                  // =================================================
                  _questionCard(
                    width: width,
                    question: 'كيف أسجل عرضًا جديدًا؟',
                    answer:
                        'من الشريط السفلي، اضغط على زر الإضافة (+)، ثم أدخل بيانات العرض واضغط على حفظ العرض.',
                    color: homeLightBlueColor,
                  ),

                  SizedBox(height: height * 0.012),

                  // =================================================
                  // QUESTION 2
                  // =================================================
                  _questionCard(
                    width: width,
                    question: 'كيف أعرض الأعراض السابقة؟',
                    answer:
                        'من الشريط السفلي، اختر السجل، وستظهر لك الأعراض المسجلة سابقًا.',
                    color: homeGreenColor,
                  ),

                  SizedBox(height: height * 0.012),

                  // =================================================
                  // QUESTION 3
                  // =================================================
                  _questionCard(
                    width: width,
                    question: 'كيف أضيف موعد مراجعة؟',
                    answer:
                        'من صفحة حسابي، اختر موعد المراجعة، ثم حدد التاريخ وأدخل بيانات الموعد واضغط على حفظ الموعد.',
                    color: homeYellowColor,
                  ),

                  SizedBox(height: height * 0.012),

                  // =================================================
                  // QUESTION 4
                  // =================================================
                  _questionCard(
                    width: width,
                    question: 'كيف أعدل اسمي؟',
                    answer:
                        'من صفحة حسابي، اختر معلوماتي الشخصية، ثم عدل الاسم واضغط على حفظ التعديلات.',
                    color: homePinkColor,
                  ),

                  SizedBox(height: height * 0.03),

                  // =================================================
                  // SUPPORT TITLE
                  // =================================================
                  Text(
                    'هل تحتاج إلى مساعدة إضافية؟',
                    style: TextStyle(
                      fontFamily: thmanyahFont,
                      fontSize: width * 0.052,
                      fontWeight: FontWeight.w700,
                      color: whiteColor,
                    ),
                  ),

                  SizedBox(height: height * 0.015),

                  // =================================================
                  // REPORT PROBLEM
                  // =================================================
                  _supportCard(
                    width: width,
                    height: height,
                    icon: Icons.report_problem_outlined,
                    title: 'الإبلاغ عن مشكلة',
                    subtitle: 'هل واجهت مشكلة أثناء استخدام التطبيق؟',
                    color: homePinkColor,
                    onTap: () {
                      _showReportDialog(context);
                    },
                  ),

                  SizedBox(height: height * 0.012),

                  // =================================================
                  // ABOUT APP
                  // =================================================
                  _supportCard(
                    width: width,
                    height: height,
                    icon: Icons.info_outline_rounded,
                    title: 'عن تطبيق حالتي',
                    subtitle: 'معلومات عن التطبيق',
                    color: homeLightBlueColor,
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'حالتي',
                        applicationVersion: '1.0.0',
                        children: [
                          Text(
                            'تطبيق يساعد المستخدم على تسجيل الأعراض ومتابعتها وتنظيم مواعيد المراجعة.',
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontFamily: thmanyahFont,
                            ),
                          ),
                        ],
                      );
                    },
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
  // QUESTION CARD
  // =========================================================
  Widget _questionCard({
    required double width,
    required String question,
    required String answer,
    required Color color,
  }) {
    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(width * 0.04),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(width * 0.04),
          border: Border.all(color: homeBorderColor),
        ),
        child: ExpansionTile(
          backgroundColor: cardColor,
          collapsedBackgroundColor: cardColor,

          shape: const Border(),
          collapsedShape: const Border(),

          leading: Container(
            width: width * 0.1,
            height: width * 0.1,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.question_mark_rounded,
              color: homeDarkTextColor,
              size: width * 0.05,
            ),
          ),

          title: Text(
            question,
            style: TextStyle(
              fontFamily: thmanyahFont,
              fontSize: width * 0.039,
              fontWeight: FontWeight.w600,
              color: homeDarkTextColor,
            ),
          ),

          iconColor: homeDarkTextColor,
          collapsedIconColor: homeGreyColor,

          children: [
            Padding(
              padding: EdgeInsets.only(
                right: width * 0.05,
                left: width * 0.05,
                bottom: width * 0.04,
              ),
              child: Text(
                answer,
                style: TextStyle(
                  fontFamily: thmanyahFont,
                  fontSize: width * 0.035,
                  fontWeight: FontWeight.w400,
                  color: homeGreyColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================================================
  // SUPPORT CARD
  // =========================================================
  Widget _supportCard({
    required double width,
    required double height,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(width * 0.04),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: width * 0.04,
            vertical: height * 0.015,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(width * 0.04),
            border: Border.all(color: homeBorderColor),
          ),
          child: Row(
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
                        fontSize: width * 0.04,
                        fontWeight: FontWeight.w700,
                        color: homeDarkTextColor,
                      ),
                    ),

                    Text(
                      subtitle,
                      style: TextStyle(
                        fontFamily: thmanyahFont,
                        fontSize: width * 0.032,
                        color: homeGreyColor,
                      ),
                    ),
                  ],
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
  // REPORT DIALOG
  // =========================================================
  void _showReportDialog(BuildContext context) {
    final TextEditingController problemController =
        TextEditingController();

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: cardColor,

            title: Text(
              'الإبلاغ عن مشكلة',
              style: TextStyle(
                fontFamily: thmanyahFont,
                fontWeight: FontWeight.w700,
                color: homeDarkTextColor,
              ),
            ),

            content: TextField(
              controller: problemController,
              maxLines: 4,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: thmanyahFont,
                color: homeDarkTextColor,
              ),
              decoration: InputDecoration(
                hintText: 'اكتب المشكلة هنا...',
                hintStyle: TextStyle(
                  fontFamily: thmanyahFont,
                  color: homeGreyColor,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
            ),

            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: Text(
                  'إلغاء',
                  style: TextStyle(
                    fontFamily: thmanyahFont,
                    color: homeDarkTextColor,
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'تم إرسال البلاغ بنجاح.',
                        style: TextStyle(
                          fontFamily: thmanyahFont,
                        ),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: homePrimaryColor,
                ),
                child: Text(
                  'إرسال',
                  style: TextStyle(
                    fontFamily: thmanyahFont,
                    color: whiteColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    ).then((_) {
      problemController.dispose();
    });
  }
}