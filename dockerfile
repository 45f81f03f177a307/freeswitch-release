# 使用官方最新的 Debian 基础镜像
FROM debian:latest

# 修改 APT 源为清华大学镜像
RUN echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm main contrib non-free non-free-firmware" > /etc/apt/sources.list && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
    echo "deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bookworm-backports main contrib non-free non-free-firmware" >> /etc/apt/sources.list && \
    echo "deb https://security.debian.org/debian-security bookworm-security main contrib non-free non-free-firmware" >> /etc/apt/sources.list

# 安装所需工具
RUN apt-get update && apt-get install -y \
    curl \
    git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 设置工作目录
WORKDIR /usr/src

# 复制脚本到容器内
COPY ./install.sh /usr/src/install.sh

# 确保脚本具有执行权限
RUN chmod +x /usr/src/install.sh

# 运行安装脚本
RUN sh /usr/src/install.sh

# 设置容器启动命令
CMD ["/usr/local/freeswitch/bin/freeswitch", "-nf"]