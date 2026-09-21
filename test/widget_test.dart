import 'package:flutter_test/flutter_test.dart';
import 'package:b1customsadmin/main.dart';

void main() {
  testWidgets('B1 Customs Admin App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const B1CustomsAdminApp());

    // Verify that login screen is rendered initially
    expect(find.text('B1 CUSTOMS'), findsOneWidget);
  });
}
