---
project: XPlace-2.x-with-Docker
description: 使用 coding agent 產生有 xplace-2.x 的 docker image
---
# 背景知識

## Tar file 
- XPlace-2.x [v2.2.1.tar.gz](https://github.com/cuhk-eda/Xplace/archive/refs/tags/v2.2.1.tar.gz)
- 使用 wget 下載
- 解壓縮後，要初始化並下載 git submodules
  ```bash
    tar -zvxf v2.2.1.tar.gz
    cd {XPlace-2.x}
    git clone https://github.com/pybind/pybind11.git thirdparty/pybind11
  ```
## 了解 XPlace-2.x
- 讀取 {XPlace-2.x}/README.md 進行了解

## ISPD2005 dataset
- download_data.sh 會失敗
- 使用 `./ispd2005`

## Docker images
- nvcr.io/nvidia/pytorch:22.12-py3: 用來編譯 Xplace 並動態安裝必要 apt, pip pakcages 來完成 Xplace 編譯、執行
- custom image: 基於 nvcr.io/nvidia/pytorch:22.12-py3 及 Xplace 編譯、執行所需的 apt, pip packages

# 流程
## 1. 使用 nvcr.io/nvidia/pytorch:22.12-py3 進行編譯
```plaintext
step 1: 啟動 nvcr.io/nvidia/pytorch:22.12-py3 docker , mount xplace project 以及 使用 gpu
step 2: 使用 `docker exec` 和 build-docker 交互, 包括：
        - 要用 apt 安裝 package 時
        - 執行編譯 xplace 相關指令 
step 3: 當使用 apt 或 pip  時，記錄需要的 package name 到 `package_requirement.txt`
step 4: 重覆 step2~step4 直到xplace 編譯完成
step 5: 使用 `docker exec` 進行 xplace 測試
       - 檢查 gpu 是否有成功被使用
       - 檢查 xplace 是否可完成 ispd2005/adaptec1 的placement
```
## 2. 建立 Dockerfile (custom image)
```plaintext
step 1: 使用 nvcr.io/nvidia/pytorch:22.12-py3 為 base image
step 2: 根據 `package_requirement.txt` 完成 `Dockerfile`
step 3: 根據 Dockerfile, 產生 image `xplace-2.x:cuda`
step 4: 啟動 docker image `xplace-2.x:cuda`, mount xplace 完成編譯的目錄 以及使用 gpu
step 5: 使用 `docker exec` 測試 xplace
```



# 輸出成果
1. Dockerfile
   - 含 base image
   - 自動安裝需要的 apt packages
2. 啟動 xplace-2.x:cuda 的 bash script
   - 使用 gpu
   - mount Xplace 安裝目錄


# 注意
1. 安裝 cuda 相關 apt 需要長時間下載，要保留足夠的 timeout 及讓 `docker exec` 背景執行
2. 必要時，請求人類協助了解下載進度


