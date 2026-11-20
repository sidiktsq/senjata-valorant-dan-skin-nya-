import 'package:flutter_test/flutter_test.dart';
import 'package:uas_senjata_valorant/main.dart';

void main() {
  testWidgets('App starts with Splash Screen test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app starts and shows the Valorant title.
    expect(find.text('SKIN VALORANT'), findsOneWidget);
  });
}
