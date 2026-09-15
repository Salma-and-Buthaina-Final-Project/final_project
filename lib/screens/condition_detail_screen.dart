import 'package:flutter/material.dart';
import 'package:final_project/constants/colors.dart';
import 'package:final_project/constants/fonts.dart';
import 'package:final_project/utils/screen_size.dart';

class ConditionDetailsScreen extends StatelessWidget {
  final String title;
  final String date;
  final String severity;
  final Color color;

  const ConditionDetailsScreen({
    super.key,
    required this.title,
    required this.date,
    required this.severity,
    required this.color,
  });

  // =========================================================
  // بيانات كل عرض
  // =========================================================

  Map<String, String> get details {
    switch (title) {
      case 'صداع':
        return {
          'location': 'الجانب الأيسر من الرأس',
          'duration': 'من 10:30 ص إلى 02:00 م',
          'repeated': '4 مرات',
          'medicineUsed': 'نعم',
          'medicine': 'باراسيتامول',
          'notes': 'يزداد الألم عند التعرض للضوء',
        };

      case 'ألم في المعدة':
        return {
          'location': 'البطن',
          'duration': 'من 08:00 ص إلى 11:00 ص',
          'repeated': '3 مرات',
          'medicineUsed': 'نعم',
          'medicine': 'دواء للمعدة',
          'notes': 'يزداد الألم بعد تناول الطعام',
        };

      case 'غثيان':
        return {
          'location': 'البطن',
          'duration': 'من 01:00 م إلى 03:00 م',
          'repeated': 'مرتين',
          'medicineUsed': 'لا',
          'medicine': 'لم يتم استخدام دواء',
          'notes': 'غثيان خفيف ومتقطع',
        };

      case 'ألم في الظهر':
        return {
          'location': 'أسفل الظهر',
          'duration': 'من 04:00 م إلى 07:00 م',
          'repeated': '3 مرات',
          'medicineUsed': 'نعم',
          'medicine': 'مسكن للألم',
          'notes': 'يزداد الألم مع الجلوس لفترة طويلة',
        };

      case 'ضيق تنفس':
        return {
          'location': 'الصدر',
          'duration': 'من 06:00 م إلى 06:30 م',
          'repeated': 'مرة واحدة',
          'medicineUsed': 'لا',
          'medicine': 'لم يتم استخدام دواء',
          'notes': 'حدث بعد مجهود بدني',
        };

      default:
        return {
          'location': 'غير محدد',
          'duration': 'غير محدد',
          'repeated': 'غير محدد',
          'medicineUsed': 'لا',
          'medicine': 'لا يوجد',
          'notes': 'لا توجد ملاحظات',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = screenWidth(context);
    final height = screenHeight(context);
    final data = details;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundColor,

        // =====================================================
        // APP BAR
        // نفس AddConditionScreen
        // =====================================================
        appBar: AppBar(
          backgroundColor: backgroundColor,
          elevation: 0,
          centerTitle: true,

          // زر الرجوع
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

          // عنوان الصفحة
          title: Text(
            'تفاصيل العرض',
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
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.055,
              vertical: height * 0.02,
            ),
            child: Column(
              children: [
                // =================================================
                // TOP SYMPTOM CARD
                // =================================================
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.045,
                    vertical: height * 0.025,
                  ),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(
                      width * 0.05,
                    ),
                  ),
                  child: Row(
                    children: [
                      // ================= ICON =================
                      Container(
                        width: width * 0.17,
                        height: width * 0.17,
                        decoration: BoxDecoration(
                          color: cardColor.withOpacity(0.55),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getSymptomIcon(),
                          color: homeDarkTextColor,
                          size: width * 0.09,
                        ),
                      ),

                      SizedBox(width: width * 0.04),

                      // ================= NAME + DATE =================
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontFamily: thmanyahFont,
                                fontSize: width * 0.06,
                                fontWeight: FontWeight.w700,
                                color: homeDarkTextColor,
                              ),
                            ),

                            SizedBox(height: height * 0.005),

                            Text(
                              date,
                              style: TextStyle(
                                fontFamily: thmanyahFont,
                                fontSize: width * 0.038,
                                fontWeight: FontWeight.w500,
                                color: homeDarkTextColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ================= SEVERITY =================
                      Column(
                        children: [
                          Container(
                            width: width * 0.14,
                            height: width * 0.14,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: cardColor.withOpacity(0.60),
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              severity,
                              style: TextStyle(
                                fontFamily: thmanyahFont,
                                fontSize: width * 0.065,
                                fontWeight: FontWeight.w700,
                                color: homeDarkTextColor,
                              ),
                            ),
                          ),

                          SizedBox(height: height * 0.006),

                          Text(
                            'شدة العرض',
                            style: TextStyle(
                              fontFamily: thmanyahFont,
                              fontSize: width * 0.032,
                              fontWeight: FontWeight.w600,
                              color: homeDarkTextColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.025),

                // =================================================
                // DETAILS CARD
                // =================================================
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04,
                  ),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(
                      width * 0.05,
                    ),
                    border: Border.all(
                      color: homeBorderColor,
                    ),
                  ),
                  child: Column(
                    children: [
                      // مكان الألم
                      _detailRow(
                        width: width,
                        height: height,
                        icon: Icons.location_on_outlined,
                        title: 'مكان الألم',
                        value: data['location']!,
                      ),

                      _divider(width),

                      // مدة العرض
                      _detailRow(
                        width: width,
                        height: height,
                        icon: Icons.access_time_rounded,
                        title: 'مدة العرض',
                        value: data['duration']!,
                      ),

                      _divider(width),

                      // عدد مرات التكرار
                      _detailRow(
                        width: width,
                        height: height,
                        icon: Icons.refresh_rounded,
                        title: 'عدد مرات التكرار',
                        value: data['repeated']!,
                      ),

                      _divider(width),

                      // استخدام دواء
                      _detailRow(
                        width: width,
                        height: height,
                        icon: Icons.medication_outlined,
                        title: 'استخدام دواء',
                        value: data['medicineUsed']!,
                      ),

                      _divider(width),

                      // الدواء
                      _detailRow(
                        width: width,
                        height: height,
                        icon: Icons.medical_services_outlined,
                        title: 'الدواء',
                        value: data['medicine']!,
                      ),

                      _divider(width),

                      // الملاحظات
                      _detailRow(
                        width: width,
                        height: height,
                        icon: Icons.edit_note_rounded,
                        title: 'ملاحظات',
                        value: data['notes']!,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.03),

                // =================================================
                // BUTTONS
                // =================================================
                Row(
                  children: [
                    // ================= EDIT =================
                    Expanded(
                      child: SizedBox(
                        height: height * 0.065,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // نربط التعديل لاحقاً
                          },
                          icon: Icon(
                            Icons.edit_outlined,
                            color: whiteColor,
                            size: width * 0.055,
                          ),
                          label: Text(
                            'تعديل',
                            style: TextStyle(
                              fontFamily: thmanyahFont,
                              fontSize: width * 0.043,
                              fontWeight: FontWeight.w700,
                              color: whiteColor,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            backgroundColor: homePrimaryColor,
                            foregroundColor: whiteColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                width * 0.04,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: width * 0.03),

                    // ================= DELETE =================
                    Expanded(
                      child: SizedBox(
                        height: height * 0.065,
                        child: OutlinedButton.icon(
                          onPressed: () {
                            _showDeleteDialog(context);
                          },
                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.redAccent,
                            size: width * 0.055,
                          ),
                          label: Text(
                            'حذف',
                            style: TextStyle(
                              fontFamily: thmanyahFont,
                              fontSize: width * 0.043,
                              fontWeight: FontWeight.w700,
                              color: Colors.redAccent,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Colors.redAccent,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                width * 0.04,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: height * 0.03),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // DETAIL ROW
  // =========================================================

  Widget _detailRow({
    required double width,
    required double height,
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: height * 0.018,
      ),
      child: Row(
        children: [
          // Icon
          Icon(
            icon,
            color: homeDarkTextColor,
            size: width * 0.055,
          ),

          SizedBox(width: width * 0.025),

          // Title
          SizedBox(
            width: width * 0.27,
            child: Text(
              title,
              style: TextStyle(
                fontFamily: thmanyahFont,
                fontSize: width * 0.038,
                fontWeight: FontWeight.w700,
                color: homeDarkTextColor,
              ),
            ),
          ),

          SizedBox(width: width * 0.02),

          // Value
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: thmanyahFont,
                fontSize: width * 0.037,
                fontWeight: FontWeight.w500,
                color: homeDarkTextColor,
              ),
            ),
          ),
        ],
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
      indent: width * 0.02,
      endIndent: width * 0.02,
    );
  }

  // =========================================================
  // SYMPTOM ICON
  // =========================================================

  IconData _getSymptomIcon() {
    switch (title) {
      case 'صداع':
        return Icons.psychology_alt_outlined;

      case 'ألم في المعدة':
        return Icons.sick_outlined;

      case 'غثيان':
        return Icons.sentiment_dissatisfied_outlined;

      case 'ألم في الظهر':
        return Icons.accessibility_new_rounded;

      case 'ضيق تنفس':
        return Icons.air_rounded;

      default:
        return Icons.health_and_safety_outlined;
    }
  }

  // =========================================================
  // DELETE DIALOG
  // =========================================================

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),

            title: Text(
              'حذف العرض',
              style: TextStyle(
                fontFamily: thmanyahFont,
                color: homeDarkTextColor,
                fontWeight: FontWeight.w700,
              ),
            ),

            content: Text(
              'هل أنتِ متأكدة من حذف هذا العرض؟',
              style: TextStyle(
                fontFamily: thmanyahFont,
                color: homeDarkTextColor,
              ),
            ),

            actions: [
              // إلغاء
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'إلغاء',
                  style: TextStyle(
                    fontFamily: thmanyahFont,
                    color: homeDarkTextColor,
                  ),
                ),
              ),

              // حذف
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text(
                  'حذف',
                  style: TextStyle(
                    fontFamily: thmanyahFont,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}