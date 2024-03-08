#!/bin/bash

# 设置超时时间（单位：秒）
timeout=300

mkdir "docker_out"
# 遍历所有的 query-eclair.ll 文件
for file in ./possible_ll/query-eclair_*.ll; do
    # 提取文件名中的版本号
    version=$(basename $file | cut -d'_' -f2 | cut -d'.' -f1)

    # 构建 Docker 镜像
    docker build -t program:$version --build-arg QUERY_FILE=$file .

    # 运行 Docker 容器，并将输出重定向到文件
    docker run -v /home/stq/eclair/input:/app/data --name program_$version program:$version > ./docker_out/output_$version.txt 2>&1 &

    # 记录容器的 ID
    container_id=$(docker ps -q -l)

    # 等待容器运行完成或超时
    timeout_cmd="timeout $timeout"
    $timeout_cmd docker wait $container_id

    # 检查容器的退出状态
    exit_status=$?
    if [ $exit_status -eq 124 ]; then
        echo "Container $version timed out after $timeout seconds"
    elif [ $exit_status -ne 0 ]; then
        echo "Container $version exited with status $exit_status"
    else
        echo "Container $version finished successfully"
    fi

    # 删除 Docker 容器
    docker rm program_$version
done