##############################################################
# Copyright (c) 2025,new5tt. All rights reserved.
# @Description: make自动构建镜像
# @Author: new5tt
# @Create Time: 2025-03-22 12:26
# @Version: v0.0.1
##############################################################
IMAGE_NAME := new5tt/imagemagick
# APP_VERSION，主安装包的默认版本
APP_VERSION=7.1.1-46
TIMESTAMP := $(shell date +%Y%m%d%H%M%S)
TAG := $(IMAGE_NAME):$(APP_VERSION)
LATEST_TAG := $(IMAGE_NAME):latest

.PHONY: all
all: build

.PHONY: build
build:
	@echo "构建imagemagick Docker镜像，tag=$(TAG)"
	docker build -t $(TAG) --build-arg APP_VERSION=$(APP_VERSION) -f Dockerfile .
	docker tag $(TAG) $(LATEST_TAG)
	@echo "同时生成latest版本: $(LATEST_TAG)"

.PHONY: rocketmq
rocketmq:
	@echo "构建ImageMagick Docker镜像附带安装rocketmq-client-cpp 2.2.0，tag=$(TAG)"
	docker build -t $(TAG) --build-arg APP_VERSION=$(APP_VERSION) -f Dockerfile.runtime.rocketmq-client-cpp .
	docker tag $(TAG) $(LATEST_TAG)
	@echo "同时生成latest版本: $(LATEST_TAG)"

# Clean up
.PHONY: clean
clean:
	@echo "删除Docker镜像"
	-docker rmi $(TAG) 2>/dev/null || true
	-docker rmi $(LATEST_TAG) 2>/dev/null || true

.PHONY: help
help:
	@echo "可用的命令:"
	@echo "  build     - 构建ImageMagick Docker镜像，版本信息后面带时间tag ($(TAG))"
	@echo "  clean     - 删除当前Makefile文件创建的Docker镜像"
	@echo "  rocketmq  - 构建ImageMagick Docker镜像附带有安装rocketmq-client-cpp 2.2.0"
	@echo "  help      - 帮助"