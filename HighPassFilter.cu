#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include "HighPassFilter.h"
#include <iostream>

bool isCudaError(cudaError_t status)
{
	// printf("[%d] %s\n", status, cudaGetErrorString(status));
	return status != cudaSuccess;
}

__global__ void kernel(const uint8_t* src, const int loopCnt, uint8_t* dest_1, uint8_t* dest_2, uint8_t* filter_1, uint8_t* filter_2, float* max_1, float* max_2)
{
	const UINT taskIdx = threadIdx.x;
	uint8_t output_1 = 0, output_2 = 0, x1_1 = 0, x1_2 = 0;
	float _max_1 = 0, _max_2 = 0;
	
	for(UINT index = 0; index < loopCnt; index++)
	{
		const UINT realIdx = taskIdx * loopCnt + index;

		dest_1[realIdx] = src[realIdx * 2];
		dest_2[realIdx] = src[realIdx * 2 + 1];

		output_1 = AMPLFAC_1 * (src[realIdx] - x1_1 - output_1 * Y1C_1);
		x1_1 = src[realIdx];
		output_2 = AMPLFAC_2 * (src[realIdx] - x1_2 - output_2 * Y1C_2);
		x1_2 = src[realIdx];

		filter_1[realIdx] = output_1;
		filter_2[realIdx] = output_2;

		if(filter_1[realIdx] > _max_1) _max_1 = filter_1[realIdx];
		if(filter_2[realIdx] > _max_2) _max_2 = filter_2[realIdx];
	}

	max_1[taskIdx] = _max_1;
	max_2[taskIdx] = _max_2;
}

EXPORT int cudaHighPassFilter(const uint8_t* src, const int cnt, uint8_t* dest_1, uint8_t* dest_2, uint8_t* filter_1, uint8_t* filter_2, float* max_1, float* max_2)
{
	printf("in cudaHighPassFilter\n");
	uint8_t *dev_src = 0, *dev_dest_1 = 0, *dev_dest_2 = 0, *dev_filter_1 = 0, *dev_filter_2 = 0;
	float *dev_max_1 = 0, *dev_max_2 = 0;

	cudaError_t status;

	// printf("start checkVersion\n");
	// int runtimeVer = 0, driverVer = 0;
	// status = cudaRuntimeGetVersion(&runtimeVer);
	// if(isCudaError(status)) goto Exit;
	// status = cudaDriverGetVersion(&driverVer);
	// if(isCudaError(status)) goto Exit;

	printf("start cuda\n");
	// printf("cuda runtime ver.%d / cuda driver ver.%d\n", runtimeVer, driverVer);
	status = cudaSetDevice(0);
	if(isCudaError(status)) goto Exit;
	printf("success cudaSetDevice\n");

	status = cudaMalloc((void**)&dev_src, (cnt * 2) * sizeof(uint8_t));
	if (isCudaError(status)) goto Exit;
	status = cudaMalloc((void**)&dev_dest_1, cnt * sizeof(uint8_t));
	if (isCudaError(status)) goto Exit;
	status = cudaMalloc((void**)&dev_dest_2, cnt * sizeof(uint8_t));
	if (isCudaError(status)) goto Exit;
	status = cudaMalloc((void**)&dev_filter_1, cnt * sizeof(uint8_t));
	if (isCudaError(status)) goto Exit;
	status = cudaMalloc((void**)&dev_filter_2, cnt * sizeof(uint8_t));
	if (isCudaError(status)) goto Exit;
	status = cudaMalloc((void**)&dev_max_1, UNIT_COUNT * sizeof(float));
	if (isCudaError(status)) goto Exit;
	status = cudaMalloc((void**)&dev_max_2, UNIT_COUNT * sizeof(float));
	if (isCudaError(status)) goto Exit;
	printf("success cudaMalloc\n");

	status = cudaMemcpy(dev_src, src, (cnt * 2) * sizeof(uint8_t), cudaMemcpyHostToDevice);
	if (isCudaError(status)) goto Exit;
	printf("success cudaMemcpy\n");

	kernel<<<1, UNIT_COUNT>>> (dev_src, cnt / UNIT_COUNT, dev_dest_1, dev_dest_2, dev_filter_1, dev_filter_2, dev_max_1, dev_max_2);
	if (isCudaError(cudaGetLastError())) goto Exit;
	printf("success kernel\n");

	status = cudaDeviceSynchronize();
	if (isCudaError(status)) goto Exit;
	printf("success cudaDeviceSynchronize\n");

	status = cudaMemcpy(dest_1, dev_dest_1, cnt * sizeof(uint8_t), cudaMemcpyDeviceToHost);
	if (isCudaError(status)) goto Exit;
	status = cudaMemcpy(dest_2, dev_dest_2, cnt * sizeof(uint8_t), cudaMemcpyDeviceToHost);
	if (isCudaError(status)) goto Exit;
	status = cudaMemcpy(filter_1, dev_filter_1, cnt * sizeof(uint8_t), cudaMemcpyDeviceToHost);
	if (isCudaError(status)) goto Exit;
	status = cudaMemcpy(filter_2, dev_filter_2, cnt * sizeof(uint8_t), cudaMemcpyDeviceToHost);
	if (isCudaError(status)) goto Exit;
	status = cudaMemcpy(max_1, dev_max_1, UNIT_COUNT * sizeof(float), cudaMemcpyDeviceToHost);
	if (isCudaError(status)) goto Exit;
	status = cudaMemcpy(max_2, dev_max_2, UNIT_COUNT * sizeof(float), cudaMemcpyDeviceToHost);
	if (isCudaError(status)) goto Exit;
	printf("success cudaMemcpy\n");

Exit:
	cudaFree(dev_src);
	cudaFree(dev_dest_1);
	cudaFree(dev_dest_2);
	cudaFree(dev_filter_1);
	cudaFree(dev_filter_2);
	cudaFree(dev_max_1);
	cudaFree(dev_max_2);

	return status;
}