#include <librecuda.h>
#include <cstring>

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

extern "C" {
    float kahan_sum(const float* data, int size) {
        // Allocate device memory
        void *d_data, *d_result;
        libreCuMemAlloc(&d_data, size * sizeof(float), true);
        libreCuMemAlloc(&d_result, sizeof(float), true);

        // Copy data to device
        libreCuMemcpyHtoD(d_data, data, size * sizeof(float));

        // Load the CUDA module (assuming you have compiled the kernel to a cubin file)
        LibreCUmodule module;
        const char* module_name = "kahan_sum.cubin"; // Make sure this file exists
        libreCuModuleLoad(&module, module_name);

        // Get the kernel function
        LibreCUfunction kernel;
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

        // Copy result back to host
        float result;
        libreCuMemcpyDtoH(&result, d_result, sizeof(float));

        // Clean up
        libreCuMemFree(d_data);
        libreCuMemFree(d_result);
        libreCuStreamDestroy(stream);
        libreCuModuleUnload(module);

        return result;
    }
}