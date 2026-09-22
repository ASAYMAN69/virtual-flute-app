import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:virtual_flute_app/ui/core/theme/app_colors.dart';
import 'package:virtual_flute_app/ui/core/theme/app_theme.dart';
import 'package:virtual_flute_app/data/repositories/flute_repository.dart';
import 'package:virtual_flute_app/data/repositories/song_repository.dart';
import 'package:virtual_flute_app/data/services/audio_player_service.dart';
import 'package:virtual_flute_app/data/services/audio_synth_service.dart';
import 'package:virtual_flute_app/ui/features/fingering_guide/views/fingering_guide_screen.dart';
import 'package:virtual_flute_app/ui/features/flute/view_models/flute_view_model.dart';
import 'package:virtual_flute_app/ui/features/flute/views/flute_screen.dart';
import 'package:virtual_flute_app/ui/features/recordings/views/recordings_screen.dart';
import 'package:virtual_flute_app/ui/features/settings/views/audio_settings_screen.dart';
import 'package:virtual_flute_app/ui/features/songs/view_models/songs_view_model.dart';
import 'package:virtual_flute_app/ui/features/songs/views/songs_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  final audioSynthService = AudioSynthService();
  final audioPlayerService = AudioPlayerService(synthService: audioSynthService);
  final fluteRepository = FluteRepository(audioPlayerService: audioPlayerService);
  final songRepository = SongRepository();

  runApp(
    VirtualFluteApp(
      fluteRepository: fluteRepository,
      songRepository: songRepository,
    ),
  );
}

/// The Root Virtual Flute Application.
class VirtualFluteApp extends StatelessWidget {
  const VirtualFluteApp({
    super.key,
    required this.fluteRepository,
    required this.songRepository,
  });

  final FluteRepository fluteRepository;
  final SongRepository songRepository;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FluteRepository>.value(value: fluteRepository),
        Provider<SongRepository>.value(value: songRepository),
        ChangeNotifierProvider<FluteViewModel>(
          create: (_) => FluteViewModel(
            fluteRepository: fluteRepository,
            songRepository: songRepository,
          ),
        ),
        ChangeNotifierProvider<SongsViewModel>(
          create: (_) => SongsViewModel(
            songRepository: songRepository,
            fluteRepository: fluteRepository,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Virtual Flute',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const MainNavigationShell(),
      ),
    );
  }
}

/// Navigation Shell hosting the 5 primary tabs.
class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    FluteScreen(),
    FingeringGuideScreen(),
    SongsScreen(),
    RecordingsScreen(),
    AudioSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _currentIndex = idx;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.music_note_outlined),
            selectedIcon: Icon(Icons.music_note, color: AppColors.breathCyan),
            label: 'Flute',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book, color: AppColors.breathCyan),
            label: 'Fingerings',
          ),
          NavigationDestination(
            icon: Icon(Icons.library_music_outlined),
            selectedIcon: Icon(Icons.library_music, color: AppColors.breathCyan),
            label: 'Songs',
          ),
          NavigationDestination(
            icon: Icon(Icons.mic_none),
            selectedIcon: Icon(Icons.mic, color: AppColors.breathCyan),
            label: 'Records',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings, color: AppColors.breathCyan),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
