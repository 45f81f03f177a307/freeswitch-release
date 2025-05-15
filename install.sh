#!/bin/bash

# 定义 TOKEN
TOKEN="pat_E8sNkonWh41V2SxV4BGB2xNC"

# 更新系统并安装 curl
echo "=== 更新系统并安装 curl ==="
apt update && apt install -y curl

# 下载并运行 FreeSWITCH 的安装脚本
echo "=== 下载并运行 FreeSWITCH 安装脚本 ==="
curl -sSL https://freeswitch.org/fsget | bash -s "$TOKEN"

# 安装 FreeSWITCH 编译所需的依赖
echo "=== 安装 FreeSWITCH 编译依赖 ==="
apt-get -y build-dep freeswitch

# 克隆 FreeSWITCH 源代码
echo "=== 克隆 FreeSWITCH 源代码 ==="
git clone -b v1.10 https://github.com/signalwire/freeswitch.git
cd freeswitch

# 配置 Git 以避免冲突
echo "=== 配置 Git pull 方式为 rebase ==="
git config pull.rebase true

# 开始编译 FreeSWITCH
echo "=== 开始编译 FreeSWITCH ==="
./bootstrap.sh -j
./configure
make
make install

# 清理编译过程中产生的临时文件和目录
echo "=== 清理编译过程中产生的临时文件 ==="
make clean
make distclean

# 返回上级目录并删除 FreeSWITCH 源代码
cd ..
echo "=== 删除 FreeSWITCH 源代码目录 ==="
rm -rf freeswitch

# 删除未使用的依赖包
echo "=== 删除未使用的依赖包 ==="
apt-get autoremove -y

# 清理系统缓存
echo "=== 清理系统缓存 ==="
apt-get clean

# 使用 deborphan 查找并删除未使用的库
echo "=== 查找并删除未使用的库 ==="
apt-get install -y deborphan
deborphan | xargs apt-get -y remove --purge

# 检查磁盘空间
echo "=== 检查磁盘空间使用情况 ==="
df -h

echo "=== FreeSWITCH 安装和清理完成！ ==="