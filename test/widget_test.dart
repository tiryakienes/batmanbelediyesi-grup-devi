import 'package:flutter_test/flutter_test.dart';
import 'package:batmanbelediyesi/main.dart';

void main() {
  testWidgets('Batman Belediyesi app smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const BatmanBelediyesiApp());

    // Verify that the app loads
    expect(find.text('BATMAN'), findsWidgets);
    expect(find.text('BELEDİYESİ'), findsWidgets);
  });
}
