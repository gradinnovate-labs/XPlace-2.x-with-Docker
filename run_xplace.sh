#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
XPLACE_DIR="${XPLACE_DIR:-$SCRIPT_DIR}"

docker run -it --rm \
    --gpus all \
    --name xplace-runtime \
    -v "$XPLACE_DIR:/workspace" \
    -w /workspace/Xplace-2.2.1 \
    xplace-2.x:cuda \
    bash
