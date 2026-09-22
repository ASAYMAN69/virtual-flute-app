import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:virtual_flute_app/data/repositories/flute_repository.dart';
import 'package:virtual_flute_app/data/repositories/song_repository.dart';
import 'package:virtual_flute_app/ui/features/fingering_guide/views/fingering_guide_screen.dart';
import 'package:virtual_flute_app/ui/features/flute/view_models/flute_view_model.dart';
import 'package:virtual_flute_app/ui/features/flute/views/flute_screen.dart';
import 'package:virtual_flute_app/ui/features/settings/views/audio_settings_screen.dart';

void main() {
  Widget createTestWidget(Widget child) {
    final fluteRepo = FluteRepository();
    final songRepo = SongRepository();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => FluteViewModel(
            fluteRepository: fluteRepo,
            songRepository: songRepo,
          ),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData.dark(),
        home: child,
      ),
    );
  }

  group('A11y Automated WCAG Guideline Validation', () {
    testWidgets('FluteScreen passes labeled tap target guidelines', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(createTestWidget(const FluteScreen()));
      await tester.pumpAndSettle();

      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('FingeringGuideScreen passes accessibility guidelines', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(createTestWidget(const FingeringGuideScreen()));
      await tester.pumpAndSettle();

      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    });

    testWidgets('AudioSettingsScreen sliders and controls meet guidelines', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(createTestWidget(const AudioSettingsScreen()));
      await tester.pumpAndSettle();

      await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
      handle.dispose();
    });
  });
}
