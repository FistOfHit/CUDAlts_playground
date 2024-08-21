#!/bin/bash

set -euo pipefail

# Compile CUDA kernel to CUBIN
echo "Compiling CUDA kernel to CUBIN..."
nvcc -cubin src/kahan_sum.cu -o kahan_sum.cubin

# Move CUBIN file to build directory
echo "Moving CUBIN file to build directory..."
mkdir -p build
mv kahan_sum.cubin build/

# Build the project
echo "Building the project..."
make

# Set LD_LIBRARY_PATH to include LibreCUDA
echo "Setting LD_LIBRARY_PATH..."
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)/LibreCuda/build/lib

# Run the executable
echo "Running the Kahan summation algorithm..."
./build/kahan_summation

echo "Execution complete."