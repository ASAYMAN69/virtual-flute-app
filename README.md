# 🎵 Virtual Flute (iOS & Android)

A full-featured Virtual Flute application built with Flutter following clean MVVM architecture, realistic acoustic PCM wave sound synthesis, interactive fingering guides, play-along song tutorials, and multi-track performance recording.

---

## 🌟 Key Features

1. **Realistic Flute Acoustic Simulation**:
   - Pure Dart 16-bit 44.1kHz wave synthesis engine.
   - Distinct timbres: *Silver Concert Flute*, *Indian Bamboo Bansuri*, *Irish Tin Whistle*, *Pan Flute (Zampona)*, and *Piccolo*.
   - Dynamic air chiff / turbulence noise, gentle woodwind attack onset, and natural acoustic resonance decay.
   - Smooth LFO vibrato and microtonal pitch modulation.

2. **Intuitive Woodwind Instrument Controls**:
   - 6 tactile tone holes with visual feedback.
   - Embouchure mouthpiece with *Hold-to-Blow*, *Continuous Breath*, and *Direct-Touch* modes.
   - 3-octave switch (Low, Mid, High) and air pressure flow slider.
   - Quick fingering buttons (Open All / Close All).

3. **Musical Scales & Modes**:
   - C Major, D Major (Whistle Standard), G Major, A Natural Minor, Major Pentatonic, and Raga Yaman (Kalyan Thaat).
   - Real-time HUD displaying pitch name, scientific frequency (Hz), solfège (Do-Re-Mi), and scale adherence status.

4. **Fingering Guide & Chart**:
   - Visual 6-hole chart for every chromatic note across 2+ octaves.
   - One-tap fingering application and sound preview.

5. **Play-Along Tutorials & Scoring**:
   - Step-by-step interactive sheet music (*Hot Cross Buns*, *Ode to Joy*, *Scarborough Fair*, *Greensleeves*).
   - Auto-Play demo mode and real-time accuracy scoring.

6. **Recording Studio**:
   - Capture your flute improvisations and replay them anytime.

---

## 🛠 Architecture

Organized with strict Separation of Concerns using **MVVM + Repository Pattern**:

```
lib/
├── data/
│   ├── repositories/   # FluteRepository, SongRepository
│   └── services/       # AudioSynthService (PCM Wave Synthesizer), AudioPlayerService
├── domain/
│   └── models/         # FluteNote, FluteScale, AudioSettings, FluteSong, FluteRecording
└── ui/
    ├── core/           # AppTheme, AppColors
    └── features/
        ├── flute/           # FluteScreen, ViewModel, Instrument & Breath UI
        ├── fingering_guide/ # FingeringGuideScreen
        ├── songs/           # SongsScreen, SongPlayAlongScreen, SongsViewModel
        ├── recordings/      # RecordingsScreen
        └── settings/        # AudioSettingsScreen
```

---

## 🚀 CI/CD & Compilation

Automated GitHub Actions workflow (`.github/workflows/ci.yml`):
- Runs static analysis (`flutter analyze`)
- Executes unit & widget test suites (`flutter test`)
- Compiles **Android Release APK & App Bundle (AAB)**
- Compiles **iOS Release Application (`Runner.app`)**
- Uploads compiled release artifacts for instant download
