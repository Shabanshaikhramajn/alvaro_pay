import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:alvaro_pay/app.dart';
import 'package:alvaro_pay/core/di/injection_container.dart';
import 'package:alvaro_pay/l10n/generated/app_localizations.dart';

void main() {
  setUp(() {
    // No cached session -> AuthGate's splash check resolves to "no user"
    // and the app lands on the login screen, same as a fresh install.
    SharedPreferences.setMockInitialValues(<String, Object>{});
    setupInjection();
  });

  tearDown(() {
    sl.reset();
  });

  testWidgets('shows the Alvaro Pay login screen on launch', (tester) async {
    await tester.pumpWidget(const AlvaroPayApp());
    // AuthGate checks for a cached session asynchronously, then
    // navigates; let that settle before asserting on the final screen.
    await tester.pumpAndSettle();

    final BuildContext context = tester.element(find.byType(MaterialApp));
    final AppLocalizations l10n = AppLocalizations.of(context)!;

    expect(find.text(l10n.appName), findsOneWidget);
    expect(find.text(l10n.loginButton), findsOneWidget);
  });
}
