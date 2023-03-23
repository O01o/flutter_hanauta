# flutter_hanauta

## アプリ概要
Flutter, FastAPI, GCP Cloud Runを使用して、歌声の音声データからMIDI譜面データを生成するモバイルアプリを制作しました。  
録音された音声ファイルを選択し、メトロノームの周期を設定してリクエストをかける部分はDart/Flutter(クライアントサイド)で、  
リクエストを受けたファイルデータ及び16分音符の演奏時間からMIDI譜面に変換するアルゴリズムはPython/FastAPI(サーバーサイド)で実行しました。  
サーバーサイドスクリプトはDocker化し、Google Cloudにデプロイすることを目指し、発行されたURLにFlutterがリクエストを送信します。

## システムの動作について

- 現在、Android 13でのみで動作確認ができております。
- 録音機能はまだ未実装です。
- WAV2MIDI変換後、CXファイルエクスプローラー等のファイルマネージャーからメインストレージを開き、Android/data/com.example.flutter_hanauta/files/Hanauta/midiのディレクトリを開くことでMIDIファイルを確認することができます。

## アプリ実行手順

### サーバーサイド
Google Cloud Consoleにて、Cloud Build, Cloud Runを有効化してから、以下のコマンドを入力してください。
<pre>
# move working directory
cd api

# set up your project 
gcloud init
# or
gcloud config set project YOUR_PROJECT
gcloud config get project

# docker build and deploy
gcloud builds submit --tag gcr.io/YOUR_PROJECT/hanauta
gcloud run deploy --image gcr.io/YOUR_PROJECT/hanauta --platform managed --max-instances 1 --min-instances 0
</pre>

### クライアントサイド
OSは現状Androidのみに対応しています。Android 13に対応するSDKのバージョンを入手してください。  
実機またはエミュレータでデバッグすることができます。下記のコマンドにてパッケージをインストールしてください。
<pre>
flutter pub get
</pre>
lib/widgets/screens/wav2midi_screen.dart　２３０行にある、
<pre>
final response = await dio.post("https://hanauta-7xlrbzh3ba-an.a.run.app/", data: formData);
</pre>
この行について、URLは各自でCloud Runにより発行されたものを使用してください。
