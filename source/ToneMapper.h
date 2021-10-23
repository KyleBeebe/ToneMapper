#ifndef TONEMAPPER_H
#define TONEMAPPER_H

#include "cuda_runtime.h"
#include "device_launch_parameters.h"
#include <string>
#include <exception>


#include "stb_image.h"

struct Image{
	int mWidth{ 0 }, mHeight{ 0 }, mChannels{ 3 };
	std::string mFilePath{ "" };
	stbi_uc* mData = nullptr;

	~Image() {
		stbi_image_free(mData);
	}
};

struct ImageDoesntExistException : std::exception
{
	virtual const char* what() const noexcept
	{
		return "Image does not exist";
	}
};

class ToneMapper
{
public:
	ToneMapper();
	~ToneMapper();

	void Load(std::string& aFilename);
	const Image& GetImage() { return mImage; };
	void Clear();

	bool ImageLoaded(){ return !mImage.mFilePath.empty(); };

private:
	Image mImage;
};

#endif


