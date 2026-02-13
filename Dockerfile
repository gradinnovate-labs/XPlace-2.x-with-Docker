FROM nvcr.io/nvidia/pytorch:22.12-py3

LABEL maintainer="XPlace-2.x Docker Image"
LABEL description="XPlace-2.x placement framework with CUDA support"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    libcairo2-dev \
    python3.8-dev \
    && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir \
    seaborn \
    pulp \
    igraph

WORKDIR /workspace
