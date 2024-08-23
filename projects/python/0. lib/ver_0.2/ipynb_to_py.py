#!/usr/bin/env python
# coding: utf-8

# In[ ]:


IPYNB_FOLDER = "./src/"
OUTPUT_FOLDER = "./output/"


# In[ ]:


from pathlib import Path
import subprocess


# In[ ]:


folder_in = Path(IPYNB_FOLDER)
folder_out = Path(OUTPUT_FOLDER)


# In[ ]:


# 建立 py 檔案
for pth in list(folder_in.rglob("*.ipynb")):
    cmd = f"jupyter nbconvert --to python {pth}"
    result = subprocess.run(cmd, shell=True, text=True)
    print(f"finish cmd: {result.args}\t| return: {result.returncode}")

print("Finish creating all python files.\n")


# In[ ]:


for pth in list(folder_in.rglob("*.py")):
    # 建立資料夾
    cmd = f"mkdir {folder_out / pth.parent}"
    result = subprocess.run(cmd, shell=True, text=True)
    print(f"finish cmd: {result.args}\t\t\t\t\t| return: {result.returncode}")
    # 複製 py 檔案
    cmd = f"copy {pth} {folder_out / pth}"
    result = subprocess.run(cmd, shell=True, text=True)
    print(f"finish cmd: {result.args}\t| return: {result.returncode}\n")

print("All Python files have been copied to the output folder")

