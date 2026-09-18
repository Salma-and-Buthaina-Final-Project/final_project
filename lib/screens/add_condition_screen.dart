import 'package:final_project/constants/colors.dart';
import 'package:final_project/constants/fonts.dart';
import 'package:final_project/utils/screen_size.dart';
import 'package:final_project/widgets/custom_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddConditionScreen extends StatefulWidget {
  const AddConditionScreen({super.key});

  @override
  State<AddConditionScreen> createState() => _AddConditionScreenState();
}

class _AddConditionScreenState extends State<AddConditionScreen> {
  String? selectedCondition;
  String? selectedLocation;

  int severity = 1;

  bool isRepeated = false;
  bool tookMedicine = false;

  DateTime selectedDateTime = DateTime.now();

  final TextEditingController notesController = TextEditingController();

  final TextEditingController medicineController = TextEditingController();

  bool isSaving = false;

  final List<String> conditions = [
    "صداع",
    "دوخة",
    "غثيان",
    "ألم في المعدة",
    "ألم في الظهر",
    "ضيق تنفس",
    "تعب عام",
    "ارتفاع حرارة",
    "أخرى",
  ];

  final List<String> locations = [
    "الرأس",
    "الصدر",
    "البطن",
    "الظهر",
    "الرقبة",
    "اليد",
    "القدم",
    "الجسم كامل",
    "أخرى",
  ];

  @override
  void dispose() {
    notesController.dispose();
    medicineController.dispose();
    super.dispose();
  }

