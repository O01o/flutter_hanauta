# flutter_hanauta

## 使用効果音
- 効果音ラボ  

## アプリ概要
Flutter, FastAPI, GCP Cloud Runを使用して、歌声の音声データからMIDI譜面データを生成するモバイルアプリを制作しました。  
録音された音声ファイルを選択し、メトロノームの周期を設定してリクエストをかける部分はDart/Flutter(クライアントサイド)で、  
リクエストを受けたファイルデータ及び16分音符の演奏時間からMIDI譜面に変換するアルゴリズムはPython/FastAPI(サーバーサイド)で実行しました。  
サーバーサイドスクリプトはDocker化し、Google Cloudにデプロイすることを目指し、発行されたURLにFlutterがリクエストを送信します。

## アプリ実行手順
Google Cloud Consoleにて、Cloud Build, Cloud Runを有効化してください。
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

## サービスURL
https://hanauta-7xlrbzh3ba-an.a.run.app
