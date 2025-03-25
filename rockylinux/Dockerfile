# 构建阶段
FROM rockylinux/rockylinux:9.5-ubi AS builder

ARG BASE_DIR=/opt/websrv
ARG MAGICK_VERSION=7.1.1-46
ENV TZ=Asia/Shanghai
ENV BASE_DIR=${BASE_DIR} \
    SCRIPT_DIR=${BASE_DIR}/script \
    TMP_DIR=${BASE_DIR}/tmp

WORKDIR ${SCRIPT_DIR}

# 配置阿里云镜像源并安装必要的构建依赖
RUN sed -e 's|^mirrorlist=|#mirrorlist=|g' \
    -e 's|^#baseurl=http://dl.rockylinux.org/$contentdir|baseurl=https://mirrors.aliyun.com/rockylinux|g' \
    -i.bak /etc/yum.repos.d/rocky-*.repo && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo '$TZ' > /etc/timezone && \
    yum install -y epel-release && \
    yum install -y gcc gcc-c++ make autoconf automake libtool pkgconfig \
    fontconfig-devel ghostscript freetype-devel libpng-devel libjpeg-devel \
    wget tar && \
    mkdir -p ${TMP_DIR}

# 下载并解压ImageMagick源码（替代git克隆）
RUN cd ${TMP_DIR} && \
    wget https://mirrors.mydev.work/mirror/imagemagick/ImageMagick-7.1.1-46.tar.gz -O ImageMagick.tar.gz && \
    tar -xzf ImageMagick.tar.gz && \
    cd ImageMagick-${MAGICK_VERSION} && \
    ./configure --with-freetype=yes --with-fontconfig=yes --prefix=/usr/local && \
    make -j$(nproc) && \
    make install

# 运行阶段
FROM rockylinux/rockylinux:9.5-ubi

ARG BASE_DIR=/opt/websrv
ENV TZ=Asia/Shanghai
ENV BASE_DIR=${BASE_DIR} \
    SCRIPT_DIR=${BASE_DIR}/script \
    CONFIG_DIR=${BASE_DIR}/config \
    LOG_DIR=${BASE_DIR}/logs

# 创建必要的目录
RUN mkdir -p ${SCRIPT_DIR}/ImageMagick ${CONFIG_DIR} ${LOG_DIR} /usr/share/fonts/otherfonts && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo '$TZ' > /etc/timezone

# 从构建阶段复制编译好的ImageMagick
COPY --from=builder /usr/local /usr/local

# 配置动态链接库
RUN echo '/usr/local/lib' > /etc/ld.so.conf.d/imagemagick.conf && \
    ldconfig

# 复制字体和配置文件
COPY ./otherfonts/* /usr/share/fonts/otherfonts/
COPY ./config/* /usr/local/etc/ImageMagick-*/

# 设置字体权限并更新字体缓存
RUN chmod 644 /usr/share/fonts/otherfonts/* && \
    yum install -y fontconfig ghostscript freetype-devel libpng-devel libjpeg-devel && \
    python -m pip install --upgrade python==3.12.0 && \
    yum install python3.12-pip && \
    ln -s -f /usr/bin/python3.12 /usr/bin/python3 && \
    ln -s -f /usr/bin/python3.12 /usr/bin/python && \
    fc-cache -fv && \
    yum clean all && \
    rm -rf /var/cache/yum

WORKDIR ${SCRIPT_DIR}/ImageMagick

# 验证安装
RUN magick -list configure | grep -i freetype