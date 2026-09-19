import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:final_project/constants/colors.dart';
import 'package:final_project/constants/fonts.dart';
import 'package:final_project/screens/login_screen.dart';

bool requireLogin(BuildContext context) {
  final user = Supabase.instance.client.auth.currentUser;

  // المستخدم مسجل دخول
  if (user != null) {
    return true;
  }

  // المستخدم زائر
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
              fontWeight: FontWeight.bold,
              color: mainTextColor,
            ),
          ),
          content: const Text(
            'سجل دخولك أولاً للاستفادة من هذه الميزة.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: thmanyahFont,
              color: secondaryTextColor,
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
                  color: secondaryTextColor,
                ),
              ),
            ),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: whiteColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'تسجيل الدخول',
                style: TextStyle(
                  fontFamily: thmanyahFont,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );

  return false;
}