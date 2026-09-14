import 'package:flutter/material.dart';
import 'package:final_project/screens/add_condition_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFEAF4FC),

        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.055,
              vertical: height * 0.018,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Profile
                    Container(
                      width: width * 0.16,
                      height: width * 0.16,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFFD8D8D8),
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 42,
                        color: Color(0xFF263B55),
                      ),
                    ),

                    SizedBox(width: width * 0.035),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "مرحباً،",
                            style: TextStyle(
                              fontSize: width * 0.055,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF122B4A),
                            ),
                          ),
                          Text(
                            "سلمى",
                            style: TextStyle(
                              fontSize: width * 0.07,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF102A49),
                            ),
                          ),
                          SizedBox(height: height * 0.005),
                          Text(
                            "كيف حالك اليوم؟",
                            style: TextStyle(
                              fontSize: width * 0.042,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF456889),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: width * 0.02),

                    _headerButton(
                      icon: Icons.notifications_none_rounded,
                      width: width,
                    ),
                  ],
                ),

                SizedBox(height: height * 0.025),

                // سجل أعراضك اليوم
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: width * 0.04,
                    vertical: height * 0.02,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFC7F1E5),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: const Color(0xFF73D4BE),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: width * 0.16,
                        height: width * 0.16,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFFF9DDA),
                        ),
                        child: Icon(
                          Icons.favorite_rounded,
                          color: const Color(0xFF182F4D),
                          size: width * 0.085,
                        ),
                      ),

                      SizedBox(width: width * 0.035),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "سجل أعراضك اليوم",
                              style: TextStyle(
                                fontSize: width * 0.052,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF102B4B),
                              ),
                            ),
                            SizedBox(height: height * 0.006),
                            Text(
                              "خطوة صغيرة نحو صحة أفضل",
                              style: TextStyle(
                                fontSize: width * 0.037,
                                color: const Color(0xFF426785),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: width * 0.055,
                        color: const Color(0xFF163452),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.025),

                Row(
                  children: [
                    Expanded(
                      child: _featureCard(
                        context: context,
                        title: "سجل الأعراض\nاليومية",
                        icon: Icons.thermostat_rounded,
                        color: const Color(0xFFFFD5E9),
                        iconColor: const Color(0xFF163452),
                      ),
                    ),

                    SizedBox(width: width * 0.035),

                    Expanded(
                      child: _featureCard(
                        context: context,
                        title: "عرض\nالتقارير",
                        icon: Icons.bar_chart_rounded,
                        color: const Color(0xFFE0D5FF),
                        iconColor: const Color(0xFF163452),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: height * 0.018),

                Row(
                  children: [
                    Expanded(
                      child: _featureCard(
                        context: context,
                        title: "الجدول الزمني",
                        icon: Icons.calendar_month_outlined,
                        color: const Color(0xFFFFE8B4),
                        iconColor: const Color(0xFF163452),
                      ),
                    ),

                    SizedBox(width: width * 0.035),

                    Expanded(
                      child: _featureCard(
                        context: context,
                        title: "مشاركة مع الطبيب",
                        icon: Icons.person_outline_rounded,
                        color: const Color(0xFFC9F1E5),
                        iconColor: const Color(0xFF163452),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: height * 0.035),

                Text(
                  "أحدث الإدخالات",
                  style: TextStyle(
                    fontSize: width * 0.06,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF102B4B),
                  ),
                ),

                SizedBox(height: height * 0.015),

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      _recentItem(
                        context: context,
                        title: "صداع + تعب",
                        date: "14 مايو 2025",
                        icon: Icons.sentiment_dissatisfied_rounded,
                        color: const Color(0xFFFFC4E3),
                      ),

                      _divider(),

                      _recentItem(
                        context: context,
                        title: "ألم المعدة",
                        date: "13 مايو 2025",
                        icon: Icons.sentiment_neutral_rounded,
                        color: const Color(0xFFC5EDE2),
                      ),

                      _divider(),

                      _recentItem(
                        context: context,
                        title: "تحسين عام",
                        date: "12 مايو 2025",
                        icon: Icons.sentiment_satisfied_alt_rounded,
                        color: const Color(0xFFFFE1A0),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.03),
              ],
            ),
          ),
        ),

        bottomNavigationBar: _bottomNavigation(width),
      ),
    );
  }

  Widget _headerButton({required IconData icon, required double width}) {
    return Container(
      width: width * 0.125,
      height: width * 0.125,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFD7E5F2)),
      ),
      child: Icon(icon, color: const Color(0xFF122E4D), size: width * 0.065),
    );
  }

  Widget _featureCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required Color iconColor,
  }) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Container(
      height: height * 0.19,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: iconColor.withOpacity(0.12), width: 1.5),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: width * 0.095, color: iconColor),

          SizedBox(height: height * 0.015),

          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: width * 0.042,
              height: 1.35,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF173554),
            ),
          ),
        ],
      ),
    );
  }

  Widget _recentItem({
    required BuildContext context,
    required String title,
    required String date,
    required IconData icon,
    required Color color,
  }) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.018,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: width * 0.043,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF183755),
                  ),
                ),
                SizedBox(height: height * 0.005),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: width * 0.035,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF58718A),
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: width * 0.14,
            height: width * 0.14,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(
              icon,
              size: width * 0.075,
              color: const Color(0xFF173554),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return const Divider(
      height: 1,
      indent: 20,
      endIndent: 20,
      color: Color(0xFFDCE7EF),
    );
  }

  Widget _bottomNavigation(double width) {
    return Container(
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _navItem(icon: Icons.home_rounded, label: "", index: 0),

                _navItem(
                  icon: Icons.favorite_border_rounded,
                  label: "",
                  index: 1,
                ),

                const SizedBox(width: 70),

                _navItem(icon: Icons.bar_chart_rounded, label: "", index: 3),

                _navItem(
                  icon: Icons.person_outline_rounded,
                  label: "",
                  index: 4,
                ),
              ],
            ),
          ),

          // زر إضافة حالة
          Positioned(
            top: -25,
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddConditionScreen(),
                  ),
                );
              },
              child: Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF2366B1),
                  border: Border.all(color: const Color(0xFFEAF4FC), width: 6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 38,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: SizedBox(
        width: 55,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 27,
              color: isSelected
                  ? const Color(0xFF2366B1)
                  : const Color(0xFF9AAEC0),
            ),

            const SizedBox(height: 3),

            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 9,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? const Color(0xFF2366B1)
                    : const Color(0xFF71869A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
