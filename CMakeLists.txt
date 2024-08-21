cmake_minimum_required(VERSION 3.10)
project(kahan_summation CUDA CXX)

# Set C++ standard
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Find CUDA
find_package(CUDA REQUIRED)

# Include LibreCUDA
add_subdirectory(LibreCuda)

# Add your executable
add_executable(kahan_summation src/main.cpp src/kahan_sum.cu)

# Link against LibreCUDA's driverapi
target_link_libraries(kahan_summation PRIVATE driverapi)

# Include directories
target_include_directories(kahan_summation PRIVATE ${CMAKE_CUDA_TOOLKIT_INCLUDE_DIRECTORIES})

# Set CUDA architectures (adjust as needed for your GPU)
set_target_properties(kahan_summation PROPERTIES
    CUDA_ARCHITECTURES "60;70;75;80;86")

# Optionally, you can add compiler flags
if(MSVC)
    target_compile_options(kahan_summation PRIVATE /W4)
else()
    target_compile_options(kahan_summation PRIVATE -Wall -Wextra -Wpedantic)
endif()