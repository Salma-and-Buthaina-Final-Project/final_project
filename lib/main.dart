<<<<<<< HEAD
import 'package:final_project/screens/home_screen.dart';
import 'package:final_project/screens/splash_screen.dart';
=======
import 'package:final_project/screens/login_screen.dart';
>>>>>>> 202a16916ab2c70c948573720f29ca1bdd570fec
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  final url = dotenv.get('my_url');
  final publishableKey = dotenv.get('my_publishableKey');

  await Supabase.initialize(
    url: url,
    anonKey: publishableKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}