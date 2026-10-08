// import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'firebase_options.dart';
// import 'pages/auth_gate.dart';

// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

//   runApp(const ProviderScope(child: SpendlyApp()));
// }

// class SpendlyApp extends StatelessWidget {
//   const SpendlyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Spendly',
//       debugShowCheckedModeBanner: false,
//       home: const AuthGate(),
//     );
//   }
// }

import 'package:expense_tracker/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'pages/auth_gate.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const ProviderScope(child: Spendly()));
}

class Spendly extends StatelessWidget {
  const Spendly({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spendly',
      theme: ThemeData(
        colorScheme: ColorScheme(
          primary: AppColors.primary,
          onPrimary: AppColors.ink,
          secondary: AppColors.muted,
          onSecondary: AppColors.ink,
          error: AppColors.danger,
          onError: AppColors.ink,
          surface: AppColors.surface,
          onSurface: AppColors.ink,
          brightness: Brightness.light,
        ),
      ),

      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
