import 'package:flutter_test/flutter_test.dart';
import 'package:govt_exam_prep/app.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const App());
    await tester.pump(const Duration(seconds: 6));
    expect(find.byType(App), findsOneWidget);
  });
}
