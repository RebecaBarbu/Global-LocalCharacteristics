function surfFeaturesArray = ConvertSurfFeaturesToTransmisibleArray(imageFeatures)

signOfImageFeatures = sign(imageFeatures(:))';

% %% necesar pt comparari ulterioare
% imageFeatures = uint64(double(10^10*double(imageFeatures)));
% imageFeatures = double(imageFeatures)/10^10;
%%

% imageFeatures = uint32(10^4 * double(imageFeatures));

surfFeaturesArray = uint64(10^10 * [ ...
    double(size(imageFeatures,1)) ...
    double(size(imageFeatures,2)) ...
    double(signOfImageFeatures) ...
    double(imageFeatures(:)')...

    ]);

end