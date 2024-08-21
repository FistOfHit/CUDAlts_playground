#!/bin/bash

set -euo pipefail

# Build the project
echo "Building the project..."
mkdir -p build
make

# Set LD_LIBRARY_PATH to include LibreCUDA
echo "Setting LD_LIBRARY_PATH..."
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(pwd)/LibreCuda/build/lib

# Compile CUDA kernel to CUBIN
echo "Compiling CUDA kernel to CUBIN..."
nvcc -cubin src/kahan_sum.cu -o kahan_sum.cubin

# Move CUBIN file to build directory
echo "Moving CUBIN file to build directory..."
mv kahan_sum.cubin build/

# Run the executable
echo "Running the Kahan summation algorithm..."
./build/kahan_summation

echo "Execution complete."
