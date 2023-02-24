from fastapi import FastAPI, File, UploadFile, Form
from fastapi.responses import FileResponse

app = FastAPI()

@app.get("/")
async def home():
    return {"result": "access successfully!!"}