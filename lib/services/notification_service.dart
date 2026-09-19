import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  // =========================================================
  // INITIALIZE
  // =========================================================

  static Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(
      android: androidSettings,
    );

    await notifications.initialize(
      settings: settings,
    );

    await notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  // =========================================================
  // DAILY NOTIFICATION - 8:00 PM
  // =========================================================

  static Future<void> scheduleDailyNotification() async {
    final now = tz.TZDateTime.now(tz.local);

    var scheduledTime = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      20,
      0,
    );

    // إذا عدت الساعة 8 اليوم، جدول إشعار بكرة
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(
        const Duration(days: 1),
      );
    }

    await notifications.zonedSchedule(
      id: 1,

      // فقط النص المطلوب
      title: 'كيف حالتك اليوم؟',
      body: null,

      scheduledDate: scheduledTime,

      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_health_reminder',
          'التذكير اليومي',
          channelDescription:
              'تذكير يومي لتسجيل الحالة الصحية',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),

      androidScheduleMode:
          AndroidScheduleMode.inexactAllowWhileIdle,

      matchDateTimeComponents:
          DateTimeComponents.time,

      payload: 'daily_check',
    );
  }

  // =========================================================
  // CHECK IF TODAY'S NOTIFICATION IS UNREAD
  // =========================================================

  static Future<bool> hasUnreadNotification() async {
    final now = DateTime.now();

    // قبل الساعة 8 لا يوجد إشعار اليوم
    if (now.hour < 20) {
      return false;
    }

    final prefs = await SharedPreferences.getInstance();

    final lastReadDate =
        prefs.getString('last_notification_read_date');

    final today = _dateKey(now);

    // إذا لم تتم قراءة إشعار اليوم
    return lastReadDate != today;
  }

  // =========================================================
  // MARK TODAY AS READ
  // =========================================================

  static Future<void> markTodayAsRead() async {
    final prefs = await SharedPreferences.getInstance();

    final today = _dateKey(DateTime.now());

    await prefs.setString(
      'last_notification_read_date',
      today,
    );
  }

  // =========================================================
  // DATE KEY
  // =========================================================

  static String _dateKey(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }
}