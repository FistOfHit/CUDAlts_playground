#include <librecuda.h>
#include <cstring>
#include <iostream>
#include <fstream>
#include <vector>

__global__ void kahan_sum_kernel(const float* data, int size, float* result) {
    float sum = 0.0f;
    float c = 0.0f;  // A running compensation for lost low-order bits

    for (int i = 0; i < size; ++i) {
        float y = data[i] - c;
        float t = sum + y;
        c = (t - sum) - y;
        sum = t;
    }

    *result = sum;
}

float kahan_sum(const float* data, int size) {
    // Allocate device memory (accessible by CPU)
    void *d_data, *d_result;
    libreCuMemAlloc(&d_data, size * sizeof(float), true);
    libreCuMemAlloc(&d_result, sizeof(float), true);

    // Copy data to device (now we can directly access it)
    std::memcpy(d_data, data, size * sizeof(float));

    // Load the CUDA module from a file
    LibreCUmodule module;
    std::ifstream input("kahan_sum_kernel.cubin", std::ios::binary);
    std::vector<uint8_t> buffer(std::istreambuf_iterator<char>(input), {});
    libreCuModuleLoadData(&module, buffer.data(), buffer.size());

    // Get the kernel function
    LibreCUFunction kernel;
    libreCuModuleGetFunction(&kernel, module, "kahan_sum_kernel");

    // Set up kernel parameters
    void* params[] = {&d_data, &size, &d_result};

    // Create a stream
    LibreCUstream stream;
    libreCuStreamCreate(&stream, 0);

    // Launch the kernel
    libreCuLaunchKernel(kernel, 1, 1, 1, 1, 1, 1, 0, stream, params, sizeof(params) / sizeof(void*), nullptr);

    // Wait for the kernel to complete
    libreCuStreamCommence(stream);
    libreCuStreamAwait(stream);

    // Copy result back to host (now we can directly access it)
    float result = *(float*)d_result;

    // Clean up
    libreCuMemFree(d_data);
    libreCuMemFree(d_result);
    libreCuStreamDestroy(stream);
    libreCuModuleUnload(module);

    return result;
}
