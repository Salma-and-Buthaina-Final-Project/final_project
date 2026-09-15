import 'package:final_project/constants/colors.dart';
import 'package:final_project/constants/fonts.dart';
import 'package:final_project/utils/screen_size.dart';
import 'package:flutter/material.dart';

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
    super.dispose();
  }

  Future<void> selectDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (date == null || !mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(selectedDateTime),
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

  String formatDateTime() {
    final date =
        "${selectedDateTime.day}/${selectedDateTime.month}/${selectedDateTime.year}";

    final time =
        TimeOfDay.fromDateTime(selectedDateTime).format(context);

    return "$date - $time";
  }

  @override
  Widget build(BuildContext context) {
    final width = screenWidth(context);
    final height = screenHeight(context);

    return Directionality(
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
              // CONDITION
              // =================================================
              _title(
                "نوع العرض",
                width,
              ),

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
              // LOCATION
              // =================================================
              _title(
                "مكان الألم",
                width,
              ),

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
              // DATE & TIME
              // =================================================
              _title(
                "التاريخ والوقت",
                width,
              ),

              InkWell(
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

              SizedBox(height: height * 0.025),

              // =================================================
              // SEVERITY
              // =================================================
              _title(
                "شدة العرض",
                width,
              ),

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
                      children: List.generate(
                        10,
                        (index) {
                          final number = index + 1;
                          final selected =
                              severity == number;

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
                                  fontFamily:
                                      thmanyahFont,
                                  fontSize:
                                      width * 0.030,
                                  fontWeight:
                                      FontWeight.bold,
                                  color: selected
                                      ? whiteColor
                                      : homeDarkTextColor,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: height * 0.022),

              // =================================================
              // REPEATED
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
              // MEDICINE
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
                  });
                },
              ),

              SizedBox(height: height * 0.022),

              // =================================================
              // NOTES
              // =================================================
              _title(
                "ملاحظات إضافية (اختياري)",
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
                  hint: "اكتبي أي ملاحظات هنا...",
                  icon: Icons.notes_outlined,
                  iconBackground: homeYellowColor,
                  width: width,
                ),
              ),

              SizedBox(height: height * 0.03),

              // =================================================
              // SAVE BUTTON
              // =================================================
              SizedBox(
                height: height * 0.065,
                child: ElevatedButton(
                  onPressed: () {
                    // Supabase later
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        homePrimaryColor,
                    foregroundColor: whiteColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(
                        width * 0.04,
                      ),
                    ),
                  ),
                  child: Text(
                    "حفظ العرض",
                    textAlign: TextAlign.center,
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
    );
  }

  // =========================================================
  // SECTION TITLE
  // =========================================================

  Widget _title(
    String title,
    double width,
  ) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 9,
      ),
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

      contentPadding:
          const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 14,
      ),

      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: homeBorderColor,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: homeBorderColor,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: homePrimaryColor,
          width: 1.5,
        ),
      ),
    );
  }

  // =========================================================
  // CHECK CARD
  // =========================================================

  Widget _checkCard({
    required double width,
    required String title,
    required bool value,
    required Color color,
    required IconData icon,
    required ValueChanged<bool?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: homeBorderColor,
        ),
      ),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        activeColor: homePrimaryColor,
        checkColor: whiteColor,
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