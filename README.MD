## 项目

使用不同的基础操作系统，构建不同ImageMagick的docker镜像。

## 使用

1. 使用`make`命令即可构建镜像，makefile中定义了构建的镜像，`APP_VERSION`是ImageMagick的版本，`IMAGE_NAME`需要修改成你的镜像名称，修改`APP_VERSION`即可构建不同ImageMagick版本的镜像。

make可用的命令

```
build     - 构建ImageMagick Docker镜像，版本信息后面带时间"
clean     - 删除当前Makefile文件创建的Docker镜像"
rocketmq  - 构建ImageMagick Docker镜像附带有安装rocketmq-client-cpp 2.2.0"
help      - 帮助"
```

2. 增加字体

修改添加字体，字体文件需要放在`otherfonts`目录下，字体文件名需要和`config/type.xml`中字体名保持一致。

备注：`ImageMagick.sh` 仅仅作为安装的一个手动脚本，已经融合进去在docker构建过程。