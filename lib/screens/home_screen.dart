import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:final_project/constants/colors.dart';
import 'package:final_project/constants/fonts.dart';
import 'package:final_project/utils/screen_size.dart';

import 'package:final_project/screens/history_screen.dart';
import 'package:final_project/screens/appointment_screen.dart';
import 'package:final_project/screens/profile_screen.dart';
import 'package:final_project/widgets/custom_bottom_navigation.dart';
import 'package:final_project/screens/notifications_screen.dart';
import 'package:final_project/services/notification_service.dart';
import 'package:final_project/screens/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime? nextAppointment;
  String? appointmentClinic;
  String? appointmentDoctor;
  List<Map<String, dynamic>> symptoms = [];
  bool get isGuest => Supabase.instance.client.auth.currentUser == null;

  bool isLoading = true;
  bool hasUnreadNotification = false;
  String formatAppointmentDate(DateTime date) {
    const months = [
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

    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _goToLogin() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _showLoginRequired() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            backgroundColor: cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: const Text(
              'تسجيل الدخول مطلوب',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: thmanyahFont,
                fontWeight: FontWeight.w700,
                color: homeDarkTextColor,
              ),
            ),
            content: const Text(
              'سجّل الدخول أولاً لاستخدام هذه الميزة.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: thmanyahFont,
                color: homeDarkTextColor,
              ),
            ),
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                },
                child: const Text(
                  'إلغاء',
                  style: TextStyle(
                    fontFamily: thmanyahFont,
                    fontWeight: FontWeight.w600,
                    color: homeDarkTextColor,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  _goToLogin();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: homePrimaryColor,
                  foregroundColor: whiteColor,
                ),
                child: const Text(
                  'تسجيل الدخول',
                  style: TextStyle(
                    fontFamily: thmanyahFont,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // =========================================================
  // INIT
  // =========================================================
  Future<void> fetchAppointment() async {
    final user = Supabase.instance.client.auth.currentUser;

    if (user == null) return;

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
          nextAppointment = DateTime.parse(data['appointment_date']).toLocal();

          appointmentClinic = data['clinic_name'];
          appointmentDoctor = data['doctor_name'];
        });
      }
    } catch (error) {
      debugPrint('Error loading appointment: $error');
    }
  }

  @override
  void initState() {
    super.initState();

    fetchSymptoms();
    if (!isGuest) {
      fetchAppointment();
      checkNotification();
    }
  }

  Future<void> checkNotification() async {
    final unread = await NotificationService.hasUnreadNotification();

    if (!mounted) return;

    setState(() {
      hasUnreadNotification = unread;
    });
  }

  // =========================================================
  // FETCH CURRENT USER SYMPTOMS
  // =========================================================

  Future<void> fetchSymptoms() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;

      if (user == null) {
        if (!mounted) return;

        setState(() {
          symptoms = [];
          isLoading = false;
        });

        return;
      }

      final response = await Supabase.instance.client
          .from('symptoms')
          .select()
          .eq('user_id', user.id)
          .order('symptom_date', ascending: false);

      if (!mounted) return;

      setState(() {
        symptoms = List<Map<String, dynamic>>.from(response);

        isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;

      setState(() {
        symptoms = [];
        isLoading = false;
      });
    }
  }

  // =========================================================
  // TOTAL SYMPTOMS
  // =========================================================

  int get totalSymptoms {
    return symptoms.length;
  }

  // =========================================================
  // AVERAGE SEVERITY
  // =========================================================

  double get averageSeverity {
    if (symptoms.isEmpty) {
      return 0;
    }

    double total = 0;

    for (final symptom in symptoms) {
      final severity = double.tryParse(symptom['severity'].toString()) ?? 0;

      total += severity;
    }

    return total / symptoms.length;
  }

  // =========================================================
  // THIS MONTH SYMPTOMS
  // =========================================================

  int get thisMonthSymptoms {
    final now = DateTime.now();

    return symptoms.where((symptom) {
      final date = DateTime.tryParse(symptom['symptom_date'].toString());

      if (date == null) {
        return false;
      }

      return date.year == now.year && date.month == now.month;
    }).length;
  }

  // =========================================================
  // LATEST SYMPTOMS
  // =========================================================

  List<Map<String, dynamic>> get latestSymptoms {
    if (symptoms.length <= 4) {
      return symptoms;
    }

    return symptoms.take(4).toList();
  }

  // =========================================================
  // FORMAT DATE
  // =========================================================

  String formatArabicDate(dynamic value) {
    if (value == null) {
      return '';
    }

    final date = DateTime.tryParse(value.toString());

    if (date == null) {
      return '';
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
  // SYMPTOM ICON
  // =========================================================

  IconData getSymptomIcon(String condition) {
    if (condition.contains('صداع')) {
      return Icons.psychology_alt_outlined;
    }

    if (condition.contains('معدة') || condition.contains('غثيان')) {
      return Icons.sick_outlined;
    }

    if (condition.contains('تنفس')) {
      return Icons.air_rounded;
    }

    if (condition.contains('ظهر')) {
      return Icons.accessibility_new_rounded;
    }

    if (condition.contains('حرارة')) {
      return Icons.thermostat_rounded;
    }

    if (condition.contains('دوخة')) {
      return Icons.blur_circular_rounded;
    }

    return Icons.health_and_safety_outlined;
  }

  // =========================================================
  // BUILD
  // =========================================================

  @override
  Widget build(BuildContext context) {
    final width = screenWidth(context);
    final height = screenHeight(context);

    final user = Supabase.instance.client.auth.currentUser;

    final String name = user == null
        ? 'زائر'
        : user.userMetadata?['name']?.toString() ?? 'المستخدم';

    // صورة البروفايل المختارة من صفحة حسابي
    final String profileImage =
        user?.userMetadata?['profile_image']?.toString() ??
        'assets/default.png';

    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(context).textTheme.apply(fontFamily: thmanyahFont),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: backgroundColor,

          // =====================================================
          // BODY
          // =====================================================
          body: SafeArea(
            bottom: false,
            child: RefreshIndicator(
              onRefresh: fetchSymptoms,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.055,
                  vertical: height * 0.02,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // =================================================
                    // HEADER
                    // =================================================

                    Row(
                      children: [
                        // =================================================
                        // PROFILE IMAGE
                        // =================================================
                        GestureDetector(
                          onTap: () {
                            if (isGuest) {
                              _showLoginRequired();
                              return;
                            }
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ProfileScreen(),
                              ),
                            );
                          },
                          child: Container(
                            width: width * 0.13,
                            height: width * 0.13,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: whiteColor, width: 2),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                profileImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: width * 0.03),

                        // =================================================
                        // GREETING
                        // =================================================
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'مرحباً بك $name',
                                style: TextStyle(
                                  fontFamily: thmanyahFont,
                                  fontSize: width * 0.043,
                                  fontWeight: FontWeight.w600,
                                  color: whiteColor,
                                ),
                              ),

                              Text(
                                'كيف حالتك اليوم؟',
                                style: TextStyle(
                                  fontFamily: thmanyahFont,
                                  fontSize: width * 0.055,
                                  fontWeight: FontWeight.w700,
                                  color: whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // =================================================
                        // NOTIFICATION
                        // =================================================
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            customBorder: const CircleBorder(),

                            onTap: () async {
                              if (isGuest) {
                                _showLoginRequired();
                                return;
                              }
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationsScreen(),
                                ),
                              );

                              // عندما يرجع المستخدم للـ Home
                              // نتحقق مرة ثانية
                              await checkNotification();
                            },

                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  width: width * 0.13,
                                  height: width * 0.13,
                                  decoration: BoxDecoration(
                                    color: lightBlueColor,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: whiteColor,
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.notifications_none_rounded,
                                    color: homeDarkTextColor,
                                    size: width * 0.065,
                                  ),
                                ),

                                // النقطة الحمراء تظهر فقط
                                // إذا إشعار اليوم غير مقروء
                                if (hasUnreadNotification)
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      width: width * 0.035,
                                      height: width * 0.035,
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: whiteColor,
                                          width: 2,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: height * 0.025),

                    // =================================================
                    // APPOINTMENT CARD
                    // =================================================
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          if (isGuest) {
                            _showLoginRequired();
                            return;
                          }
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AppointmentScreen(),
                            ),
                          );

                          await fetchAppointment();
                        },
                        borderRadius: BorderRadius.circular(width * 0.05),
                        child: Container(
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
                            children: [
                              Container(
                                width: width * 0.13,
                                height: width * 0.13,
                                decoration: const BoxDecoration(
                                  color: homePurpleColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.calendar_month_outlined,
                                  color: homeDarkTextColor,
                                  size: width * 0.065,
                                ),
                              ),

                              SizedBox(width: width * 0.035),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'موعدك القادم',
                                      style: TextStyle(
                                        fontFamily: thmanyahFont,
                                        fontSize: width * 0.043,
                                        fontWeight: FontWeight.w700,
                                        color: homeDarkTextColor,
                                      ),
                                    ),

                                    SizedBox(height: height * 0.004),

                                    Text(
                                      isGuest
                                          ? 'سجّل الدخول لعرض موعدك'
                                          : appointmentClinic?.isNotEmpty ==
                                                true
                                          ? appointmentClinic!
                                          : 'متابعة صحية',
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

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    isGuest
                                        ? ''
                                        : nextAppointment != null
                                        ? formatAppointmentDate(
                                            nextAppointment!,
                                          )
                                        : 'لا يوجد موعد',
                                    style: TextStyle(
                                      fontFamily: thmanyahFont,
                                      fontSize: width * 0.034,
                                      fontWeight: FontWeight.w600,
                                      color: homeDarkTextColor,
                                    ),
                                  ),

                                  SizedBox(height: height * 0.004),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.025),

                    // =================================================
                    // STATISTICS
                    // =================================================
                    if (isLoading)
                      const Center(
                        child: CircularProgressIndicator(
                          color: homePrimaryColor,
                        ),
                      )
                    else
                      Row(
                        children: [
                          Expanded(
                            child: _statCard(
                              width: width,
                              height: height,
                              icon: Icons.favorite_border_rounded,
                              number: isGuest ? '—' : totalSymptoms.toString(),
                              title: 'أعراض مسجلة',
                              color: homePinkColor,
                            ),
                          ),

                          SizedBox(width: width * 0.025),

                          Expanded(
                            child: _statCard(
                              width: width,
                              height: height,
                              icon: Icons.show_chart_rounded,
                              number: isGuest
                                  ? '—'
                                  : averageSeverity.toStringAsFixed(1),
                              title: 'متوسط الشدة',
                              color: homeGreenColor,
                            ),
                          ),

                          SizedBox(width: width * 0.025),

                          Expanded(
                            child: _statCard(
                              width: width,
                              height: height,
                              icon: Icons.calendar_today_outlined,
                              number: isGuest
                                  ? '—'
                                  : thisMonthSymptoms.toString(),
                              title: 'هذا الشهر',
                              color: homePurpleColor,
                            ),
                          ),
                        ],
                      ),

                    SizedBox(height: height * 0.035),

                    // =================================================
                    // LATEST SYMPTOMS TITLE
                    // =================================================
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'آخر الأعراض',
                          style: TextStyle(
                            fontFamily: thmanyahFont,
                            fontSize: width * 0.055,
                            fontWeight: FontWeight.w700,
                            color: whiteColor,
                          ),
                        ),

                        InkWell(
                          onTap: () {
                            if (isGuest) {
                              _showLoginRequired();
                              return;
                            }

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HistoryScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'عرض الكل',
                            style: TextStyle(
                              fontFamily: thmanyahFont,
                              fontSize: width * 0.037,
                              fontWeight: FontWeight.w600,
                              color: whiteColor,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: height * 0.015),

                    // =================================================
                    // LATEST SYMPTOMS
                    // =================================================
                    if (isGuest)
                      _guestLoginCard(width, height)
                    else if (isLoading)
                      const SizedBox.shrink()
                    else if (latestSymptoms.isEmpty)
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: height * 0.035,
                          horizontal: width * 0.04,
                        ),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(width * 0.04),
                          border: Border.all(color: homeBorderColor),
                        ),
                        child: Text(
                          'لا توجد أعراض مسجلة',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: thmanyahFont,
                            fontSize: width * 0.04,
                            fontWeight: FontWeight.w600,
                            color: homeDarkTextColor,
                          ),
                        ),
                      )
                    else
                      ...List.generate(latestSymptoms.length, (index) {
                        final symptom = latestSymptoms[index];

                        final title = (symptom['condition_name'] ?? 'غير محدد')
                            .toString();

                        final severity =
                            int.tryParse(symptom['severity'].toString()) ?? 1;

                        final date = formatArabicDate(symptom['symptom_date']);

                        return Padding(
                          padding: EdgeInsets.only(bottom: height * 0.012),
                          child: _symptomCard(
                            width: width,
                            height: height,
                            title: title,
                            date: date,
                            severity: severity.toString(),
                            color: getSeverityColor(severity),
                            icon: getSymptomIcon(title),
                          ),
                        );
                      }),

                    SizedBox(height: height * 0.025),
                  ],
                ),
              ),
            ),
          ),

          // =====================================================
          // CUSTOM BOTTOM NAVIGATION
          // =====================================================
          bottomNavigationBar: const CustomBottomNavigation(selectedIndex: 0),
        ),
      ),
    );
  }

  Widget _guestLoginCard(double width, double height) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.05,
        vertical: height * 0.03,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(width * 0.04),
        border: Border.all(color: homeBorderColor),
      ),
      child: Column(
        children: [
          Container(
            width: width * 0.15,
            height: width * 0.15,
            decoration: const BoxDecoration(
              color: homeLightBlueColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_outline_rounded,
              color: homeDarkTextColor,
              size: width * 0.07,
            ),
          ),

          SizedBox(height: height * 0.015),

          Text(
            'سجّل الدخول لعرض بياناتك',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: thmanyahFont,
              fontSize: width * 0.043,
              fontWeight: FontWeight.w700,
              color: homeDarkTextColor,
            ),
          ),

          SizedBox(height: height * 0.006),

          Text(
            'تابع أعراضك ومواعيدك وتقاريرك الصحية بعد تسجيل الدخول.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: thmanyahFont,
              fontSize: width * 0.033,
              color: homeGreyColor,
            ),
          ),

          SizedBox(height: height * 0.018),

          ElevatedButton(
            onPressed: _goToLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: homePrimaryColor,
              foregroundColor: whiteColor,
              elevation: 0,
              padding: EdgeInsets.symmetric(
                horizontal: width * 0.08,
                vertical: height * 0.012,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(width * 0.035),
              ),
            ),
            child: Text(
              'تسجيل الدخول',
              style: TextStyle(
                fontFamily: thmanyahFont,
                fontSize: width * 0.037,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
  // =============================================================
  // STAT CARD
  // =============================================================

  Widget _statCard({
    required double width,
    required double height,
    required IconData icon,
    required String number,
    required String title,
    required Color color,
  }) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = constraints.maxWidth;

        final cardHeight = (cardWidth * 0.95).clamp(120.0, 155.0);

        final iconSize = (cardWidth * 0.22).clamp(22.0, 30.0);

        final numberSize = (cardWidth * 0.27).clamp(25.0, 36.0);

        final titleSize = (cardWidth * 0.14).clamp(13.0, 17.0);

        return Container(
          height: cardHeight,
          padding: EdgeInsets.symmetric(
            horizontal: cardWidth * 0.06,
            vertical: cardHeight * 0.08,
          ),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(
              (cardWidth * 0.16).clamp(18.0, 28.0),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: homeDarkTextColor, size: iconSize),

              SizedBox(height: cardHeight * 0.025),

              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    number,
                    maxLines: 1,
                    style: TextStyle(
                      fontFamily: thmanyahFont,
                      fontSize: numberSize,
                      fontWeight: FontWeight.w700,
                      color: homeDarkTextColor,
                      height: 1,
                    ),
                  ),
                ),
              ),

              SizedBox(height: cardHeight * 0.035),

              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: thmanyahFont,
                      fontSize: titleSize,
                      fontWeight: FontWeight.w600,
                      color: homeDarkTextColor,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  // =============================================================
  // SYMPTOM CARD
  // =============================================================

  Widget _symptomCard({
    required double width,
    required double height,
    required String title,
    required String date,
    required String severity,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.04,
        vertical: height * 0.016,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(width * 0.04),
        border: Border.all(color: homeBorderColor),
      ),
      child: Row(
        children: [
          Container(
            width: width * 0.12,
            height: width * 0.12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: homeDarkTextColor, size: width * 0.06),
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
                    fontSize: width * 0.045,
                    fontWeight: FontWeight.w700,
                    color: homeDarkTextColor,
                  ),
                ),

                SizedBox(height: height * 0.003),

                Text(
                  date,
                  style: TextStyle(
                    fontFamily: thmanyahFont,
                    fontSize: width * 0.034,
                    fontWeight: FontWeight.w500,
                    color: homeDarkTextColor,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: width * 0.105,
            height: width * 0.105,
            alignment: Alignment.center,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Text(
              severity,
              style: TextStyle(
                fontFamily: thmanyahFont,
                fontSize: width * 0.045,
                fontWeight: FontWeight.w700,
                color: homeDarkTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
