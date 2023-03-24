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



def midi_converter2(input_file_name: str, hop_length = 16 * 100):
    y, sr = librosa.load(input_file_name, sr=8000)
    # 各パラメータの値の設定
    # hop_length は5オクターブの場合だと16の整数倍である必要があるらしいです！
    fmin = librosa.note_to_hz('C1') # 最低音階
    bins_per_octave = 12 # 1オクターブ12音階
    octaves = 5 # オクターブ数
    n_bins = bins_per_octave * octaves # 音階の個数
    window = 'hamming' # 窓関数のモデル(今回はハミング窓。ハン窓('hann')や三角窓('triang')もあり
    
    chroma_cqt = np.abs(librosa.cqt(
        y, sr=sr, hop_length=hop_length, fmin=fmin, n_bins=n_bins, 
        bins_per_octave=bins_per_octave, window=window))
    
    # 歯擦音の軽減をするために最後のオクターブを10dBほど軽減する
    # (アンプの状態では0.3倍するだけでおおよそ近くなる)
    for num in range(n_bins - (2*bins_per_octave), n_bins):
        chroma_cqt[num] *= 0.3
    
    pitch_list = [] # 各フレームごとの音階
    midi_list = [] # 音階の長さリスト
    tmp_pitch = 0 # 一時的に保存する音階
    count = 1 # 音階の長さ
    print(type(chroma_cqt), len(chroma_cqt))
    chroma_cqt_T = chroma_cqt.T
    for x in chroma_cqt_T:
        # フレームごとの音階をリスト化する
        pitch_list.append(np.argmax(x))
        
        # 音階化したリストについて、音階の長さを調べ、
        # 音階が続けば長さを加え、違う音程になれば出力する
        if np.argmax(x) == tmp_pitch:
            count += 1
        else:
            midi_list.append([tmp_pitch, count])
            tmp_pitch = np.argmax(x)
            count = 1
    # 最後の音階を出力する
    midi_list.append([tmp_pitch, count])
    # 最初の音階は高さ0なので排外する
    midi_list.remove(midi_list[0])
    
    print('len(pitch_list): ', len(pitch_list))
    print('pitch_list: ', pitch_list)
    print('len(midi_list): ', len(midi_list))
    print('midi_list: ', midi_list)
    print('Convert Done!!!')
    
    
    '''
    Save Midi with Mido
    '''
    
    mid = MidiFile()
    track = MidiTrack()
    mid.tracks.append(track)
    track.append(MetaMessage('set_tempo', tempo=mido.bpm2tempo(120)))
    for note in midi_list:
        track.append(Message('note_on', note=note[0]+36, velocity=127, time=0))
        track.append(Message('note_off', note=note[0]+36, time=120*note[1]))
    
    output_file_name = './output/' + os.path.basename(input_file_name) + '2.mid'
    mid.save(f'{output_file_name}')
    
    return output_file_name



if __name__ == "__main__":
    midi_converter("tmput/asano.wav")