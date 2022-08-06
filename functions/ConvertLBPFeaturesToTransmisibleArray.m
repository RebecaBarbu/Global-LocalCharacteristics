function lbpFeaturesArray = ConvertLBPFeaturesToTransmisibleArray(lbpFeatures)
lbpFeaturesArray = [size(lbpFeatures,2) double(lbpFeatures)];
lbpFeaturesArray = uint32(10^5* lbpFeaturesArray);

end
