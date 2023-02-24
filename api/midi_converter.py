import os
import numpy as np
import librosa
import mido
from mido import Message, MidiFile, MidiTrack, MetaMessage

def midi_converter(input_file_name: str, hop_length = 16 * 100):
    print("start")
    y, sr = librosa.load(input_file_name, sr=8000)
    chroma_cqt = librosa.cqt(
            y=y, sr=sr, hop_length=hop_length,
            fmin=librosa.note_to_hz('C1'), n_bins=12*5, 
            bins_per_octave=12, window='hamming')
    # print(chroma_cqt.shape)
    chroma_cqt_argmax = np.argmax(chroma_cqt, axis=0)
    # print(chroma_cqt_argmax.shape)
    
    note = 0
    length = 1
    mid = MidiFile()
    track = MidiTrack()
    mid.tracks.append(track)
    track.append(MetaMessage('set_tempo', tempo=mido.bpm2tempo(120)))
    for i in chroma_cqt_argmax:
        if i == note:
            length += 1
        else:
            track.append(Message('note_on', note=note+36, velocity=127, time=0))
            track.append(Message('note_off', note=note+36, velocity=127, time=120*length))
            note = i
            length = 1
            
    output_file_name = './output/' + os.path.basename(input_file_name) + '.mid'
    mid.save(f'{output_file_name}')
    
    return output_file_name

if __name__ == "__main__":
    midi_converter("tmput/asano.wav")