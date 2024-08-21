#include <iostream>
#include <vector>
#include <librecuda.h>

// Declaration of the Kahan summation function (implemented in kahan_sum.cu)
float kahan_sum(const float* data, int size);

int main() {
    // Initialize LibreCUDA
    libreCuInit(0);

    // Get device count
    int device_count = 0;
    libreCuDeviceGetCount(&device_count);
    std::cout << "Device count: " << device_count << std::endl;

    // Get and create context for the first device
    LibreCUdevice device;
    libreCuDeviceGet(&device, 0);

    LibreCUcontext ctx;
    libreCuCtxCreate_v2(&ctx, CU_CTX_SCHED_YIELD, device);

    // Example data
    std::vector<float> data = {1.0f, 1e100f, 1.0f, -1e100f};
    
    // Call the Kahan summation function
    float result = kahan_sum(data.data(), data.size());

    std::cout << "Kahan sum result: " << result << std::endl;

    // Clean up LibreCUDA resources
    libreCuCtxDestroy(ctx);

    return 0;
}