import 'package:flutter/material.dart';

import 'package:final_project/constants/colors.dart';
import 'package:final_project/constants/fonts.dart';
import 'package:final_project/utils/screen_size.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppointmentScreen extends StatefulWidget {
  const AppointmentScreen({super.key});

  @override
  State<AppointmentScreen> createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  // موعد المراجعة القادمة فقط
  DateTime? nextAppointment;
  String? appointmentId;
  bool isLoading = true;

  Future<void> saveAppointment() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('يجب تسجيل الدخول أولاً')));
      return;
    }
    if (nextAppointment == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'الرجاء تحديد موعد المراجعة أولاً',
            textDirection: TextDirection.rtl,
            style: TextStyle(fontFamily: thmanyahFont),
          ),
        ),
      );
      return;
    }

    try {
      final appointmentData = {
        'user_id': user.id,
        'appointment_date': nextAppointment!.toIso8601String(),

        'doctor_name': doctorController.text.trim().isEmpty
            ? null
            : doctorController.text.trim(),

        'clinic_name': clinicController.text.trim().isEmpty
            ? null
            : clinicController.text.trim(),

        'notes': notesController.text.trim().isEmpty
            ? null
            : notesController.text.trim(),

        'updated_at': DateTime.now().toIso8601String(),
      };

      // يوجد موعد سابق -> تعديل
      if (appointmentId != null) {
        await Supabase.instance.client
            .from('appointments')
            .update(appointmentData)
            .eq('id', appointmentId!);
      }
      // لا يوجد موعد -> إنشاء أول موعد
      else {
        final data = await Supabase.instance.client
            .from('appointments')
            .insert(appointmentData)
            .select()
            .single();

        appointmentId = data['id'];
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ تعديلات الموعد بنجاح')),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء حفظ الموعد: $error')),
      );
    }
  }

  final TextEditingController doctorController = TextEditingController();
  final TextEditingController clinicController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadAppointment();
  }

  @override
  void dispose() {
    doctorController.dispose();
    clinicController.dispose();
    notesController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    const months = [
      '',
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];

    return '${date.day} ${months[date.month]} ${date.year}';
  }

  Future<void> loadAppointment() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      return;
    }

    try {
      final data = await Supabase.instance.client
          .from('appointments')
          .select()
          .eq('user_id', user.id)
          .order('updated_at', ascending: false)
          .limit(1)
          .maybeSingle();

      if (!mounted) return;

      if (data != null) {
        setState(() {
          appointmentId = data['id'];

          nextAppointment = DateTime.parse(data['appointment_date']).toLocal();

          doctorController.text = data['doctor_name'] ?? '';

          clinicController.text = data['clinic_name'] ?? '';

          notesController.text = data['notes'] ?? '';

          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (error) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء تحميل الموعد: $error')),
      );
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
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () async {
                      final now = DateTime.now();

                      final today = DateTime(now.year, now.month, now.day);

                      final DateTime initialDate =
                          nextAppointment == null ||
                              nextAppointment!.isBefore(today)
                          ? today
                          : nextAppointment!;

                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: initialDate,
                        firstDate: today,
                        lastDate: DateTime(2035, 12, 31),
                      );

                      if (pickedDate != null && mounted) {
                        setState(() {
                          nextAppointment = pickedDate;
                        });
                      }
                    },
                    child: _appointmentCard(
                      width: width,
                      height: height,
                      title: 'موعد المراجعة القادمة',
                      date: nextAppointment == null
                          ? ''
                          : _formatDate(nextAppointment!),
                      subtitle: nextAppointment == null
                          ? 'اضغط لتحديد التاريخ'
                          : 'اضغط لتعديل التاريخ',
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
                      onPressed: saveAppointment,
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
