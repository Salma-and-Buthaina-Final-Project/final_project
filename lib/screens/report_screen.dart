import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:final_project/constants/colors.dart';
import 'package:final_project/constants/fonts.dart';
import 'package:final_project/utils/screen_size.dart';
import 'package:final_project/widgets/custom_bottom_navigation.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart';
import 'dart:html' as html;

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  List<Map<String, dynamic>> records = [];
  List<Map<String, dynamic>> symptoms = [];
  List<String> medicines = [];

  bool isLoading = true;
  String? errorMessage;

  String? aiSummary;
  bool isGeneratingAi = false;

  int symptomTypesCount = 0;
  int repeatedCount = 0;
  double averageSeverity = 0;

  DateTime? firstDate;
  DateTime? lastDate;
  DateTime? selectedFromDate;
DateTime? selectedToDate;

  @override
  void initState() {
    super.initState();
    fetchReportData();
   
  }

  // =========================================================
  // GET DATA FROM SUPABASE
  // =========================================================

Future<void> selectFromDate() async {
  final picked = await showDatePicker(
    context: context,
    initialDate: selectedFromDate ?? DateTime.now(),
    firstDate: DateTime(2020),
    lastDate: DateTime.now(),
  );

  if (picked != null) {
    setState(() {
      selectedFromDate = picked;

      if (selectedToDate != null &&
          selectedToDate!.isBefore(picked)) {
        selectedToDate = null;
      }
    });
  }
}

