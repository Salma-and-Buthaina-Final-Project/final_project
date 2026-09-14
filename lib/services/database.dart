import 'package:supabase_flutter/supabase_flutter.dart';

class Database {
  final supabase = Supabase.instance.client;

  Future<void> signupUser({
    required String name,
    required String email,
    required String password,
  }) async {
    await supabase.auth.signUp(
      email: email.trim(),
      password: password,
      data: {
        'name': name,
      },
    );
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    await supabase.auth.signInWithPassword(
      email: email.trim(),
      password: password,
    );
  }
}