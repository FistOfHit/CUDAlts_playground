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
    std::vector<double> data = {1.0, 1e100, 1.0, -1e100};
    std::vector<float> float_data(data.begin(), data.end());
    
    // Call the Kahan summation function
    float result = kahan_sum(float_data.data(), float_data.size());

    std::cout << "Kahan sum result: " << result << std::endl;

    // Clean up LibreCUDA resources
    libreCuCtxDestroy(ctx);

    return 0;
}