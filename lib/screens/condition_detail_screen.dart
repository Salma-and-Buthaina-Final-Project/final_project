import 'package:flutter/material.dart';

import 'package:final_project/constants/colors.dart';
import 'package:final_project/constants/fonts.dart';
import 'package:final_project/utils/screen_size.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ConditionDetailsScreen extends StatelessWidget {
  final String title;
  final String date;
  final String severity;
  final Color color;

  // البيانات القادمة من Supabase
  final String location;
  final bool isRepeated;
  final String? medicineName;
  final String? notes;
  final String symptomId;

  const ConditionDetailsScreen({
    super.key,
    required this.symptomId,
    required this.title,
    required this.date,
    required this.severity,
    required this.color,
    required this.location,
    required this.isRepeated,
    this.medicineName,
    this.notes,
  });

  // =========================================================
  // هل يوجد دواء فعلاً؟
  // =========================================================

  bool get usedMedicine {
    return medicineName != null && medicineName!.trim().isNotEmpty;
  }

  // =========================================================
  // نص التكرار
  // =========================================================

  String get repeatedText {
    return isRepeated ? 'نعم' : 'لا';
  }

  // =========================================================
  // نص استخدام الدواء
  // =========================================================

  String get medicineUsedText {
    return usedMedicine ? 'نعم' : 'لا';
  }

  // =========================================================
  // اسم الدواء
  // =========================================================

  String get medicineText {
    if (!usedMedicine) {
      return 'لم يتم استخدام دواء';
    }

    return medicineName!.trim();
  }

  // =========================================================
  // الملاحظات
  // =========================================================

  String get notesText {
    if (notes == null || notes!.trim().isEmpty) {
      return 'لا توجد ملاحظات';
    }

    return notes!.trim();
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final width = screenWidth(context);
    final height = screenHeight(context);

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(fontFamily: thmanyahFont),
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
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.055,
              vertical: height * 0.018,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // =================================================
                // MAIN SYMPTOM CARD
                // =================================================

                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.045,
                    vertical: height * 0.025,
                  ),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(width * 0.05),
                    border: Border.all(color: homeBorderColor),
                  ),
                  child: Row(
                    children: [
                      // =============================================
                      // ICON
                      // =============================================

                      Container(
                        width: width * 0.17,
                        height: width * 0.17,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getSymptomIcon(),
                          color: homeDarkTextColor,
                          size: width * 0.085,
                        ),
                      ),

                      SizedBox(width: width * 0.04),

                      // =============================================
                      // TITLE + DATE
                      // =============================================
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontFamily: thmanyahFont,
                                fontSize: width * 0.058,
                                fontWeight: FontWeight.w700,
                                color: homeDarkTextColor,
                              ),
                            ),

                            SizedBox(height: height * 0.005),

                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today_outlined,
                                  color: homeDarkTextColor,
                                  size: width * 0.04,
                                ),

                                SizedBox(width: width * 0.015),

                                Expanded(
                                  child: Text(
                                    date,
                                    style: TextStyle(
                                      fontFamily: thmanyahFont,
                                      fontSize: width * 0.036,
                                      fontWeight: FontWeight.w500,
                                      color: homeDarkTextColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // =============================================
                      // SEVERITY
                      // =============================================
                      Column(
                        children: [
                          Text(
                            'الشدة',
                            style: TextStyle(
                              fontFamily: thmanyahFont,
                              fontSize: width * 0.034,
                              fontWeight: FontWeight.w500,
                              color: homeGreyColor,
                            ),
                          ),

                          SizedBox(height: height * 0.005),

                          Container(
                            width: width * 0.13,
                            height: width * 0.13,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(
                                width * 0.035,
                              ),
                            ),
                            child: Text(
                              severity,
                              style: TextStyle(
                                fontFamily: thmanyahFont,
                                fontSize: width * 0.055,
                                fontWeight: FontWeight.w700,
                                color: homeDarkTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.025),

                // =================================================
                // DETAILS TITLE
                // =================================================
                Text(
                  'تفاصيل الحالة',
                  style: TextStyle(
                    fontFamily: thmanyahFont,
                    fontSize: width * 0.052,
                    fontWeight: FontWeight.w700,
                    color: whiteColor,
                  ),
                ),

                SizedBox(height: height * 0.012),

                // =================================================
                // DETAILS CARD
                // =================================================
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04,
                    vertical: height * 0.01,
                  ),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(width * 0.05),
                    border: Border.all(color: homeBorderColor),
                  ),
                  child: Column(
                    children: [
                      // =============================================
                      // LOCATION
                      // =============================================

                      _detailRow(
                        width: width,
                        height: height,
                        icon: Icons.location_on_outlined,
                        iconColor: homeLightBlueColor,
                        title: 'مكان الألم',
                        value: location.isEmpty ? 'غير محدد' : location,
                      ),

                      _divider(width),

                      // =============================================
                      // REPEATED
                      // =============================================
                      _detailRow(
                        width: width,
                        height: height,
                        icon: Icons.refresh_rounded,
                        iconColor: homePinkColor,
                        title: 'هل تكرر العرض؟',
                        value: repeatedText,
                      ),

                      _divider(width),

                      // =============================================
                      // MEDICINE USED
                      // =============================================
                      _detailRow(
                        width: width,
                        height: height,
                        icon: Icons.medication_outlined,
                        iconColor: homeGreenColor,
                        title: 'هل تم استخدام دواء؟',
                        value: medicineUsedText,
                      ),

                      // =============================================
                      // MEDICINE NAME
                      // يظهر فقط إذا المستخدم كتب دواء
                      // =============================================
                      if (usedMedicine) ...[
                        _divider(width),

                        _detailRow(
                          width: width,
                          height: height,
                          icon: Icons.medical_services_outlined,
                          iconColor: homePurpleColor,
                          title: 'اسم الدواء',
                          value: medicineText,
                        ),
                      ],
                    ],
                  ),
                ),

                SizedBox(height: height * 0.025),

                // =================================================
                // NOTES TITLE
                // =================================================
                Text(
                  'الملاحظات',
                  style: TextStyle(
                    fontFamily: thmanyahFont,
                    fontSize: width * 0.052,
                    fontWeight: FontWeight.w700,
                    color: whiteColor,
                  ),
                ),

                SizedBox(height: height * 0.012),

                // =================================================
                // NOTES CARD
                // =================================================
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.045,
                    vertical: height * 0.022,
                  ),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(width * 0.05),
                    border: Border.all(color: homeBorderColor),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: width * 0.11,
                        height: width * 0.11,
                        decoration: const BoxDecoration(
                          color: homeYellowColor,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.notes_outlined,
                          color: homeDarkTextColor,
                          size: width * 0.055,
                        ),
                      ),

                      SizedBox(width: width * 0.03),

                      Expanded(
                        child: Text(
                          notesText,
                          style: TextStyle(
                            fontFamily: thmanyahFont,
                            fontSize: width * 0.041,
                            fontWeight: FontWeight.w500,
                            height: 1.6,
                            color: homeDarkTextColor,
                          ),
                        ),
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
                    // =============================================
                    // EDIT
                    // =============================================

                    Expanded(
                      child: SizedBox(
                        height: height * 0.062,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // نربط التعديل مع Supabase لاحقاً
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: homePrimaryColor,
                            foregroundColor: whiteColor,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(width * 0.04),
                            ),
                          ),
                          icon: Icon(Icons.edit_outlined, size: width * 0.05),
                          label: Text(
                            'تعديل',
                            style: TextStyle(
                              fontFamily: thmanyahFont,
                              fontSize: width * 0.041,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(width: width * 0.025),

                    // =============================================
                    // DELETE
                    // =============================================
                    Expanded(
                      child: SizedBox(
                        height: height * 0.062,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            _showDeleteDialog(context, width);
                          },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: whiteColor,
                            foregroundColor: Colors.red,
                            elevation: 0,
                            side: BorderSide.none,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(width * 0.04),
                            ),
                          ),

                          icon: Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.red,
                            size: width * 0.05,
                          ),

                          label: Text(
                            'حذف',
                            style: TextStyle(
                              fontFamily: thmanyahFont,
                              fontSize: width * 0.041,
                              fontWeight: FontWeight.w700,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: height * 0.04),
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
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height * 0.016),
      child: Row(
        children: [
          // =====================================================
          // ICON
          // =====================================================

          Container(
            width: width * 0.11,
            height: width * 0.11,
            decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
            child: Icon(icon, color: homeDarkTextColor, size: width * 0.055),
          ),

          SizedBox(width: width * 0.03),

          // =====================================================
          // TITLE
          // =====================================================
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: thmanyahFont,
                fontSize: width * 0.04,
                fontWeight: FontWeight.w600,
                color: homeDarkTextColor,
              ),
            ),
          ),

          SizedBox(width: width * 0.02),

          // =====================================================
          // VALUE
          // =====================================================
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontFamily: thmanyahFont,
                fontSize: width * 0.039,
                fontWeight: FontWeight.w700,
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
      indent: width * 0.02,
      endIndent: width * 0.02,
      color: homeBorderColor,
    );
  }

  // =========================================================
  // SYMPTOM ICON
  // =========================================================

  IconData _getSymptomIcon() {
    switch (title) {
      case 'صداع':
        return Icons.psychology_alt_outlined;

      case 'دوخة':
        return Icons.blur_circular_rounded;

      case 'غثيان':
        return Icons.sentiment_dissatisfied_outlined;

      case 'ألم في المعدة':
        return Icons.sick_outlined;

      case 'ألم في الظهر':
        return Icons.accessibility_new_rounded;

      case 'ضيق تنفس':
        return Icons.air_rounded;

      case 'تعب عام':
        return Icons.battery_2_bar_rounded;

      case 'ارتفاع حرارة':
        return Icons.thermostat_rounded;

      default:
        return Icons.health_and_safety_outlined;
    }
  }

  // =========================================================
  // DELETE DIALOG
  // =========================================================

  void _showDeleteDialog(BuildContext context, double width) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: cardColor,

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(width * 0.05),
            ),

            // العنوان
            title: Center(
              child: Text(
                'حذف العرض',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: thmanyahFont,
                  fontWeight: FontWeight.w700,
                  color: homeDarkTextColor,
                ),
              ),
            ),

            // الرسالة
            content: Text(
              'هل أنت متأكد من حذف هذا العرض؟',
              textAlign: TextAlign.center,
              style: TextStyle(fontFamily: thmanyahFont, color: homeGreyColor),
            ),

            actionsPadding: EdgeInsets.only(
              right: width * 0.04,
              left: width * 0.04,
              bottom: width * 0.04,
            ),

            actions: [
              Row(
                children: [
                  // إلغاء
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                      child: Text(
                        'إلغاء',
                        style: TextStyle(
                          fontFamily: thmanyahFont,
                          fontWeight: FontWeight.w600,
                          color: homeGreyColor,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: width * 0.02),

                  // حذف
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        try {
                          final user =
                              Supabase.instance.client.auth.currentUser;

                          if (user == null) {
                            throw Exception('المستخدم غير مسجل الدخول');
                          }

                          final deleted = await Supabase.instance.client
                              .from('symptoms')
                              .delete()
                              .eq('id', symptomId)
                              .eq('user_id', user.id)
                              .select();

                          debugPrint('symptomId: $symptomId');

                          debugPrint('userId: ${user.id}');

                          debugPrint('deleted: $deleted');

                          if (!context.mounted) return;

                          if (deleted.isEmpty) {
                            Navigator.pop(dialogContext);

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'لم يتم حذف العرض',
                                  textDirection: TextDirection.rtl,
                                ),
                              ),
                            );

                            return;
                          }

                          // إغلاق نافذة التأكيد
                          Navigator.pop(dialogContext);

                          // الرجوع إلى السجل وإرسال true
                          Navigator.pop(context, true);
                        } catch (error) {
                          debugPrint('DELETE ERROR: $error');

                          if (!context.mounted) return;

                          Navigator.pop(dialogContext);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'خطأ أثناء الحذف: $error',
                                textDirection: TextDirection.rtl,
                              ),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'حذف',
                        style: TextStyle(
                          fontFamily: thmanyahFont,
                          fontWeight: FontWeight.w700,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
