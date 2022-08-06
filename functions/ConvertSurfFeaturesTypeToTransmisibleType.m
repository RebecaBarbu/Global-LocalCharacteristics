function imageFeatures = ConvertSurfPointsTypeToTransmisibleType(surf_imageFeatures)

surf_imageFeatures = uint64(double(10^10*double(surf_imageFeatures)));
imageFeatures = double(surf_imageFeatures)/10^10;

end