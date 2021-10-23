
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include <iostream>
#include <string>
#include <thrust/device_vector.h>
#include <thrust/host_vector.h>
#include <thrust/iterator/counting_iterator.h>
#include <thrust/copy.h>

#include "ToneMapper.h"
#define STB_IMAGE_IMPLEMENTATION
#define STBI_NO_FAILURE_STRINGS
#include "stb_image.h"

struct RGB{
	stbi_uc r;
	stbi_uc g;
	stbi_uc b;
};

__global__ void ToIntesity(stbi_uc* d_pixel_data, stbi_uc* d_intensities)
{
	//extern __shared__ stbi_uc s_pixel_data[];
	int idx = threadIdx.x + blockDim.x * blockIdx.x;
	stbi_uc r = d_pixel_data[idx];
}

__host__ void Run(const Image& img)
{
	int total_pixels = img.mHeight * img.mWidth;
	int num_blocks_x = std::ceil(img.mWidth / 16.0f);
	int num_blocks_y = std::ceil(img.mHeight / 16.0f);

	dim3 grid(num_blocks_x, num_blocks_y);
	dim3 block(16, 16);

    ToIntesity<<<grid, block>>>(nullptr, nullptr);
}

int main()
{
	int nDevices{0}, activeDevice{-1};
	cudaDeviceProp devProps;
	ToneMapper toneMapper; 
	std::string imgFilepath{"images/roses.jpg"};

	if (cudaGetDeviceCount(&nDevices) != cudaSuccess || !nDevices)
	{
		std::cerr << "No Cuda Device Detected!" << std::endl;
		return 1;
	}

	for (int i = 0; i < nDevices; ++i) {
		cudaGetDeviceProperties(&devProps,i);
		if (devProps.major >= 6) 
		{
			activeDevice = i;
			break;
		}
	}

	if (activeDevice < 0)
	{
		std::cerr << "No Cuda Device with Compute Capability 6.X+ Detected!" << std::endl;
		return 1;
	}

	try 
	{
		toneMapper.Load(imgFilepath);
	}
	catch (const ImageDoesntExistException& e)
	{
		std::cerr << e.what() << "\n";
	}
	
	Run(toneMapper.GetImage());

    return 0;
}

