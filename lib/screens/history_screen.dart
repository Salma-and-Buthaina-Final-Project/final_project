import 'package:flutter/material.dart';

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

  final TextEditingController searchController = TextEditingController();

  final List<Map<String, dynamic>> symptoms = [
    {
      'title': 'صداع',
      'date': '12 سبتمبر 2026',
      'severity': '7',
      'color': homePinkColor,
    },
    {
      'title': 'ألم في المعدة',
      'date': '10 سبتمبر 2026',
      'severity': '10',
      'color': homePinkColor,
    },
    {
      'title': 'غثيان',
      'date': '7 سبتمبر 2026',
      'severity': '4',
      'color': homeYellowColor,
    },
    {
      'title': 'ألم في الظهر',
      'date': '3 سبتمبر 2026',
      'severity': '6',
      'color': homeYellowColor,
    },
    {
      'title': 'ضيق تنفس',
      'date': '1 سبتمبر 2026',
      'severity': '3',
      'color': homeGreenColor,
    },
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = screenWidth(context);
    final height = screenHeight(context);

    return Theme(
      // =====================================================
      // خط ثمانية للصفحة كاملة
      // =====================================================
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
          // BODY
          // =====================================================
          body: SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.055,
                vertical: height * 0.02,
              ),
              child: Column(
                children: [
                  // =================================================
                  // HEADER
                  // =================================================
                  SizedBox(
                    height: height * 0.07,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Center(
                          child: Text(
                            'سجل الأعراض',
                            style: TextStyle(
                              fontFamily: thmanyahFont,
                              fontSize: width * 0.07,
                              fontWeight: FontWeight.w700,
                              color: mainTextColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: height * 0.02),

                  // =================================================
                  // SEARCH
                  // =================================================
                  Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(
                        width * 0.045,
                      ),
                      border: Border.all(
                        color: homeBorderColor,
                      ),
                    ),
                    child: TextField(
                      controller: searchController,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontFamily: thmanyahFont,
                        color: homeDarkTextColor,
                        fontSize: width * 0.038,
                      ),
                      decoration: InputDecoration(
                        hintText: 'ابحث عن عرض أو كلمة مفتاحية...',
                        hintStyle: TextStyle(
                          fontFamily: thmanyahFont,
                          color: homeGreyColor,
                          fontSize: width * 0.035,
                        ),
                        prefixIcon: Icon(
                          Icons.search_rounded,
                          color: homeDarkTextColor,
                          size: width * 0.07,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: width * 0.04,
                          vertical: height * 0.018,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.025),

                  // =================================================
                  // FILTERS
                  // =================================================
                  Row(
                    children: [
                      Expanded(
                        child: _filterButton(
                          title: 'الكل',
                          index: 0,
                          width: width,
                          height: height,
                        ),
                      ),

                      SizedBox(width: width * 0.025),

                      Expanded(
                        child: _filterButton(
                          title: 'هذا الأسبوع',
                          index: 1,
                          width: width,
                          height: height,
                        ),
                      ),

                      SizedBox(width: width * 0.025),

                      Expanded(
                        child: _filterButton(
                          title: 'هذا الشهر',
                          index: 2,
                          width: width,
                          height: height,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.025),

                  // =================================================
                  // SYMPTOMS LIST
                  // =================================================
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(
                        width * 0.05,
                      ),
                      border: Border.all(
                        color: homeBorderColor,
                      ),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: symptoms.length,

                      separatorBuilder: (context, index) {
                        return Divider(
                          height: 1,
                          thickness: 1,
                          indent: width * 0.04,
                          endIndent: width * 0.04,
                          color: homeBorderColor,
                        );
                      },

                      itemBuilder: (context, index) {
                        final symptom = symptoms[index];

                        return _symptomItem(
                          width: width,
                          height: height,
                          title: symptom['title'],
                          date: symptom['date'],
                          severity: symptom['severity'],
                          color: symptom['color'],
                        );
                      },
                    ),
                  ),

                  SizedBox(height: height * 0.05),
                ],
              ),
            ),
          ),

          // =================================================
          // CUSTOM BOTTOM NAVIGATION
          // =================================================
          bottomNavigationBar: const CustomBottomNavigation(
            selectedIndex: 1,
          ),
        ),
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
    final bool isSelected = selectedFilter == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = index;
        });
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: height * 0.06,
        alignment: Alignment.center,

        decoration: BoxDecoration(
          color: isSelected
              ? homePrimaryColor
              : homeLightBlueColor,

          borderRadius: BorderRadius.circular(
            width * 0.05,
          ),

          border: Border.all(
            color: isSelected
                ? homePrimaryColor
                : homeBorderColor,
          ),
        ),

        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: thmanyahFont,
            fontSize: width * 0.037,
            fontWeight: FontWeight.w600,
            color: isSelected
                ? whiteColor
                : homeDarkTextColor,
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

        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ConditionDetailsScreen(
                title: title,
                date: date,
                severity: severity,
                color: color,
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

              SizedBox(width: width * 0.035),

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

                    SizedBox(height: height * 0.003),

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