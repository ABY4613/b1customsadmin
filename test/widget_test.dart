import 'package:b1customsadmin/utils/app_theme.dart';
import 'package:b1customsadmin/views/auth/auth_view.dart';
import 'package:b1customsadmin/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('B1 Customs Admin App smoke test', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(2560, 1440);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final authController = AuthController();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.darkTheme,
        home: AuthView(authController: authController),
      ),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('B1 CUSTOMS'), findsOneWidget);
  });
}