  // =========================================================
  // SELECT DATE & TIME
  // =========================================================
  Future<void> selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: Theme.of(
              context,
            ).textTheme.apply(fontFamily: thmanyahFont),
          ),
          child: child!,
        );
      },
    );

    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            textTheme: Theme.of(
              context,
            ).textTheme.apply(fontFamily: thmanyahFont),
          ),
          child: child!,
        );
      },
    );

    if (time == null) return;

    setState(() {
      selectedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  // =========================================================
  // FORMAT DATE & TIME
  // =========================================================
  String formatDateTime() {
    final date =
        "${selectedDateTime.day}/${selectedDateTime.month}/${selectedDateTime.year}";

    final time = TimeOfDay.fromDateTime(
      selectedDateTime,
    ).format(context);

    return "$date - $time";
  }

  // =========================================================
  // SAVE SYMPTOM
  // =========================================================
  Future<void> saveSymptom() async {
    // التأكد من اختيار العرض
    if (selectedCondition == null) {
      _showMessage('اختاري نوع العرض أولاً');
      return;
    }

    // التأكد من اختيار المكان
    if (selectedLocation == null) {
      _showMessage('اختاري مكان الألم');
      return;
    }

    // إذا قالت إنها أخذت دواء، لازم تكتب اسمه
    if (tookMedicine && medicineController.text.trim().isEmpty) {
      _showMessage('اكتبي اسم الدواء');
      return;
    }

    // =======================================================
    // GET CURRENT USER
    // =======================================================
    final user = Supabase.instance.client.auth.currentUser;

    // التأكد أن فيه مستخدم مسجل دخوله
    if (user == null) {
      _showMessage('يجب تسجيل الدخول أولاً');
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      // =====================================================
      // INSERT SYMPTOM
      // =====================================================
      await Supabase.instance.client.from('symptoms').insert({
        // ربط العرض بالمستخدم الحالي
        'user_id': user.id,

        'condition_name': selectedCondition,
        'location': selectedLocation,
        'severity': severity,
        'is_repeated': isRepeated,
        'took_medicine': tookMedicine,

        'medicine_name':
            tookMedicine ? medicineController.text.trim() : null,

        'symptom_date': selectedDateTime.toIso8601String(),

        'notes': notesController.text.trim().isEmpty
            ? null
            : notesController.text.trim(),
      });

      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'تم حفظ العرض بنجاح',
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontFamily: thmanyahFont,
            ),
          ),
          backgroundColor: homePrimaryColor,
        ),
      );

      // =====================================================
      // RESET FIELDS
      // =====================================================
      setState(() {
        selectedCondition = null;
        selectedLocation = null;
        severity = 1;
        isRepeated = false;
        tookMedicine = false;
        selectedDateTime = DateTime.now();

        notesController.clear();
        medicineController.clear();
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      _showMessage(
        'حدث خطأ أثناء حفظ العرض:\n$error',
      );
    }
  }

  // =========================================================
  // SHOW MESSAGE
  // =========================================================
  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textDirection: TextDirection.rtl,
          style: const TextStyle(
            fontFamily: thmanyahFont,
          ),
        ),
      ),
    );
  }

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
            automaticallyImplyLeading: false,
            title: Text(
              "تسجيل عرض جديد",
              style: TextStyle(
                fontFamily: thmanyahFont,
                color: whiteColor,
                fontSize: width * 0.065,
                fontWeight: FontWeight.w700,
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
                // نوع العرض
                // =================================================
                _title("نوع العرض", width),

                DropdownButtonFormField<String>(
                  value: selectedCondition,
                  decoration: _inputDecoration(
                    hint: "اختر العرض",
                    icon: Icons.health_and_safety_outlined,
                    iconBackground: homePurpleColor,
                    width: width,
                  ),
                  dropdownColor: cardColor,
                  style: TextStyle(
                    fontFamily: thmanyahFont,
                    color: homeDarkTextColor,
                    fontSize: width * 0.042,
                    fontWeight: FontWeight.w500,
                  ),
                  items: conditions.map((condition) {
                    return DropdownMenuItem<String>(
                      value: condition,
                      child: Text(
                        condition,
                        style: TextStyle(
                          fontFamily: thmanyahFont,
                          color: homeDarkTextColor,
                          fontSize: width * 0.042,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCondition = value;
                    });
                  },
                ),

                SizedBox(height: height * 0.022),

                // =================================================
                // مكان الألم
                // =================================================
                _title("مكان الألم", width),

                DropdownButtonFormField<String>(
                  value: selectedLocation,
                  decoration: _inputDecoration(
                    hint: "اختر مكان الألم",
                    icon: Icons.location_on_outlined,
                    iconBackground: homeLightBlueColor,
                    width: width,
                  ),
                  dropdownColor: cardColor,
                  style: TextStyle(
                    fontFamily: thmanyahFont,
                    color: homeDarkTextColor,
                    fontSize: width * 0.042,
                    fontWeight: FontWeight.w500,
                  ),
                  items: locations.map((location) {
                    return DropdownMenuItem<String>(
                      value: location,
                      child: Text(
                        location,
                        style: TextStyle(
                          fontFamily: thmanyahFont,
                          color: homeDarkTextColor,
                          fontSize: width * 0.042,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedLocation = value;
                    });
                  },
                ),

                SizedBox(height: height * 0.022),

                // =================================================
                // التاريخ والوقت
                // =================================================
                _title("التاريخ والوقت", width),

                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: selectDateTime,
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: width * 0.035,
                        vertical: height * 0.014,
                      ),
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: homeBorderColor,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: width * 0.11,
                            height: width * 0.11,
                            decoration: const BoxDecoration(
                              color: homeGreenColor,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.calendar_month_outlined,
                              color: homeDarkTextColor,
                              size: width * 0.055,
                            ),
                          ),

                          SizedBox(width: width * 0.03),

                          Expanded(
                            child: Text(
                              formatDateTime(),
                              style: TextStyle(
                                fontFamily: thmanyahFont,
                                color: homeDarkTextColor,
                                fontSize: width * 0.041,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                          Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: homeDarkTextColor,
                            size: width * 0.055,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                SizedBox(height: height * 0.025),

                // =================================================
                // شدة العرض
                // =================================================
                _title("شدة العرض", width),

                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.025,
                    vertical: height * 0.018,
                  ),
                  decoration: BoxDecoration(
                    color: cardColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: homeBorderColor,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "خفيف",
                            style: TextStyle(
                              fontFamily: thmanyahFont,
                              fontSize: width * 0.035,
                              fontWeight: FontWeight.w500,
                              color: homeDarkTextColor,
                            ),
                          ),
                          Text(
                            "شديد",
                            style: TextStyle(
                              fontFamily: thmanyahFont,
                              fontSize: width * 0.035,
                              fontWeight: FontWeight.w500,
                              color: homeDarkTextColor,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: height * 0.015),

                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: width * 0.014,
                        runSpacing: height * 0.01,
                        children: List.generate(10, (index) {
                          final number = index + 1;
                          final selected = severity == number;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                severity = number;
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(
                                milliseconds: 150,
                              ),
                              width: width * 0.065,
                              height: width * 0.065,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: selected
                                    ? homePrimaryColor
                                    : _severityColor(number),
                              ),
                              child: Text(
                                "$number",
                                style: TextStyle(
                                  fontFamily: thmanyahFont,
                                  fontSize: width * 0.030,
                                  fontWeight: FontWeight.bold,
                                  color: selected
                                      ? whiteColor
                                      : homeDarkTextColor,
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.022),

                // =================================================
                // هل تكررت الحالة؟
                // =================================================
                _checkCard(
                  width: width,
                  title: "هل تكررت هذه الحالة؟",
                  value: isRepeated,
                  color: homePinkColor,
                  icon: Icons.refresh_rounded,
                  onChanged: (value) {
                    setState(() {
                      isRepeated = value ?? false;
                    });
                  },
                ),

                SizedBox(height: height * 0.015),

                // =================================================
                // هل أخذتِ دواء؟
                // =================================================
                _checkCard(
                  width: width,
                  title: "هل أخذتِ دواء؟",
                  value: tookMedicine,
                  color: homeGreenColor,
                  icon: Icons.medication_outlined,
                  onChanged: (value) {
                    setState(() {
                      tookMedicine = value ?? false;

                      if (!tookMedicine) {
                        medicineController.clear();
                      }
                    });
                  },
                ),

                // =================================================
                // اسم الدواء
                // =================================================
                if (tookMedicine) ...[
                  SizedBox(height: height * 0.022),

                  _title("اسم الدواء", width),

                  TextField(
                    controller: medicineController,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: thmanyahFont,
                      color: homeDarkTextColor,
                      fontSize: width * 0.041,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: _inputDecoration(
                      hint: "اكتبي اسم الدواء...",
                      icon: Icons.medication_outlined,
                      iconBackground: homeGreenColor,
                      width: width,
                    ),
                  ),
                ],

                SizedBox(height: height * 0.022),

                // =================================================
                // الملاحظات
                // =================================================
                _title(
                  "ملاحظات إضافية ",
                  width,
                ),

                TextField(
                  controller: notesController,
                  maxLines: 3,
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: thmanyahFont,
                    color: homeDarkTextColor,
                    fontSize: width * 0.041,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: _inputDecoration(
                    hint: "اكتب أي ملاحظات هنا...",
                    icon: Icons.notes_outlined,
                    iconBackground: homeYellowColor,
                    width: width,
                  ),
                ),

                SizedBox(height: height * 0.03),

                // =================================================
                // حفظ العرض
                // =================================================
                SizedBox(
                  height: height * 0.065,
                  child: ElevatedButton(
                    onPressed: isSaving
                        ? null
                        : () {
                            saveSymptom();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: homePrimaryColor,
                      foregroundColor: whiteColor,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          width * 0.04,
                        ),
                      ),
                    ),
                    child: isSaving
                        ? SizedBox(
                            width: width * 0.055,
                            height: width * 0.055,
                            child:
                                const CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: whiteColor,
                            ),
                          )
                        : Text(
                            "حفظ العرض",
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

          // =====================================================
          // BOTTOM NAVIGATION
          // =====================================================
          bottomNavigationBar:
              const CustomBottomNavigation(
            selectedIndex: 2,
          ),
        ),
      ),
    );
  }

  // =========================================================
  // TITLE
  // =========================================================
  Widget _title(String title, double width) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: thmanyahFont,
          color: whiteColor,
          fontSize: width * 0.043,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // =========================================================
  // INPUT DECORATION
  // =========================================================
  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    required Color iconBackground,
    required double width,
  }) {
    return InputDecoration(
      hintText: hint,

      hintStyle: TextStyle(
        fontFamily: thmanyahFont,
        color: homeGreyColor,
        fontSize: width * 0.039,
        fontWeight: FontWeight.w400,
      ),

      prefixIcon: Padding(
        padding: const EdgeInsets.all(8),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconBackground,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: homeDarkTextColor,
            size: 20,
          ),
        ),
      ),

      filled: true,
      fillColor: cardColor,

      contentPadding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 14,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: homeBorderColor,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: homeBorderColor,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: homePrimaryColor,
          width: 1.5,
        ),
      ),
    );
  }

  // =========================================================
  // CHECKBOX
  // =========================================================
  Widget _checkCard({
    required double width,
    required String title,
    required bool value,
    required Color color,
    required IconData icon,
    required ValueChanged<bool?> onChanged,
  }) {
    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: homeBorderColor,
          ),
        ),
        child: CheckboxListTile(
          value: value,
          onChanged: onChanged,
          activeColor: homePrimaryColor,
          checkColor: whiteColor,
          tileColor: cardColor,
          selectedTileColor: cardColor,
          controlAffinity:
              ListTileControlAffinity.leading,

          secondary: Container(
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

          title: Text(
            title,
            style: TextStyle(
              fontFamily: thmanyahFont,
              color: homeDarkTextColor,
              fontSize: width * 0.041,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // SEVERITY COLORS
  // =========================================================
  Color _severityColor(int number) {
    if (number <= 3) {
      return homeGreenColor;
    }

    if (number <= 6) {
      return homeYellowColor;
    }

    return homePinkColor;
  }
}