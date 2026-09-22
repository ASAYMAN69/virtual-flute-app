import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:virtual_flute_app/domain/models/audio_settings.dart';
import 'package:virtual_flute_app/ui/features/flute/views/widgets/flute_hole_widget.dart';
import 'package:virtual_flute_app/ui/features/flute/views/widgets/flute_instrument_view.dart';

void main() {
  group('FluteInstrumentView Widget Tests', () {
    testWidgets('Renders all 6 tone holes correctly in vertical mode', (WidgetTester tester) async {
      final holes = [false, false, false, false, false, false];
      int tappedIndex = -1;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FluteInstrumentView(
              holes: holes,
              fluteType: FluteType.concertFlute,
              onHoleToggled: (index) {
                tappedIndex = index;
              },
            ),
          ),
        ),
      );

      // Verify that all 6 hole widgets are rendered
      expect(find.byType(FluteHoleWidget), findsNWidgets(6));
      expect(find.text('Hole 1'), findsOneWidget);
      expect(find.text('Hole 6'), findsOneWidget);

      // Tap Hole 1
      await tester.tap(find.text('Hole 1'));
      await tester.pump();

      expect(tappedIndex, equals(0));
    });

    testWidgets('Renders properly in landscape horizontal mode', (WidgetTester tester) async {
      final holes = [true, true, false, false, false, false];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: FluteInstrumentView(
              holes: holes,
              fluteType: FluteType.bambooBansuri,
              onHoleToggled: (_) {},
              isLandscape: true,
            ),
          ),
        ),
      );

      expect(find.byType(FluteHoleWidget), findsNWidgets(6));
    });
  });
}
