import 'dart:math' as math;
import 'dart:typed_data';
import 'package:virtual_flute_app/domain/models/audio_settings.dart';
import 'package:virtual_flute_app/domain/models/flute_note.dart';

/// Pure Dart sound synthesizer that creates realistic Flute PCM audio waves in WAV format.
class AudioSynthService {
  static const int sampleRate = 44100;
  static const int numChannels = 1; // Mono for optimal performance & instant synthesis
  static const int bitsPerSample = 16;

  /// Synthesizes a realistic flute note sound in WAV format.
  Uint8List generateFluteWav(
    FluteNote note, {
    required AudioSettings settings,
    double durationSeconds = 1.2,
    double intensity = 1.0,
  }) {
    final int numSamples = (sampleRate * durationSeconds).toInt();
    final Int16List pcmData = Int16List(numSamples);

    final double baseFreq = note.getShiftedFrequency(settings.octaveShift * 12.0);
    final List<double> harmonics = settings.fluteType.harmonicWeights;
    final double breathAmt = settings.fluteType.breathiness * settings.breathAirVolume;
    final double vibratoRate = settings.vibratoSpeed;
    final double vibratoDepth = settings.vibratoDepth * 0.03; // percentage pitch deviation

    final math.Random random = math.Random(note.displayName.hashCode);

    // ADSR Envelope parameters
    final int attackSamples = (sampleRate * 0.08).toInt(); // 80ms gentle woodwind attack
    final int releaseSamples = (sampleRate * 0.25).toInt(); // 250ms natural acoustic resonance release
    final int sustainSamples = math.max(0, numSamples - attackSamples - releaseSamples);

    double phase = 0.0;
    double breathFilter = 0.0;

    for (int i = 0; i < numSamples; i++) {
      final double t = i / sampleRate;

      // Amplitude Envelope
      double envelope = 0.0;
      if (i < attackSamples) {
        // Smooth S-curve / sine attack
        envelope = math.sin((i / attackSamples) * (math.pi / 2));
      } else if (i < attackSamples + sustainSamples) {
        envelope = 1.0;
      } else {
        // Exponential / cosine decay
        final double releaseProgress = (i - attackSamples - sustainSamples) / releaseSamples;
        envelope = math.cos(releaseProgress * (math.pi / 2)).clamp(0.0, 1.0);
      }

      // Vibrato modulation (delayed onset like real flute player)
      final double vibratoFadeIn = (t / 0.4).clamp(0.0, 1.0);
      final double vibrato = math.sin(2.0 * math.pi * vibratoRate * t) * vibratoDepth * vibratoFadeIn;
      final double currentFreq = baseFreq * (1.0 + vibrato);

      // Phase increment
      phase += 2.0 * math.pi * currentFreq / sampleRate;
      if (phase > 2.0 * math.pi) {
        phase -= 2.0 * math.pi;
      }

      // 1. Harmonics synthesis
      double sampleValue = 0.0;
      for (int h = 0; h < harmonics.length; h++) {
        final int harmonicNumber = h + 1;
        final double harmonicWeight = harmonics[h];
        sampleValue += math.sin(phase * harmonicNumber) * harmonicWeight;
      }

      // Normalize harmonics
      sampleValue /= harmonics.fold<double>(0.0, (sum, w) => sum + w);

      // 2. Breath Turbulence / Air Chiff Noise (low-pass filtered white noise)
      final double whiteNoise = (random.nextDouble() * 2.0 - 1.0);
      breathFilter += 0.15 * (whiteNoise - breathFilter);
      final double breathComponent = breathFilter * breathAmt * (0.8 + 0.2 * math.sin(phase));

      // 3. Combine acoustic wave with breath air
      double finalSample = (sampleValue * 0.75 + breathComponent * 0.25) * envelope * intensity;

      // Master volume & 16-bit PCM conversion
      finalSample = (finalSample * settings.masterVolume).clamp(-1.0, 1.0);
      pcmData[i] = (finalSample * 32767.0).toInt();
    }

    return _createWavContainer(pcmData);
  }

  /// Encapsulates raw 16-bit PCM samples into a standard RIFF/WAVE header.
  Uint8List _createWavContainer(Int16List pcmData) {
    final int byteRate = sampleRate * numChannels * (bitsPerSample ~/ 8);
    final int blockAlign = numChannels * (bitsPerSample ~/ 8);
    final int dataSize = pcmData.lengthInBytes;
    final int chunkSize = 36 + dataSize;

    final ByteData byteData = ByteData(44 + dataSize);

    // RIFF chunk descriptor
    byteData.setUint8(0, 0x52); // 'R'
    byteData.setUint8(1, 0x49); // 'I'
    byteData.setUint8(2, 0x46); // 'F'
    byteData.setUint8(3, 0x46); // 'F'
    byteData.setUint32(4, chunkSize, Endian.little);
    byteData.setUint8(8, 0x57);  // 'W'
    byteData.setUint8(9, 0x41);  // 'A'
    byteData.setUint8(10, 0x56); // 'V'
    byteData.setUint8(11, 0x45); // 'E'

    // fmt sub-chunk
    byteData.setUint8(12, 0x66); // 'f'
    byteData.setUint8(13, 0x6D); // 'm'
    byteData.setUint8(14, 0x74); // 't'
    byteData.setUint8(15, 0x20); // ' '
    byteData.setUint32(16, 16, Endian.little); // Subchunk1Size (16 for PCM)
    byteData.setUint16(20, 1, Endian.little);  // AudioFormat (1 for PCM)
    byteData.setUint16(22, numChannels, Endian.little);
    byteData.setUint32(24, sampleRate, Endian.little);
    byteData.setUint32(28, byteRate, Endian.little);
    byteData.setUint16(32, blockAlign, Endian.little);
    byteData.setUint16(34, bitsPerSample, Endian.little);

    // data sub-chunk
    byteData.setUint8(36, 0x64); // 'd'
    byteData.setUint8(37, 0x61); // 'a'
    byteData.setUint8(38, 0x74); // 't'
    byteData.setUint8(39, 0x61); // 'a'
    byteData.setUint32(40, dataSize, Endian.little);

    // Write PCM audio data
    final Uint8List result = byteData.buffer.asUint8List();
    result.setRange(44, 44 + dataSize, pcmData.buffer.asUint8List());

    return result;
  }
}
