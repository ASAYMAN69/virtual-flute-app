import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:virtual_flute_app/data/repositories/flute_repository.dart';
import 'package:virtual_flute_app/data/repositories/song_repository.dart';
import 'package:virtual_flute_app/ui/features/flute/view_models/flute_view_model.dart';
import 'package:virtual_flute_app/ui/features/flute/views/flute_screen.dart';

void main() {
  group('FluteScreen Widget Integration Tests', () {
    late FluteRepository fluteRepository;
    late SongRepository songRepository;
    late FluteViewModel fluteViewModel;

    setUp(() {
      fluteRepository = FluteRepository();
      songRepository = SongRepository();
      fluteViewModel = FluteViewModel(
        fluteRepository: fluteRepository,
        songRepository: songRepository,
      );
    });

    testWidgets('FluteScreen displays Note HUD, Instrument and Breath controls', (WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<FluteViewModel>.value(value: fluteViewModel),
          ],
          child: const MaterialApp(
            home: FluteScreen(),
          ),
        ),
      );

      // Verify Note HUD is visible
      expect(find.text('NOTE PLAYING'), findsOneWidget);

      // Verify Breath button is visible
      expect(find.text('HOLD TO BLOW'), findsOneWidget);

      // Verify Octave selector is visible
      expect(find.text('Octave: '), findsOneWidget);
      expect(find.text('Mid'), findsOneWidget);
    });
  });
}
