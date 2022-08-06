function [L_prime, L, Z_prime, Z, h_prime, h] = extractH(img,K1,K2,K3)


%%%%%%%%%%%%%%%%%%%%%%%
%% PREPROCESSING
%%%%%%%%%%%%%%%%%%%%%%%

%% to extract global features, transform to YCbCr
im_for_global = rgb2ycbcr(img);

%% to extract local features, transform image to gray scale
im_for_local = rgb2gray(img);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% LOCAL FEATURE EXTRACTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% local features
imagePoints = detectSURFFeatures(im_for_local);
[surf_imageFeatures, surf_imagePoints] = extractFeatures(im_for_local, imagePoints);

% imshow(im_for_local); hold on;
% plot(surf_imagePoints.selectStrongest(100));

imageFeatures = ConvertSurfFeaturesTypeToTransmisibleType(surf_imageFeatures);
surfFeatures = ConvertSurfFeaturesToTransmisibleArray(imageFeatures);

imagePoints = ConvertSurfPointsTypeToTransmisibleType(surf_imagePoints);
surfPoints = ConvertSurfPointsToTransmisibleArray(imagePoints);


% %% receptie surf points + test
% tempPoints = double(surfPoints)/10^10;
% count = tempPoints(1,1);
% 
% testPoints.Scale = single(tempPoints(1,2:count+1)');
% testPoints.SignOfLaplacian = int8(2*tempPoints(1,(2+count):(2*count)+1)' - 1);
% testPoints.Orientation = single(tempPoints(1,(2*count+2):(3*count)+1)');
% testPoints.Location(:,1) = single((tempPoints(1,(3*count+2) : (4*count)+1))');
% testPoints.Location(:,2) = single((tempPoints(1,(4*count+2) : (5*count)+1))');
% testPoints.Metric = single(tempPoints(1,(5*count+2) : (6*count)+1)');
% testPoints.Count = tempPoints(1,1);
% 
% testPoints.Count == imagePoints.Count
% sum(sum(testPoints.Scale == imagePoints.Scale))/count
% sum(sum(testPoints.SignOfLaplacian == imagePoints.SignOfLaplacian))/count
% sum(sum(testPoints.Orientation == imagePoints.Orientation))/count
% sum(sum(testPoints.Location(:,1) == imagePoints.Location(:,1)))/count
% sum(sum(testPoints.Location(:,2) == imagePoints.Location(:,2)))/count
% sum(sum(testPoints.Metric == imagePoints.Metric))/count
% %% sf receptie + test

%% local features as L' and S

L_prime = [uint64(10^10*size(surfFeatures,2)) surfFeatures surfPoints]; % L' = [lengthF sF sP]

%% Computing secret key K1 to generate Y1 and obtain first intermediate "hash", L
% K1 = 2^15;

Y1_array = randerr(size(L_prime,2),64, 64/2, K1);
Y1 = uint64(bi2de(Y1_array)');

L = mod((L_prime + Y1),2^64);
sum(L==2^64);

% %% test . get L_prime back
% 
% newL_prime = mod((L - Y1),2^64);
% sum(newL_prime==2^64)
% 
% sum(newL_prime == L_prime) / size(L_prime,2)
% %% end test

% hash_L = GetMD5(L,'8bit','HEX');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% GLOBAL FEATURE EXTRACTION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Zernik moment constants
% help: https://perso.liris.cnrs.fr/cwolf/software/zernike/index.html
% algorithm:
% 0. centersquare(image,dim_image)
% 1. Calculate the Zernike basis functions up to order ORDER for a
%  square image of size SZ (rows = cols!)
% 2. Calculate the Zernike moments from an image.
% 
% We need abs(Z) = magnitudes of the Zernike moments

%% Computing luminance and chrominance characteristics. COMPLEX ZERNIKE MOMENT
%% Y luminance
Y_image = im_for_global(:,:,1);
% m=centersquare(Y_image,size(Y_image,1));
% m=uint8(m);

zbf_y = zernike_bf(256,5); % 1. %% --->>> size(img)
% Zy = zernike_mom(m, zbf_y); % 2.
Zy_temp = zernike_mom(Y_image, zbf_y); % 2.
Zy_temp = abs(Zy_temp); % Magnitudes
Zy_rows = size(Zy_temp,1); Zy_cols = size(Zy_temp,2); % First element represents the average intensity
Zy(1:Zy_rows-1,1:Zy_cols) = Zy_temp(2:Zy_rows, 1:Zy_cols); % Drop the first element.
Zy = uint8(255 * Zy./(max(Zy))); % normalized [0,255]
%% |Cb-Cr| chrominance
ABS_Cb_Cr_image = uint8(abs(double(im_for_global(:,:,2)) - double(im_for_global(:,:,3))));

zbf_cb_cr = zernike_bf(256,5);
Zc_temp = zernike_mom(ABS_Cb_Cr_image, zbf_cb_cr); 
Zc_temp = abs(Zc_temp);
Zc_rows = size(Zc_temp,1); Zc_cols = size(Zc_temp,2);
Zc(1:Zc_rows-1,1:Zc_cols) = Zc_temp(2:Zc_rows, 1:Zc_cols);
Zc = uint8(255 * Zc./(max(Zc)));
% - normalizare asa sau / max din ambii vectori -- de vazut! Conteaza?

%% Z' = [Zy Zc];
Z_prime = uint64([Zy; Zc]');
%% Computing secret key K2 to generate Y2 and obtain second intermediate "hash", Z
% K2 = 2^15;

Y2_array = randerr(22,64, 64/2, K2);
Y2 = uint64(bi2de(Y2_array)');

Z = mod((Z_prime + Y2),2^64);

%% test Z, get Z_prime back
newZ_prime = mod(Z - Y2, 2^64);

Z_prime == newZ_prime;

%% end test

% hash_Z = GetMD5(Z,'8bit','HEX');
%% Computing secret key K3 to generate Y3 and obtain final "hash" h. Also MD5 hash of h for fast authenticating
% h_prime = [hash_Z hash_L];
h_prime = [Z L];

h = uint64(h_prime);



end