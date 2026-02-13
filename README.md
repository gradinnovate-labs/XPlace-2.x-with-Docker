# XPlace-2.x Docker Image

基於 [XPlace-2.x](https://github.com/cuhk-eda/Xplace) 的 Docker 環境，支援 GPU 加速的 VLSI global placement。

## 目錄結構

```
.
├── Dockerfile              # Docker image 定義
├── run_xplace.sh           # 啟動腳本
├── package_requirement.txt  # 所需 apt/pip packages
├── workflow.md             # 建構流程說明
├── ispd2005/               # ISPD2005 測試資料集
└── Xplace-2.2.1/           # XPlace 原始碼（已編譯）
```

## 快速開始

### 1. 使用現有 Docker Image

```bash
# 啟動 XPlace 環境
./run_xplace.sh

# 或手動執行
docker run -it --rm --gpus all \
    -v $PWD:/workspace \
    -w /workspace/Xplace-2.2.1 \
    xplace-2.x:cuda bash
```

### 2. 執行 Placement

```bash
# 在 container 內執行
cd /workspace/Xplace-2.2.1

# 測試單一設計
python main.py --dataset ispd2005 --design_name adaptec1

# 執行所有 ISPD2005 設計
python main.py --dataset ispd2005 --run_all True
```

### 3. 使用自訂資料

```bash
# 將 LEF/DEF 放入 data/raw/ 目錄
python main.py --custom_path lef:data/raw/design.lef,def:data/raw/design.def,design_name:mydesign,benchmark:custom --load_from_raw True --detail_placement True
```

## 從零開始建構

### 使用 OpenCode + GLM-5 自動建構

本專案可透過 [OpenCode](https://opencode.ai) 搭配 GLM-5 模型自動完成建構流程：

```bash
# 1. 啟動 OpenCode（使用 glm-5 模型）
opencode --model glm-5

# 2. 讓 OpenCode 讀取 workflow.md 並執行
> 請讀取 workflow.md 並按照流程實現 XPlace-2.x Docker image

# OpenCode 將自動執行：
# - 下載 XPlace-2.x 原始碼
# - 啟動基礎 Docker container
# - 編譯 XPlace
# - 記錄所需 packages
# - 建立 Dockerfile
# - 建構 custom Docker image
# - 測試驗證
```

### 手動建構步驟

如需手動建構，請參考 `workflow.md` 中的詳細流程：

```bash
# 1. 下載並解壓縮 XPlace
wget https://github.com/cuhk-eda/Xplace/archive/refs/tags/v2.2.1.tar.gz
tar -zxf v2.2.1.tar.gz
cd Xplace-2.2.1
git clone https://github.com/pybind/pybind11.git thirdparty/pybind11

# 2. 啟動基礎 Docker container 進行編譯
docker run -d --gpus all --name xplace-build \
    -v $PWD:/workspace \
    nvcr.io/nvidia/pytorch:22.12-py3 tail -f /dev/null

# 3. 編譯 XPlace
docker exec xplace-build bash -c "cd /workspace/Xplace-2.2.1/build && \
    cmake -DPYTHON_EXECUTABLE=\$(which python) -DPYTHON_INCLUDE_DIRS='/usr/include/python3.8' -DCMAKE_CXX_ABI=1 .. && \
    make -j\$(nproc) && make install"

# 4. 建構 Docker image
docker build -t xplace-2.x:cuda .
```

## 系統需求

- Docker 19.03+
- NVIDIA Container Toolkit
- NVIDIA GPU with CUDA 11.x 支援
- NVIDIA Driver 470+

## Docker Image 資訊

| 項目 | 值 |
|------|-----|
| Base Image | nvcr.io/nvidia/pytorch:22.12-py3 |
| Image Name | xplace-2.x:cuda |
| CUDA Version | 11.8 |
| Python Version | 3.8 |
| PyTorch Version | 1.14 |

### 已安裝的額外套件

**apt packages:**
- libcairo2-dev
- python3.8-dev

**pip packages:**
- seaborn
- pulp
- igraph

## 參考資料

- [XPlace GitHub](https://github.com/cuhk-eda/Xplace)
- [XPlace Paper (TCAD)](https://ieeexplore.ieee.org/document/10373583)
- [OpenCode](https://opencode.ai)
