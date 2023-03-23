import re

path = "tmput/asano.wav"
with open(path, "rb") as f:
    data_list = re.split('(..)', f.read().hex())[1::2]
    print(" ".join(data_list))