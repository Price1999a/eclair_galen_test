cmake_minimum_required(VERSION 3.27)
project(eclair_test C)

set(CMAKE_C_STANDARD 11)

# 添加 query-eclair.ll 文件所在的目录到包含目录列表
include_directories(${CMAKE_CURRENT_SOURCE_DIR})

add_executable(eclair_test main.c)

# 将 query-eclair.ll 文件链接到可执行文件
target_link_libraries(eclair_test ${CMAKE_CURRENT_SOURCE_DIR}/query-eclair.ll)