function [imageFeaturesResulted,l,c] = ConvertArraySurfFeaturesToSurfFeatures(SurfFeaturesArray)

tempSurfFeatures = double(SurfFeaturesArray)/10^10;
l = tempSurfFeatures(1,1);
c = tempSurfFeatures(1,2);
extractSign = 2*tempSurfFeatures(1,3:l*c+2)-1;
extractFeat = extractSign .* tempSurfFeatures(2+l*c+1:end);
imageFeaturesResulted = reshape(extractFeat, [l c]);
end