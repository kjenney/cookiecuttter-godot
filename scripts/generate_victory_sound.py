#!/usr/bin/env python3
import wave
import math
import struct

def generate_victory_sound(output_path, duration=0.6, sample_rate=44100):
    """
    Generate a simple victory sound (three ascending notes: C, E, G)
    """
    # Notes: C5 (523 Hz), E5 (659 Hz), G5 (784 Hz)
    notes = [523, 659, 784]
    note_duration = duration / len(notes)
    samples_per_note = int(sample_rate * note_duration)

    # Open WAV file
    with wave.open(output_path, 'w') as wav_file:
        # Set parameters: 1 channel (mono), 2 bytes per sample (16-bit), sample_rate
        wav_file.setnchannels(1)
        wav_file.setsampwidth(2)
        wav_file.setframerate(sample_rate)

        # Generate each note
        for freq in notes:
            for i in range(samples_per_note):
                # Generate sine wave with envelope (fade in/out)
                t = i / sample_rate
                envelope = min(i / (samples_per_note * 0.1),
                             (samples_per_note - i) / (samples_per_note * 0.2))
                envelope = min(envelope, 1.0)

                # Generate sine wave sample
                sample = int(32767 * 0.3 * envelope * math.sin(2 * math.pi * freq * t))
                # Pack as signed 16-bit integer
                wav_file.writeframes(struct.pack('<h', sample))

    print(f"Generated victory sound: {output_path}")

if __name__ == "__main__":
    generate_victory_sound("victory.wav")
