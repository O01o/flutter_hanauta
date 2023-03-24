from fastapi import FastAPI, File, UploadFile, Form
from fastapi.responses import FileResponse
import shutil
import re

from midi_converter import *

app = FastAPI()

# necessary properties
input_file_name = ''
input_file_type = ''

@app.get("/")
async def home():
    return {"result": "access successfully!!"}

# file upload method
@app.post("/wav2midi")
async def fileupload_post(hop_length: int = Form(default=1600), file: UploadFile = File(...)):
    #2. generate random uuid(ver.4)
    # os.mkdir('./input')
    # os.mkdir('./output')
    
    #3. memorize the input_file name
    global input_file_name
    global input_file_type
    input_file_name = './input/'+file.filename
    input_file_type = file.content_type
    
    #4-1. if file.content_type is wavfile, save to server-side local.
    print('type:', input_file_type)
    if input_file_type == 'audio/wav':
        with open(f'{input_file_name}', 'w+b') as buffer:
            shutil.copyfileobj(file.file, buffer)
        
        return FileResponse(midi_converter(input_file_name, hop_length), media_type="audio/midi")
    #4-2. else, deal with bottom script
    else:
        return {'your_id': 'failed to load file'}


@app.post("/wav2midi2")
async def fileupload_post2(hop_length: int = Form(default=1600), file: UploadFile = File(...)):
    #2. generate random uuid(ver.4)
    # os.mkdir('./input')
    # os.mkdir('./output')
    
    #3. memorize the input_file name
    global input_file_name
    global input_file_type
    input_file_name = './input/'+file.filename
    input_file_type = file.content_type
    
    #4-1. if file.content_type is wavfile, save to server-side local.
    print('type:', input_file_type)
    if input_file_type == 'audio/wav':
        with open(f'{input_file_name}', 'w+b') as buffer:
            shutil.copyfileobj(file.file, buffer)
        
        return FileResponse(midi_converter2(input_file_name, hop_length), media_type="audio/midi")
    #4-2. else, deal with bottom script
    else:
        return {'your_id': 'failed to load file'}


if __name__ == "__main__":
    # file_cleaner()
    pass