import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:final_project/constants/colors.dart';
import 'package:final_project/constants/fonts.dart';
import 'package:final_project/utils/screen_size.dart';

import 'package:final_project/screens/condition_detail_screen.dart';
import 'package:final_project/widgets/custom_bottom_navigation.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int selectedFilter = 0;

  final TextEditingController searchController =
      TextEditingController();

  List<Map<String, dynamic>> symptoms = [];

  bool isLoading = true;

  String? errorMessage;

  // =========================================================
  // INIT
  // =========================================================

  @override
  void initState() {
    super.initState();

    fetchSymptoms();

    searchController.addListener(() {
      setState(() {});
    });
  }

  // =========================================================
  // DISPOSE
  // =========================================================

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // =========================================================
  // GET SYMPTOMS FROM SUPABASE
  // =========================================================

  Future<void> fetchSymptoms() async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await Supabase.instance.client
          .from('symptoms')
          .select()
          .order(
            'symptom_date',
            ascending: false,
          );

      if (!mounted) return;

      setState(() {
        symptoms =
            List<Map<String, dynamic>>.from(response);

        isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = error.toString();
      });
    }
  }

  // =========================================================
  // FILTERED SYMPTOMS
  // =========================================================

  List<Map<String, dynamic>> get filteredSymptoms {
    List<Map<String, dynamic>> result =
        List<Map<String, dynamic>>.from(symptoms);

    // =====================================================
    // SEARCH
    // =====================================================

    final search =
        searchController.text.trim().toLowerCase();

    if (search.isNotEmpty) {
      result = result.where((symptom) {
        final condition =
            (symptom['condition_name'] ?? '')
                .toString()
                .toLowerCase();

        final location =
            (symptom['location'] ?? '')
                .toString()
                .toLowerCase();

        final notes =
            (symptom['notes'] ?? '')
                .toString()
                .toLowerCase();

        final medicine =
            (symptom['medicine_name'] ?? '')
                .toString()
                .toLowerCase();

        return condition.contains(search) ||
            location.contains(search) ||
            notes.contains(search) ||
            medicine.contains(search);
      }).toList();
    }

    // =====================================================
    // DATE FILTER
    // =====================================================

    final now = DateTime.now();

    // هذا الأسبوع
    if (selectedFilter == 1) {
      final startOfWeek = DateTime(
        now.year,
        now.month,
        now.day,
      ).subtract(
        Duration(
          days: now.weekday - 1,
        ),
      );

      result = result.where((symptom) {
        final date =
            DateTime.tryParse(
              symptom['symptom_date'].toString(),
            );

        if (date == null) {
          return false;
        }

        return date.isAfter(
              startOfWeek.subtract(
                const Duration(seconds: 1),
              ),
            );
      }).toList();
    }

    // هذا الشهر
    if (selectedFilter == 2) {
      result = result.where((symptom) {
        final date =
            DateTime.tryParse(
              symptom['symptom_date'].toString(),
            );

        if (date == null) {
          return false;
        }

        return date.year == now.year &&
            date.month == now.month;
      }).toList();
    }

    return result;
  }

  // =========================================================
  // DATE FORMAT
  // =========================================================

  String formatArabicDate(dynamic value) {
    if (value == null) {
      return '';
    }

    final date =
        DateTime.tryParse(value.toString());

    if (date == null) {
      return value.toString();
    }

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

  // =========================================================
  // SEVERITY COLOR
  // =========================================================

  Color getSeverityColor(int severity) {
    if (severity <= 3) {
      return homeGreenColor;
    }

    if (severity <= 6) {
      return homeYellowColor;
    }

    return homePinkColor;
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
        textTheme:
            Theme.of(context).textTheme.apply(
          fontFamily: thmanyahFont,
        ),
      ),

      child: Directionality(
        textDirection: TextDirection.rtl,

        child: Scaffold(
          backgroundColor: backgroundColor,

          // =====================================================
          // BODY
          // =====================================================

          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: fetchSymptoms,

              child: SingleChildScrollView(
                physics:
                    const AlwaysScrollableScrollPhysics(),

                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.055,
                  vertical: height * 0.02,
                ),

                child: Column(
                  children: [
                    // =============================================
                    // HEADER
                    // =============================================

                    SizedBox(
                      height: height * 0.07,

                      child: Stack(
                        alignment: Alignment.center,

                        children: [
                          Center(
                            child: Text(
                              'سجل الأعراض',

                              style: TextStyle(
                                fontFamily:
                                    thmanyahFont,

                                fontSize:
                                    width * 0.07,

                                fontWeight:
                                    FontWeight.w700,

                                color:
                                    mainTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(
                      height: height * 0.02,
                    ),

                    // =============================================
                    // SEARCH
                    // =============================================

                    Container(
                      decoration: BoxDecoration(
                        color: cardColor,

                        borderRadius:
                            BorderRadius.circular(
                          width * 0.045,
                        ),

                        border: Border.all(
                          color:
                              homeBorderColor,
                        ),
                      ),

                      child: TextField(
                        controller:
                            searchController,

                        textAlign:
                            TextAlign.right,

                        style: TextStyle(
                          fontFamily:
                              thmanyahFont,

                          color:
                              homeDarkTextColor,

                          fontSize:
                              width * 0.038,
                        ),

                        decoration:
                            InputDecoration(
                          hintText:
                              'ابحث عن عرض أو كلمة مفتاحية...',

                          hintStyle:
                              TextStyle(
                            fontFamily:
                                thmanyahFont,

                            color:
                                homeGreyColor,

                            fontSize:
                                width * 0.035,
                          ),

                          prefixIcon: Icon(
                            Icons
                                .search_rounded,

                            color:
                                homeDarkTextColor,

                            size:
                                width * 0.07,
                          ),

                          border:
                              InputBorder.none,

                          contentPadding:
                              EdgeInsets.symmetric(
                            horizontal:
                                width * 0.04,

                            vertical:
                                height * 0.018,
                          ),
                        ),
                      ),
                    ),

                    SizedBox(
                      height: height * 0.025,
                    ),

                    // =============================================
                    // FILTERS
                    // =============================================

                    Row(
                      children: [
                        Expanded(
                          child:
                              _filterButton(
                            title: 'الكل',
                            index: 0,
                            width: width,
                            height: height,
                          ),
                        ),

                        SizedBox(
                          width: width * 0.025,
                        ),

                        Expanded(
                          child:
                              _filterButton(
                            title:
                                'هذا الأسبوع',
                            index: 1,
                            width: width,
                            height: height,
                          ),
                        ),

                        SizedBox(
                          width: width * 0.025,
                        ),

                        Expanded(
                          child:
                              _filterButton(
                            title:
                                'هذا الشهر',
                            index: 2,
                            width: width,
                            height: height,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      height: height * 0.025,
                    ),

                    // =============================================
                    // CONTENT
                    // =============================================

                    if (isLoading)
                      _loading(
                        width,
                        height,
                      )
                    else if (errorMessage != null)
                      _error(
                        width,
                        height,
                      )
                    else if (filteredSymptoms
                        .isEmpty)
                      _empty(
                        width,
                        height,
                      )
                    else
                      _symptomsList(
                        width,
                        height,
                      ),

                    SizedBox(
                      height: height * 0.05,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // =====================================================
          // BOTTOM NAVIGATION
          // =====================================================

          bottomNavigationBar:
              const CustomBottomNavigation(
            selectedIndex: 1,
          ),
        ),
      ),
    );
  }

  // =========================================================
  // SYMPTOMS LIST
  // =========================================================

  Widget _symptomsList(
    double width,
    double height,
  ) {
    final list = filteredSymptoms;

    return Container(
      width: double.infinity,

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius:
            BorderRadius.circular(
          width * 0.05,
        ),

        border: Border.all(
          color: homeBorderColor,
        ),
      ),

      child: ListView.separated(
        shrinkWrap: true,

        physics:
            const NeverScrollableScrollPhysics(),

        itemCount: list.length,

        separatorBuilder:
            (context, index) {
          return Divider(
            height: 1,
            thickness: 1,

            indent: width * 0.04,
            endIndent: width * 0.04,

            color: homeBorderColor,
          );
        },

        itemBuilder:
            (context, index) {
          final symptom = list[index];

          final title =
              (symptom['condition_name'] ??
                      'غير محدد')
                  .toString();

          final severity =
              int.tryParse(
                    symptom['severity']
                        .toString(),
                  ) ??
                  1;

          final date =
              formatArabicDate(
            symptom['symptom_date'],
          );

          final color =
              getSeverityColor(
            severity,
          );
return _symptomItem(
  width: width,
  height: height,
  symptom: symptom,
  title: title,
  date: date,
  severity: severity.toString(),
  color: color,
);
        },
      ),
    );
  }

  // =========================================================
  // LOADING
  // =========================================================

  Widget _loading(
    double width,
    double height,
  ) {
    return Container(
      width: double.infinity,
      height: height * 0.22,

      alignment: Alignment.center,

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius:
            BorderRadius.circular(
          width * 0.05,
        ),

        border: Border.all(
          color: homeBorderColor,
        ),
      ),

      child:
          const CircularProgressIndicator(
        color: homePrimaryColor,
      ),
    );
  }

  // =========================================================
  // EMPTY
  // =========================================================

  Widget _empty(
    double width,
    double height,
  ) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.symmetric(
        vertical: height * 0.055,
        horizontal: width * 0.05,
      ),

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius:
            BorderRadius.circular(
          width * 0.05,
        ),

        border: Border.all(
          color: homeBorderColor,
        ),
      ),

      child: Column(
        children: [
          Container(
            width: width * 0.17,
            height: width * 0.17,

            decoration:
                const BoxDecoration(
              color: homeLightBlueColor,
              shape: BoxShape.circle,
            ),

            child: Icon(
              Icons
                  .health_and_safety_outlined,

              color:
                  homeDarkTextColor,

              size:
                  width * 0.085,
            ),
          ),

          SizedBox(
            height: height * 0.015,
          ),

          Text(
            searchController
                    .text.isNotEmpty
                ? 'لا توجد نتائج'
                : 'لا توجد أعراض مسجلة',

            style: TextStyle(
              fontFamily:
                  thmanyahFont,

              fontSize:
                  width * 0.045,

              fontWeight:
                  FontWeight.w700,

              color:
                  homeDarkTextColor,
            ),
          ),

          SizedBox(
            height: height * 0.005,
          ),

          Text(
            searchController
                    .text.isNotEmpty
                ? 'جربي البحث بكلمة أخرى'
                : 'الأعراض التي تسجلينها ستظهر هنا',

            textAlign:
                TextAlign.center,

            style: TextStyle(
              fontFamily:
                  thmanyahFont,

              fontSize:
                  width * 0.035,

              color:
                  homeGreyColor,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // ERROR
  // =========================================================

  Widget _error(
    double width,
    double height,
  ) {
    return Container(
      width: double.infinity,

      padding: EdgeInsets.symmetric(
        vertical: height * 0.04,
        horizontal: width * 0.05,
      ),

      decoration: BoxDecoration(
        color: cardColor,

        borderRadius:
            BorderRadius.circular(
          width * 0.05,
        ),

        border: Border.all(
          color: homeBorderColor,
        ),
      ),

      child: Column(
        children: [
          Icon(
            Icons.error_outline_rounded,

            color:
                homeDarkTextColor,

            size:
                width * 0.10,
          ),

          SizedBox(
            height: height * 0.015,
          ),

          Text(
            'تعذر تحميل الأعراض',

            style: TextStyle(
              fontFamily:
                  thmanyahFont,

              fontSize:
                  width * 0.043,

              fontWeight:
                  FontWeight.w700,

              color:
                  homeDarkTextColor,
            ),
          ),

          SizedBox(
            height: height * 0.015,
          ),

          ElevatedButton(
            onPressed:
                fetchSymptoms,

            style:
                ElevatedButton.styleFrom(
              backgroundColor:
                  homePrimaryColor,

              foregroundColor:
                  whiteColor,

              elevation: 0,
            ),

            child: const Text(
              'إعادة المحاولة',

              style: TextStyle(
                fontFamily:
                    thmanyahFont,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // FILTER BUTTON
  // =========================================================

  Widget _filterButton({
    required String title,
    required int index,
    required double width,
    required double height,
  }) {
    final bool isSelected =
        selectedFilter == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = index;
        });
      },

      child: AnimatedContainer(
        duration:
            const Duration(
          milliseconds: 200,
        ),

        height: height * 0.06,

        alignment:
            Alignment.center,

        decoration: BoxDecoration(
          color: isSelected
              ? homePrimaryColor
              : homeLightBlueColor,

          borderRadius:
              BorderRadius.circular(
            width * 0.05,
          ),

          border: Border.all(
            color: isSelected
                ? homePrimaryColor
                : homeBorderColor,
          ),
        ),

        child: FittedBox(
          fit: BoxFit.scaleDown,

          child: Text(
            title,

            textAlign:
                TextAlign.center,

            style: TextStyle(
              fontFamily:
                  thmanyahFont,

              fontSize:
                  width * 0.037,

              fontWeight:
                  FontWeight.w600,

              color: isSelected
                  ? whiteColor
                  : homeDarkTextColor,
            ),
          ),
        ),
      ),
    );
  }

  // =========================================================
  // SYMPTOM ITEM
  // =========================================================

 Widget _symptomItem({
  required double width,
  required double height,
  required Map<String, dynamic> symptom,
  required String title,
  required String date,
  required String severity,
  required Color color,
}) {
  return Material(
    color: Colors.transparent,
    child: InkWell(
      borderRadius: BorderRadius.circular(
        width * 0.04,
      ),

      // =====================================================
      // OPEN CONDITION DETAILS
      // =====================================================
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConditionDetailsScreen(
              title: title,
              date: date,
              severity: severity,
              color: color,

              // بيانات Supabase الحقيقية
              location:
                  (symptom['location'] ?? 'غير محدد').toString(),

              isRepeated:
                  symptom['is_repeated'] == true,

              medicineName:
                  symptom['medicine_name']?.toString(),

              notes:
                  symptom['notes']?.toString(),
            ),
          ),
        );
      },

      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: width * 0.035,
          vertical: height * 0.018,
        ),
        child: Row(
          children: [
            // =================================================
            // SEVERITY
            // =================================================

            Container(
              width: width * 0.14,
              height: width * 0.14,
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
                  fontSize: width * 0.06,
                  fontWeight: FontWeight.w700,
                  color: homeDarkTextColor,
                ),
              ),
            ),

            SizedBox(
              width: width * 0.035,
            ),

            // =================================================
            // CONDITION + DATE
            // =================================================

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: thmanyahFont,
                      fontSize: width * 0.05,
                      fontWeight: FontWeight.w700,
                      color: homeDarkTextColor,
                    ),
                  ),

                  SizedBox(
                    height: height * 0.003,
                  ),

                  Text(
                    date,
                    style: TextStyle(
                      fontFamily: thmanyahFont,
                      fontSize: width * 0.036,
                      fontWeight: FontWeight.w500,
                      color: homeDarkTextColor,
                    ),
                  ),
                ],
              ),
            ),

            // =================================================
            // ARROW
            // =================================================

            Icon(
              Icons.arrow_back_ios_new_rounded,
              size: width * 0.045,
              color: homeDarkTextColor,
            ),
          ],
        ),
      ),
    ),
  );
}
}