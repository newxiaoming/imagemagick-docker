#! /bin/bash

##############################################################
# Copyright (c) 2025,new5tt. All rights reserved.
# @Description: 基于 rockylinux 9.5 的 ImageMagick 安装脚本
# @Author: new5tt
# @Create Time: 2025-03-22 12:00
# @Version: v1.0.0
##############################################################

set -e
# set -x 运行结果之前，输出待执行的命令
set -x

echo -e "\033[44;37m ===========编译ImageMagick=========== \033[0m"

# ImageMagick版本
if [ -z "${MAGICK_VERSION}" ]; then
    MAGICK_VERSION="7.1.1-46"
fi

echo 'export PATH=/usr/local/bin:$PATH' | tee /etc/profile.d/local-bin.sh
chmod +x /etc/profile.d/local-bin.sh
source /etc/profile

# 1. 安装必要的开发工具和库
yum groupinstall -y "Development Tools"
yum install -y epel-release fontconfig ghostscript freetype-devel libpng-devel libjpeg-devel

# 2. 编译
git clone --depth 1 --branch ${MAGICK_VERSION} https://gitcode.com/GD123_123/ImageMagick.git ${SCRIPT_DIR}/ImageMagick-${MAGICK_VERSION}
cd ${SCRIPT_DIR}/ImageMagick-${MAGICK_VERSION}


# 3. 配置、编译和安装 ImageMagick：
./configure --with-freetype=yes --with-fontconfig=yes
make
make install
exit

echo -e "\033[44;37m ===========检查字体文件，确保字体文件是 .ttf 格式，并且路径正确=========== \033[0m"

# 4. 复制字体文件到字体目录
# wget https://mirrors-storage.timesmedia.com.cn/ImageMagick/fonts/msyhbd.ttf -O /usr/share/fonts/msyhbd.ttf
mv ${SCRIPT_DIR}/ImageMagick/otherfonts/* /usr/share/fonts/otherfonts/

# 5. 字体权限
chmod 644 /usr/share/fonts/otherfonts

# 6. 更新动态链接库配置
ldconfig /usr/local/lib

# 7. 更新字体缓存
fc-cache -fv

# 8. 修改ImageMagick type.xml配置（将下面的字体配置添加到typemap）
cd /usr/local/etc/ImageMagick-*
mv /usr/local/etc/ImageMagick-*/type.xml /usr/local/etc/ImageMagick-${MAGICK_VERSION}/type.xml.bak
mv ${SCRIPT_DIR}/ImageMagick/config/* /usr/local/etc/ImageMagick-${MAGICK_VERSION}/
# wget https://mirrors-storage.timesmedia.com.cn/ImageMagick/fonts/type.xml -O /usr/local/etc/ImageMagick-${MAGICK_VERSION}/type.xml

echo -e "\033[44;37m ===========验证安装=========== \033[0m"

#6. 验证 ImageMagick 是否正确启用了 Freetype 支持：

ls /usr/local/lib/ImageMagick-*
ls /usr/local/bin/magick
magick -list configure | grep -i freetype