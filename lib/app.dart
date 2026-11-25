import 'package:flutter/material.dart';

import 'package:alvaro_pay/core/theme/app_theme.dart';
import 'package:alvaro_pay/features/auth/presentation/pages/auth_gate.dart';
import 'package:alvaro_pay/l10n/generated/app_localizations.dart';

class AlvaroPayApp extends StatelessWidget {
  const AlvaroPayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appName,
      theme: AppTheme.light,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const AuthGate(),
    );
  }
}