Future<void> selectToDate() async {
  final picked = await showDatePicker(
    context: context,
    initialDate:
        selectedToDate ?? selectedFromDate ?? DateTime.now(),
    firstDate: selectedFromDate ?? DateTime(2020),
    lastDate: DateTime.now(),
  );

  if (picked != null) {
    setState(() {
      selectedToDate = picked;
    });
  }
}

  Future<void> fetchReportData() async {
  try {
    setState(() {
      isLoading = true;
      errorMessage = null;
      aiSummary = null;
    });

    var query = Supabase.instance.client
        .from('symptoms')
        .select();

    if (selectedFromDate != null) {
      final from = DateTime(
        selectedFromDate!.year,
        selectedFromDate!.month,
        selectedFromDate!.day,
      );

      query = query.gte(
        'symptom_date',
        from.toIso8601String(),
      );
    }

    if (selectedToDate != null) {
      // بداية اليوم التالي، حتى ندخل كامل اليوم المختار.
      final nextDay = DateTime(
        selectedToDate!.year,
        selectedToDate!.month,
        selectedToDate!.day + 1,
      );

      query = query.lt(
        'symptom_date',
        nextDay.toIso8601String(),
      );
    }

    final response = await query.order(
      'symptom_date',
      ascending: true,
    );

    final data =
        List<Map<String, dynamic>>.from(response);

    _buildReport(data);

    if (!mounted) return;

    setState(() {
      records = data;
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
Future<void> generateAiSummary() async {
  if (records.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('لا توجد بيانات لتحليلها'),
      ),
    );
    return;
  }

  final apiKey = dotenv.env['GEMINI_API_KEY'];

  if (apiKey == null || apiKey.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gemini API Key غير موجود'),
      ),
    );
    return;
  }

  setState(() {
    isGeneratingAi = true;
    aiSummary = null;
  });

  try {
    // نرسل فقط المعلومات التي يحتاجها التقرير
    final cleanRecords = records.map((record) {
      return {
        'condition_name': record['condition_name'],
        'location': record['location'],
        'severity': record['severity'],
        'is_repeated': record['is_repeated'],
        'took_medicine': record['took_medicine'],
        'medicine_name': record['medicine_name'],
        'symptom_date': record['symptom_date'],
        'notes': record['notes'],
      };
    }).toList();

    final prompt = '''
أنت مساعد يقوم بتلخيص سجلات الأعراض الصحية للمستخدم.

قم بكتابة ملخص عربي واضح ومختصر للسجلات التالية.

التعليمات:
- لا تقدم تشخيصاً طبياً.
- لا تقترح أن المستخدم مصاب بمرض معين.
- لا تخترع أي معلومات غير موجودة في السجلات.
- اذكر الأعراض الأكثر تكراراً.
- صف شدة الأعراض بشكل عام.
- اذكر الحالات المتكررة إن وجدت.
- اذكر الأدوية المسجلة فقط إن وجدت.
- اذكر الأنماط الزمنية فقط إذا كانت واضحة من البيانات.
- اجعل النص مناسباً لإضافته إلى تقرير صحي يمكن عرضه على الطبيب.
- استخدم لغة عربية واضحة ومهنية.
- اجعل الملخص فقرة قصيرة وليس قائمة.

السجلات:
${jsonEncode(cleanRecords)}
''';

   final url = Uri.parse(
  'https://generativelanguage.googleapis.com/v1beta/models/'
  'gemini-3.6-flash:generateContent',
);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'x-goog-api-key': apiKey,
      },
      body: jsonEncode({
        'contents': [
          {
            'parts': [
              {
                'text': prompt,
              },
            ],
          },
        ],
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
        'Gemini Error ${response.statusCode}: ${response.body}',
      );
    }

    final data = jsonDecode(response.body);

    final candidates = data['candidates'];

    if (candidates == null || candidates.isEmpty) {
      throw Exception('لم يتم إنشاء ملخص');
    }

    final summary =
        candidates[0]['content']['parts'][0]['text'].toString();

    if (!mounted) return;

    setState(() {
      aiSummary = summary;
      isGeneratingAi = false;
    });
  } catch (error) {
    if (!mounted) return;

    setState(() {
      isGeneratingAi = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'حدث خطأ أثناء إنشاء الملخص: $error',
        ),
      ),
    );
  }
}
  // =========================================================
  // BUILD REPORT FROM REAL DATA
  // =========================================================

  void _buildReport(List<Map<String, dynamic>> data) {
    if (data.isEmpty) {
      symptoms = [];
      medicines = [];
      symptomTypesCount = 0;
      repeatedCount = 0;
      averageSeverity = 0;
      firstDate = null;
      lastDate = null;
      return;
    }

    // =====================================================
    // SYMPTOM COUNTS
    // =====================================================

    final Map<String, int> counts = {};

    for (final record in data) {
      final name =
          (record['condition_name'] ?? 'غير محدد').toString();

      counts[name] = (counts[name] ?? 0) + 1;
    }

    symptomTypesCount = counts.length;

    final int maxCount = counts.values.reduce(
      (a, b) => a > b ? a : b,
    );

    final sortedEntries = counts.entries.toList()
      ..sort(
        (a, b) => b.value.compareTo(a.value),
      );

    symptoms = sortedEntries.map((entry) {
      return <String, dynamic>{
        'title': entry.key,
        'count': entry.value,
        'progress': maxCount == 0
            ? 0.0
            : entry.value / maxCount,
        'color': _getSymptomColor(entry.key),
        'icon': _getSymptomIcon(entry.key),
      };
    }).toList();

    // =====================================================
    // AVERAGE SEVERITY
    // =====================================================

    double severityTotal = 0;

    for (final record in data) {
      severityTotal +=
          double.tryParse(
            record['severity'].toString(),
          ) ??
          0;
    }

    averageSeverity = severityTotal / data.length;

    // =====================================================
    // REPEATED CASES
    // =====================================================

    repeatedCount = data.where((record) {
      return record['is_repeated'] == true;
    }).length;

    // =====================================================
    // MEDICINES
    // فقط الأدوية المكتوبة فعلاً
    // =====================================================

    final Set<String> medicineSet = {};

    for (final record in data) {
      final medicine =
          record['medicine_name']?.toString().trim();

      if (medicine != null && medicine.isNotEmpty) {
        medicineSet.add(medicine);
      }
    }

    medicines = medicineSet.toList();

    // =====================================================
    // DATE RANGE
    // =====================================================

    final dates = data
        .map(
          (record) => DateTime.tryParse(
            record['symptom_date'].toString(),
          ),
        )
        .whereType<DateTime>()
        .toList();

    if (dates.isNotEmpty) {
      dates.sort();

      firstDate = dates.first;
      lastDate = dates.last;
    }
  }

  // =========================================================
  // DATE
  // =========================================================

  String _formatArabicDate(DateTime date) {
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

  String get dateRangeText {
    if (firstDate == null || lastDate == null) {
      return 'لا توجد بيانات';
    }

    return '${_formatArabicDate(firstDate!)} - ${_formatArabicDate(lastDate!)}';
  }

  // =========================================================
  // SYMPTOM ICON
  // =========================================================

  IconData _getSymptomIcon(String title) {
    switch (title) {
      case 'صداع':
        return Icons.psychology_alt_outlined;

      case 'ألم في المعدة':
        return Icons.sick_outlined;

      case 'غثيان':
        return Icons.sentiment_dissatisfied_outlined;

      case 'ألم في الظهر':
        return Icons.accessibility_new_rounded;

      case 'ضيق تنفس':
        return Icons.air_rounded;

      case 'دوخة':
        return Icons.blur_circular_rounded;

      case 'ارتفاع حرارة':
        return Icons.thermostat_rounded;

      case 'تعب عام':
        return Icons.battery_2_bar_rounded;

      default:
        return Icons.health_and_safety_outlined;
    }
  }

  // =========================================================
  // SYMPTOM COLOR
  // =========================================================

  Color _getSymptomColor(String title) {
    switch (title) {
      case 'صداع':
        return homePinkColor;

      case 'ألم في المعدة':
        return homePurpleColor;

      case 'غثيان':
        return homeLightBlueColor;

      case 'ألم في الظهر':
        return homeYellowColor;

      case 'ضيق تنفس':
        return homeGreenColor;

      default:
        return homeLightBlueColor;
    }
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
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: thmanyahFont,
        ),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: backgroundColor,

          body: SafeArea(
            bottom: false,
            child: RefreshIndicator(
              onRefresh: fetchReportData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.only(
                  right: width * 0.055,
                  left: width * 0.055,
                  top: height * 0.025,
                  bottom: height * 0.03,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // =============================================
                    // TITLE
                    // =============================================

                    Center(
                      child: Text(
                        'التقرير الصحي',
                        style: TextStyle(
                          fontFamily: thmanyahFont,
                          fontSize: width * 0.07,
                          fontWeight: FontWeight.w700,
                          color: whiteColor,
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.025),
                    Container(
  padding: EdgeInsets.all(width * 0.04),
  decoration: BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(
      width * 0.04,
    ),
    border: Border.all(
      color: homeBorderColor,
    ),
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'حدد فترة التقرير',
        style: TextStyle(
          fontFamily: thmanyahFont,
          fontSize: width * 0.045,
          fontWeight: FontWeight.w700,
          color: homeDarkTextColor,
        ),
      ),

      SizedBox(height: height * 0.015),

      Row(
        children: [
          Expanded(
            child: _dateButton(
              width: width,
              title: 'من تاريخ',
              date: selectedFromDate,
              onTap: selectFromDate,
            ),
          ),

          SizedBox(width: width * 0.025),

          Expanded(
            child: _dateButton(
              width: width,
              title: 'إلى تاريخ',
              date: selectedToDate,
              onTap: selectToDate,
            ),
          ),
        ],
      ),

      SizedBox(height: height * 0.015),

      SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed:
              selectedFromDate != null &&
                      selectedToDate != null
                  ? fetchReportData
                  : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: homePrimaryColor,
            foregroundColor: whiteColor,
          ),
          icon: const Icon(
            Icons.filter_alt_outlined,
          ),
          label: Text(
            'إنشاء تقرير الفترة',
            style: TextStyle(
              fontFamily: thmanyahFont,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    ],
  ),
),

SizedBox(height: height * 0.025),

                    if (isLoading)
                      SizedBox(
                        height: height * 0.6,
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: homePrimaryColor,
                          ),
                        ),
                      )
                    else if (errorMessage != null)
                      _errorCard(width, height)
                    else if (records.isEmpty)
                      _emptyCard(width, height)
                    else ...[
                      // ===========================================
                      // DATE RANGE
                      // ===========================================

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.04,
                          vertical: height * 0.018,
                        ),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(
                            width * 0.04,
                          ),
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
                                color: homeLightBlueColor,
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
                                dateRangeText,
                                style: TextStyle(
                                  fontFamily: thmanyahFont,
                                  fontSize: width * 0.039,
                                  fontWeight: FontWeight.w600,
                                  color: homeDarkTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: height * 0.025),

                      // ===========================================
                      // STATISTICS
                      // ===========================================

                      Row(
                        children: [
                          Expanded(
                            child: _statCard(
                              width: width,
                              height: height,
                              number: '$symptomTypesCount',
                              title: 'أنواع الأعراض',
                              color: homePinkColor,
                            ),
                          ),

                          SizedBox(width: width * 0.025),

                          Expanded(
                            child: _statCard(
                              width: width,
                              height: height,
                              number:
                                  averageSeverity.toStringAsFixed(1),
                              title: 'متوسط الشدة',
                              color: homeGreenColor,
                            ),
                          ),

                          SizedBox(width: width * 0.025),

                          Expanded(
                            child: _statCard(
                              width: width,
                              height: height,
                              number: '$repeatedCount',
                              title: 'حالات متكررة',
                              color: homePurpleColor,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: height * 0.035),

                      // ===========================================
                      // MOST FREQUENT SYMPTOMS
                      // ===========================================

                      Text(
                        'أكثر الأعراض تكراراً',
                        style: TextStyle(
                          fontFamily: thmanyahFont,
                          fontSize: width * 0.055,
                          fontWeight: FontWeight.w700,
                          color: whiteColor,
                        ),
                      ),

                      SizedBox(height: height * 0.018),

                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: width * 0.04,
                          vertical: height * 0.02,
                        ),
                        decoration: BoxDecoration(
                          color: cardColor,
                          borderRadius: BorderRadius.circular(
                            width * 0.05,
                          ),
                          border: Border.all(
                            color: homeBorderColor,
                          ),
                        ),
                        child: Column(
                          children: List.generate(
                            symptoms.length,
                            (index) {
                              final symptom = symptoms[index];

                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom:
                                      index == symptoms.length - 1
                                      ? 0
                                      : height * 0.018,
                                ),
                                child: _symptomProgress(
                                  width: width,
                                  height: height,
                                  title: symptom['title'],
                                  count: symptom['count'],
                                  progress:
                                      (symptom['progress'] as num)
                                          .toDouble(),
                                  color: symptom['color'],
                                  icon: symptom['icon'],
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.035),

                      // ===========================================
                      // MEDICINES
                      // ===========================================

                      Text(
                        'الأدوية المستخدمة',
                        style: TextStyle(
                          fontFamily: thmanyahFont,
                          fontSize: width * 0.055,
                          fontWeight: FontWeight.w700,
                          color: whiteColor,
                        ),
                      ),

                      SizedBox(height: height * 0.015),

                      if (medicines.isEmpty)
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(
                            width * 0.04,
                          ),
                          decoration: BoxDecoration(
                            color: cardColor,
                            borderRadius: BorderRadius.circular(
                              width * 0.04,
                            ),
                            border: Border.all(
                              color: homeBorderColor,
                            ),
                          ),
                          child: Text(
                            'لم يتم تسجيل استخدام أدوية',
                            style: TextStyle(
                              fontFamily: thmanyahFont,
                              fontSize: width * 0.038,
                              fontWeight: FontWeight.w500,
                              color: homeDarkTextColor,
                            ),
                          ),
                        )
                      else
                        Wrap(
                          spacing: width * 0.025,
                          runSpacing: height * 0.012,
                          children: medicines.map((medicine) {
                            return Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: width * 0.04,
                                vertical: height * 0.012,
                              ),
                              decoration: BoxDecoration(
                                color: cardColor,
                                borderRadius: BorderRadius.circular(
                                  width * 0.035,
                                ),
                                border: Border.all(
                                  color: homeBorderColor,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: width * 0.065,
                                    height: width * 0.065,
                                    decoration:
                                        const BoxDecoration(
                                          color: homeGreenColor,
                                          shape: BoxShape.circle,
                                        ),
                                    child: Icon(
                                      Icons.medication_outlined,
                                      color: homeDarkTextColor,
                                      size: width * 0.035,
                                    ),
                                  ),

                                  SizedBox(
                                    width: width * 0.018,
                                  ),

                                  Text(
                                    medicine,
                                    style: TextStyle(
                                      fontFamily: thmanyahFont,
                                      fontSize: width * 0.037,
                                      fontWeight: FontWeight.w600,
                                      color: homeDarkTextColor,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),

                      SizedBox(height: height * 0.035),

                      Text(
  'الملخص الذكي',
  style: TextStyle(
    fontFamily: thmanyahFont,
    fontSize: width * 0.055,
    fontWeight: FontWeight.w700,
    color: whiteColor,
  ),
),

SizedBox(height: height * 0.015),

Container(
  width: double.infinity,
  padding: EdgeInsets.all(width * 0.04),
  decoration: BoxDecoration(
    color: cardColor,
    borderRadius: BorderRadius.circular(
      width * 0.04,
    ),
    border: Border.all(
      color: homeBorderColor,
    ),
  ),
  child: aiSummary == null
      ? Text(
          'اضغط على الزر لإنشاء ملخص ذكي لبيانات الأعراض.',
          style: TextStyle(
            fontFamily: thmanyahFont,
            fontSize: width * 0.038,
            fontWeight: FontWeight.w500,
            color: homeDarkTextColor,
          ),
        )
      : Text(
          aiSummary!,
          style: TextStyle(
            fontFamily: thmanyahFont,
            fontSize: width * 0.038,
            fontWeight: FontWeight.w500,
            color: homeDarkTextColor,
            height: 1.6,
          ),
        ),
),

SizedBox(height: height * 0.015),

SizedBox(
  width: double.infinity,
  height: height * 0.065,
  child: ElevatedButton.icon(
    onPressed:
        isGeneratingAi ? null : generateAiSummary,
    style: ElevatedButton.styleFrom(
      elevation: 0,
      backgroundColor: homePrimaryColor,
      foregroundColor: whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          width * 0.04,
        ),
      ),
    ),
    icon: isGeneratingAi
        ? SizedBox(
            width: width * 0.045,
            height: width * 0.045,
            child: const CircularProgressIndicator(
              strokeWidth: 2,
              color: whiteColor,
            ),
          )
        : Icon(
            Icons.auto_awesome,
            size: width * 0.05,
          ),
    label: Text(
      isGeneratingAi
          ? 'جاري تحليل البيانات...'
          : 'إنشاء الملخص الذكي',
      style: TextStyle(
        fontFamily: thmanyahFont,
        fontSize: width * 0.039,
        fontWeight: FontWeight.w700,
      ),
    ),
  ),
),

SizedBox(height: height * 0.035),

                      // ===========================================
                      // PDF BUTTONS
                      // ===========================================

                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: height * 0.065,
                              child: ElevatedButton.icon(
  onPressed: generatePdf,
  style: ElevatedButton.styleFrom(
    elevation: 0,
    backgroundColor: homePrimaryColor,
    foregroundColor: whiteColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(
        width * 0.04,
      ),
    ),
  ),
  icon: Icon(
    Icons.download_rounded,
    size: width * 0.055,
  ),
  label: Text(
    'تصدير PDF',
    style: TextStyle(
      fontFamily: thmanyahFont,
      fontSize: width * 0.039,
      fontWeight: FontWeight.w700,
    ),
  ),
),
                            ),
                          ),

                          SizedBox(width: width * 0.03),

                          Expanded(
                            child: SizedBox(
                              height: height * 0.065,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  // المشاركة لاحقاً
                                },
                                style: ElevatedButton.styleFrom(
                                  elevation: 0,
                                  backgroundColor:
                                      homePrimaryColor,
                                  foregroundColor: whiteColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                          width * 0.04,
                                        ),
                                  ),
                                ),
                                icon: Icon(
                                  Icons.ios_share_rounded,
                                  size: width * 0.05,
                                ),
                                label: Text(
                                  'مشاركة PDF',
                                  style: TextStyle(
                                    fontFamily: thmanyahFont,
                                    fontSize: width * 0.039,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],

                    SizedBox(height: height * 0.025),
                  ],
                ),
              ),
            ),
          ),

          bottomNavigationBar:
              const CustomBottomNavigation(
                selectedIndex: 3,
              ),
        ),
      ),
    );
  }
  Widget _dateButton({
  required double width,
  required String title,
  required DateTime? date,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(
      width * 0.035,
    ),
    child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.03,
        vertical: width * 0.035,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          width * 0.035,
        ),
        border: Border.all(
          color: homeBorderColor,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_month_outlined,
            size: width * 0.045,
            color: homePrimaryColor,
          ),

          SizedBox(width: width * 0.015),

          Expanded(
            child: Text(
              date == null
                  ? title
                  : _formatArabicDate(date),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: thmanyahFont,
                fontSize: width * 0.032,
                fontWeight: FontWeight.w600,
                color: homeDarkTextColor,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

  // =========================================================
  // STAT CARD
  // =========================================================

  Widget _statCard({
    required double width,
    required double height,
    required String number,
    required String title,
    required Color color,
  }) {
    return Container(
      height: height * 0.14,
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.015,
        vertical: height * 0.018,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          width * 0.045,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: TextStyle(
              fontFamily: thmanyahFont,
              fontSize: width * 0.07,
              fontWeight: FontWeight.w700,
              color: homeDarkTextColor,
            ),
          ),

          SizedBox(height: height * 0.006),

          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              title,
              maxLines: 1,
              style: TextStyle(
                fontFamily: thmanyahFont,
                fontSize: width * 0.034,
                fontWeight: FontWeight.w600,
                color: homeDarkTextColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> generatePdf() async {
  if (records.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('لا توجد بيانات لإنشاء التقرير'),
      ),
    );
    return;
  }

  try {
    // ==========================================
    // CREATE PDF
    // ==========================================

    final pdf = pw.Document();

    // ==========================================
    // LOAD ARABIC FONTS
    // ==========================================
    final regularFont = await PdfGoogleFonts.notoNaskhArabicRegular();
final boldFont = await PdfGoogleFonts.notoNaskhArabicBold();
    // ==========================================
    // PDF COLORS
    // ==========================================

    final lightBlue = PdfColor.fromHex('#DCEFF8');
    final lighterBlue = PdfColor.fromHex('#F1F8FC');
    final darkBlue = PdfColor.fromHex('#315B70');
    final borderBlue = PdfColor.fromHex('#A9D3E6');

    // ==========================================
    // ADD PDF PAGE
    // ==========================================

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          theme: pw.ThemeData.withFont(
            base: regularFont,
            bold: boldFont,
          ),
          textDirection: pw.TextDirection.rtl,
          buildBackground: (context) {
            return pw.FullPage(
              ignoreMargins: true,
              child: pw.Container(
                color: lighterBlue,
              ),
            );
          },
        ),

        build: (context) {
          return [
            // ==========================================
            // TITLE
            // ==========================================

            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 15,
              ),
              decoration: pw.BoxDecoration(
                color: lightBlue,
                borderRadius: pw.BorderRadius.circular(12),
                border: pw.Border.all(
                  color: borderBlue,
                  width: 0.7,
                ),
              ),
              child: pw.Center(
                child: pw.Text(
                  'التقرير الصحي',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 24,
                    color: darkBlue,
                  ),
                ),
              ),
            ),

            pw.SizedBox(height: 22),

            // ==========================================
            // DATE RANGE
            // ==========================================

            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(14),
              decoration: pw.BoxDecoration(
                color: lightBlue,
                borderRadius: pw.BorderRadius.circular(10),
                border: pw.Border.all(
                  color: borderBlue,
                  width: 0.7,
                ),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'فترة التقرير',
                    style: pw.TextStyle(
                      font: boldFont,
                      fontSize: 15,
                      color: darkBlue,
                    ),
                  ),

                  pw.SizedBox(height: 6),

                  pw.Text(
                    dateRangeText,
                    style: pw.TextStyle(
                      font: regularFont,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            pw.SizedBox(height: 22),

            // ==========================================
            // STATISTICS TITLE
            // ==========================================

            pw.Text(
              'ملخص الإحصائيات',
              style: pw.TextStyle(
                font: boldFont,
                fontSize: 17,
                color: darkBlue,
              ),
            ),

            pw.SizedBox(height: 10),

            // ==========================================
            // STATISTICS TABLE
            // ==========================================

            pw.Table(
              border: pw.TableBorder.all(
                color: borderBlue,
                width: 0.7,
              ),
              children: [
                pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: lightBlue,
                  ),
                  children: [
                    _pdfCell(
                      'أنواع الأعراض',
                      boldFont,
                    ),
                    _pdfCell(
                      'متوسط الشدة',
                      boldFont,
                    ),
                    _pdfCell(
                      'الحالات المتكررة',
                      boldFont,
                    ),
                  ],
                ),

                pw.TableRow(
                  children: [
                    _pdfCell(
                      '$symptomTypesCount',
                      regularFont,
                    ),
                    _pdfCell(
                      averageSeverity.toStringAsFixed(1),
                      regularFont,
                    ),
                    _pdfCell(
                      '$repeatedCount',
                      regularFont,
                    ),
                  ],
                ),
              ],
            ),

            pw.SizedBox(height: 22),

            // ==========================================
            // SYMPTOMS TITLE
            // ==========================================

            pw.Text(
              'الأعراض المسجلة',
              style: pw.TextStyle(
                font: boldFont,
                fontSize: 17,
                color: darkBlue,
              ),
            ),

            pw.SizedBox(height: 10),

            // ==========================================
            // SYMPTOMS
            // ==========================================

            ...symptoms.map(
              (symptom) {
                return pw.Container(
                  width: double.infinity,
                  margin: const pw.EdgeInsets.only(
                    bottom: 7,
                  ),
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.white,
                    borderRadius: pw.BorderRadius.circular(7),
                    border: pw.Border.all(
                      color: borderBlue,
                      width: 0.6,
                    ),
                  ),
                  child: pw.Row(
                    mainAxisAlignment:
                        pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        symptom['title'].toString(),
                        style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 12,
                          color: darkBlue,
                        ),
                      ),

                      pw.Text(
                        'عدد المرات: ${symptom['count']}',
                        style: pw.TextStyle(
                          font: regularFont,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            pw.SizedBox(height: 22),

            // ==========================================
            // MEDICINES TITLE
            // ==========================================

            pw.Text(
              'الأدوية المستخدمة',
              style: pw.TextStyle(
                font: boldFont,
                fontSize: 17,
                color: darkBlue,
              ),
            ),

            pw.SizedBox(height: 10),

            // ==========================================
            // MEDICINES
            // ==========================================

            if (medicines.isEmpty)
              pw.Container(
                width: double.infinity,
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  borderRadius: pw.BorderRadius.circular(7),
                  border: pw.Border.all(
                    color: borderBlue,
                    width: 0.6,
                  ),
                ),
                child: pw.Text(
                  'لم يتم تسجيل استخدام أدوية',
                  style: pw.TextStyle(
                    font: regularFont,
                    fontSize: 12,
                  ),
                ),
              )
            else
              ...medicines.map(
                (medicine) {
                  return pw.Container(
                    width: double.infinity,
                    margin: const pw.EdgeInsets.only(
                      bottom: 6,
                    ),
                    padding: const pw.EdgeInsets.all(10),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.white,
                      borderRadius: pw.BorderRadius.circular(7),
                      border: pw.Border.all(
                        color: borderBlue,
                        width: 0.6,
                      ),
                    ),
                    child: pw.Text(
                      '• $medicine',
                      style: pw.TextStyle(
                        font: regularFont,
                        fontSize: 12,
                      ),
                    ),
                  );
                },
              ),

            pw.SizedBox(height: 22),

            // ==========================================
            // AI SUMMARY TITLE
            // ==========================================

            pw.Text(
              'الملخص الذكي',
              style: pw.TextStyle(
                font: boldFont,
                fontSize: 17,
                color: darkBlue,
              ),
            ),

            pw.SizedBox(height: 10),

            // ==========================================
            // AI SUMMARY
            // ==========================================

            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(14),
              decoration: pw.BoxDecoration(
                color: lightBlue,
                borderRadius: pw.BorderRadius.circular(10),
                border: pw.Border.all(
                  color: borderBlue,
                  width: 0.7,
                ),
              ),
              child: pw.Text(
                aiSummary ??
                    'لم يتم إنشاء الملخص الذكي لهذا التقرير.',
                textAlign: pw.TextAlign.right,
                style: pw.TextStyle(
                  font: regularFont,
                  fontSize: 12,
                  lineSpacing: 4,
                ),
              ),
            ),

            pw.SizedBox(height: 25),

            // ==========================================
            // DISCLAIMER
            // ==========================================

            pw.Divider(
              color: borderBlue,
            ),

            pw.SizedBox(height: 8),

            pw.Text(
              'ملاحظة: هذا التقرير يلخص البيانات المدخلة في التطبيق ولا يُعد تشخيصاً طبياً.',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                font: regularFont,
                fontSize: 9,
                color: darkBlue,
              ),
            ),

            pw.SizedBox(height: 22),

            // ==========================================
            // FINAL MESSAGE
            // ==========================================

            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 12,
              ),
              decoration: pw.BoxDecoration(
                color: lightBlue,
                borderRadius: pw.BorderRadius.circular(12),
                border: pw.Border.all(
                  color: borderBlue,
                  width: 0.7,
                ),
              ),
              child: pw.Column(
                children: [
                  pw.Text(
                    '♡',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      font: regularFont,
                      fontSize: 24,
                      color: darkBlue,
                    ),
                  ),

                  pw.SizedBox(height: 5),

                  pw.Text(
                    'لا بأس، طهور إن شاء الله',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      font: boldFont,
                      fontSize: 16,
                      color: darkBlue,
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );

    // ==========================================
    // OPEN / EXPORT PDF
    // ==========================================

    final pdfBytes = await pdf.save();

final blob = html.Blob(
  [pdfBytes],
  'application/pdf',
);

final url = html.Url.createObjectUrlFromBlob(blob);

final anchor = html.AnchorElement(href: url)
  ..setAttribute('download', 'health_report.pdf')
  ..click();

html.Url.revokeObjectUrl(url);
  } catch (error) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'حدث خطأ أثناء إنشاء PDF: $error',
        ),
      ),
    );
  }
}
pw.Widget _pdfCell(
  String text,
  pw.Font font,
) {
  return pw.Padding(
    padding: const pw.EdgeInsets.all(8),
    child: pw.Center(
      child: pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          font: font,
          fontSize: 11,
        ),
      ),
    ),
  );
}
  // =========================================================
  // SYMPTOM PROGRESS
  // =========================================================

  Widget _symptomProgress({
    required double width,
    required double height,
    required String title,
    required int count,
    required double progress,
    required Color color,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          width: width * 0.09,
          height: width * 0.09,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: homeDarkTextColor,
            size: width * 0.045,
          ),
        ),

        SizedBox(width: width * 0.025),

        SizedBox(
          width: width * 0.20,
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: thmanyahFont,
              fontSize: width * 0.037,
              fontWeight: FontWeight.w600,
              color: homeDarkTextColor,
            ),
          ),
        ),

        SizedBox(width: width * 0.02),

        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: height * 0.014,
              backgroundColor: homeBorderColor,
              valueColor:
                  AlwaysStoppedAnimation<Color>(
                    color,
                  ),
            ),
          ),
        ),

        SizedBox(width: width * 0.025),

        SizedBox(
          width: width * 0.055,
          child: Text(
            '$count',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: thmanyahFont,
              fontSize: width * 0.042,
              fontWeight: FontWeight.w700,
              color: homeDarkTextColor,
            ),
          ),
        ),
      ],
    );
  }

  // =========================================================
  // EMPTY
  // =========================================================

  Widget _emptyCard(
    double width,
    double height,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: height * 0.06,
        horizontal: width * 0.05,
      ),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(
          width * 0.05,
        ),
        border: Border.all(
          color: homeBorderColor,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.health_and_safety_outlined,
            color: homeDarkTextColor,
            size: width * 0.12,
          ),

          SizedBox(height: height * 0.015),

          Text(
            'لا توجد بيانات للتقرير',
            style: TextStyle(
              fontFamily: thmanyahFont,
              fontSize: width * 0.045,
              fontWeight: FontWeight.w700,
              color: homeDarkTextColor,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // ERROR
  // =========================================================

  Widget _errorCard(
    double width,
    double height,
  ) {
    return Container(
      padding: EdgeInsets.all(width * 0.05),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(
          width * 0.05,
        ),
      ),
      child: Column(
        children: [
          Text(
            'تعذر تحميل التقرير',
            style: TextStyle(
              fontFamily: thmanyahFont,
              fontSize: width * 0.045,
              fontWeight: FontWeight.w700,
              color: homeDarkTextColor,
            ),
          ),

          SizedBox(height: height * 0.015),

          ElevatedButton(
            onPressed: fetchReportData,
            child: const Text(
              'إعادة المحاولة',
              style: TextStyle(
                fontFamily: thmanyahFont,
              ),
            ),
          ),
        ],
      ),
    );
  }
}