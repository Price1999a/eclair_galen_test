# 使用包含 Clang 编译器的基础镜像
FROM teeks99/clang-ubuntu:17

# 设置工作目录
WORKDIR /app
VOLUME /app/data

# 将主机上的源文件复制到镜像中
COPY main.c .
ARG QUERY_FILE
COPY $QUERY_FILE query-eclair.ll

# 编译程序
RUN clang -DDOCKER_ENV -o program main.c query-eclair.ll

# 设置容器的默认命令
CMD ["./program"]