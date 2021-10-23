#include "ToneMapper.h"

#include <iostream>
#include <fstream>

constexpr int cMINBLOCKS = 8;

ToneMapper::ToneMapper()
{
}


ToneMapper::~ToneMapper()
{
}

void ToneMapper::Load(std::string& aFilename)
{
	mImage.mData =  stbi_load(
					aFilename.c_str(), 
					&mImage.mWidth, 
					&mImage.mHeight, 
					&mImage.mChannels, 
					STBI_rgb);

	if (!mImage.mData)
	{
		throw ImageDoesntExistException();
	}
}

void ToneMapper::Clear()
{
	mImage = Image();
}



