import 'package:flutter_test/flutter_test.dart';
import 'package:stanworld/main.dart';

void main() {
  testWidgets('Stanworld smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const StanworldApp());

    // Verify that the title/brand is displayed.
    expect(find.text('STANISLAS SELLE'), findsOneWidget);
  });
}
