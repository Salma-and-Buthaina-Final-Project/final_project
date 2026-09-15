import 'package:final_project/screens/report_screen.dart';
import 'package:flutter/material.dart';
import 'package:final_project/constants/colors.dart';
import 'package:final_project/constants/fonts.dart';
import 'package:final_project/utils/screen_size.dart';
import 'package:final_project/screens/add_condition_screen.dart';
import 'package:final_project/screens/home_screen.dart';
import 'package:final_project/screens/condition_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  int selectedIndex = 1;
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

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundColor,

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
                            color: mainTextColor ,
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
        // BOTTOM NAVIGATION
        // =================================================
        bottomNavigationBar: _bottomNavigation(width),
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
      borderRadius: BorderRadius.circular(width * 0.04),

      // هذا هو الجزء الذي يفتح التفاصيل
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
            // رقم الشدة
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

            // اسم العرض والتاريخ
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

            // السهم
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

  // =========================================================
  // TRIANGLE BOTTOM NAVIGATION
  // =========================================================

  Widget _bottomNavigation(double width) {
    return SizedBox(
      height: 125,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // ================= BAR + TRIANGLE =================
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipPath(
              clipper: TriangleNavigationClipper(),
              child: Container(
                height: 115,
                color: cardColor,
              ),
            ),
          ),

          // ================= NAV ITEMS =================
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 88,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(
                  icon: Icons.home_rounded,
                  label: 'الرئيسية',
                  index: 0,
                ),

                _navItem(
                  icon: Icons.article_rounded,
                  label: 'السجل',
                  index: 1,
                ),

                SizedBox(width: width * 0.18),

                _navItem(
                  icon: Icons.bar_chart_rounded,
                  label: 'التقرير',
                  index: 3,
                ),

                _navItem(
                  icon: Icons.person_outline_rounded,
                  label: 'حسابي',
                  index: 4,
                ),
              ],
            ),
          ),

          // ================= PLUS =================
          Positioned(
            top: 4,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const AddConditionScreen(),
                  ),
                );
              },
              child: Container(
                width: width * 0.18,
                height: width * 0.18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: homePrimaryColor,
                  border: Border.all(
                    color: whiteColor,
                    width: 5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.add_rounded,
                  color: whiteColor,
                  size: width * 0.10,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // NAV ITEM
  // =========================================================

  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final bool isSelected = selectedIndex == index;

  return GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () {
      // الرئيسية
      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
        return;
      }

      // السجل
      if (index == 1) {
      return;
        }
      
      

      // التقرير 
      if (index == 3) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => const ReportScreen(),
    ),
  );
  return;
}
      //وحسابي حالياً فقط تغيير التحديد
      setState(() {
        selectedIndex = index;
      });
    },
    child: SizedBox(
      width: 65,
      height: 70,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: isSelected
                  ? homeLightBlueColor
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              size: 27,
              color: isSelected
                  ? homePrimaryColor
                  : homeDarkTextColor,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            label,
            maxLines: 1,
            style: TextStyle(
              fontFamily: thmanyahFont,
              fontSize: 11,
              fontWeight: isSelected
                  ? FontWeight.bold
                  : FontWeight.w500,
              color: isSelected
                  ? homePrimaryColor
                  : homeDarkTextColor,
            ),
          ),
        ],
      ),
    ),
  );
}
}

// ===========================================================
// TRIANGLE BOTTOM NAVIGATION SHAPE ▲
// ===========================================================

class TriangleNavigationClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(0, 40);

    // قبل المثلث
    path.lineTo(
      size.width * 0.36,
      40,
    );

    // ▲ رأس المثلث للأعلى
    path.lineTo(
      size.width * 0.50,
      0,
    );

    // بعد المثلث
    path.lineTo(
      size.width * 0.64,
      40,
    );

    path.lineTo(
      size.width,
      40,
    );

    path.lineTo(
      size.width,
      size.height,
    );

    path.lineTo(
      0,
      size.height,
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(
    covariant CustomClipper<Path> oldClipper,
  ) {
    return false;
  }
}