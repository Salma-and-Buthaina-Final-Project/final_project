import 'package:flutter/material.dart';

import 'package:final_project/constants/colors.dart';
import 'package:final_project/constants/fonts.dart';
import 'package:final_project/utils/screen_size.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  // موعد المراجعة القادمة فقط
  DateTime nextAppointment = DateTime(2026, 9, 15);

  final TextEditingController doctorController = TextEditingController();
  final TextEditingController clinicController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  void dispose() {
    doctorController.dispose();
    clinicController.dispose();
    notesController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day} سبتمبر ${date.year}';
  }

  // =========================================================
  // اختيار موعد المراجعة
  // =========================================================
  Future<void> _selectNextAppointment() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: nextAppointment,
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),

      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: Theme.of(context).textTheme
                .apply(fontFamily: thmanyahFont),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        nextAppointment = pickedDate;
      });
    }
  }

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

            title: Text(
              'موعد المراجعة',
              style: TextStyle(
                fontFamily: thmanyahFont,
                fontSize: width * 0.065,
                fontWeight: FontWeight.w700,
                color: whiteColor,
              ),
            ),

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
                  // NEXT APPOINTMENT
                  // =================================================
                  InkWell(
                    onTap: _selectNextAppointment,
                    borderRadius: BorderRadius.circular(width * 0.045),
                    child: _appointmentCard(
                      width: width,
                      height: height,
                      title: 'موعد المراجعة القادمة',
                      date: _formatDate(nextAppointment),
                      subtitle: 'اضغط لتعديل التاريخ',
                      color: homeGreenColor,
                      icon: Icons.event_available_outlined,
                    ),
                  ),

                  SizedBox(height: height * 0.025),

                  // =================================================
                  // DOCTOR NAME
                  // =================================================
                  _inputCard(
                    width: width,
                    height: height,
                    controller: doctorController,
                    title: 'اسم الطبيب (اختياري)',
                    hint: 'د. أحمد العنزي',
                    icon: Icons.person_outline_rounded,
                    iconColor: homeLightBlueColor,
                  ),

                  SizedBox(height: height * 0.018),

                  // =================================================
                  // CLINIC
                  // =================================================
                  _inputCard(
                    width: width,
                    height: height,
                    controller: clinicController,
                    title: 'اسم العيادة (اختياري)',
                    hint: 'عيادة الباطنية',
                    icon: Icons.local_hospital_outlined,
                    iconColor: homePurpleColor,
                  ),

                  SizedBox(height: height * 0.025),

                  // =================================================
                  // NOTES TITLE
                  // =================================================
                  Text(
                    'ملاحظات',
                    style: TextStyle(
                      fontFamily: thmanyahFont,
                      fontSize: width * 0.043,
                      fontWeight: FontWeight.w700,
                      color: whiteColor,
                    ),
                  ),

                  SizedBox(height: height * 0.009),

                  // =================================================
                  // NOTES
                  // =================================================
                  Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(width * 0.04),
                      border: Border.all(color: homeBorderColor),
                    ),
                    child: TextField(
                      controller: notesController,
                      maxLines: 4,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: thmanyahFont,
                        fontSize: width * 0.039,
                        color: homeDarkTextColor,
                      ),
                      decoration: InputDecoration(
                        hintText: 'اكتب أي ملاحظات حول موعد المراجعة...',
                        hintStyle: TextStyle(
                          fontFamily: thmanyahFont,
                          fontSize: width * 0.036,
                          color: homeGreyColor,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(width * 0.04),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.035),

                  // =================================================
                  // SAVE BUTTON
                  // =================================================
                  SizedBox(
                    height: height * 0.065,
                    child: ElevatedButton(
                      onPressed: () {
                        // نربطه مع Supabase لاحقاً

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم حفظ موعد المراجعة')),
                        );
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor: homePrimaryColor,
                        foregroundColor: whiteColor,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(width * 0.04),
                        ),
                      ),

                      child: Text(
                        'حفظ الموعد',
                        style: TextStyle(
                          fontFamily: thmanyahFont,
                          fontSize: width * 0.045,
                          fontWeight: FontWeight.w700,
                          color: whiteColor,
                        ),
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
  // APPOINTMENT CARD
  // =========================================================
  Widget _appointmentCard({
    required double width,
    required double height,
    required String title,
    required String date,
    required Color color,
    required IconData icon,
    String? subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.018,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(width * 0.045),
        border: Border.all(color: homeBorderColor),
      ),
      child: Row(
        children: [
          Container(
            width: width * 0.12,
            height: width * 0.12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: homeDarkTextColor, size: width * 0.058),
          ),

          SizedBox(width: width * 0.035),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: thmanyahFont,
                    fontSize: width * 0.041,
                    fontWeight: FontWeight.w600,
                    color: homeDarkTextColor,
                  ),
                ),

                SizedBox(height: height * 0.004),

                Text(
                  date,
                  style: TextStyle(
                    fontFamily: thmanyahFont,
                    fontSize: width * 0.043,
                    fontWeight: FontWeight.w700,
                    color: homeDarkTextColor,
                  ),
                ),

                if (subtitle != null) ...[
                  SizedBox(height: height * 0.003),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: thmanyahFont,
                      fontSize: width * 0.031,
                      fontWeight: FontWeight.w400,
                      color: homeGreyColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // INPUT CARD
  // =========================================================
  Widget _inputCard({
    required double width,
    required double height,
    required TextEditingController controller,
    required String title,
    required String hint,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.035,
        vertical: height * 0.012,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(width * 0.045),
        border: Border.all(color: homeBorderColor),
      ),
      child: Row(
        children: [
          Container(
            width: width * 0.105,
            height: width * 0.105,
            decoration: BoxDecoration(color: iconColor, shape: BoxShape.circle),
            child: Icon(icon, color: homeDarkTextColor, size: width * 0.052),
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
                    fontSize: width * 0.034,
                    fontWeight: FontWeight.w600,
                    color: homeDarkTextColor,
                  ),
                ),

                TextField(
                  controller: controller,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: thmanyahFont,
                    fontSize: width * 0.039,
                    fontWeight: FontWeight.w500,
                    color: homeDarkTextColor,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: TextStyle(
                      fontFamily: thmanyahFont,
                      fontSize: width * 0.035,
                      color: homeGreyColor,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: const EdgeInsets.only(top: 5),
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
