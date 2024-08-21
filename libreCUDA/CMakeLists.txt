cmake_minimum_required(VERSION 3.10)
project(kahan_summation CUDA CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(CUDA REQUIRED)
add_subdirectory(LibreCuda)

add_executable(kahan_summation src/main.cpp src/kahan_sum.cu)
target_include_directories(kahan_summation PRIVATE 
    ${CMAKE_CUDA_TOOLKIT_INCLUDE_DIRECTORIES}
    ${CMAKE_SOURCE_DIR}/LibreCuda/driverapi/include
)

target_link_libraries(kahan_summation PRIVATE driverapi)

set_target_properties(kahan_summation PROPERTIES
    CUDA_ARCHITECTURES "60;70;75;80;86")
