function [errZ2, errZ, matchedImg, SurfFeatures, SurfPoints, matchedImg1, SurfFeatures1, SurfPoints1, boxPairs] = doMain(fileName1, fileName2)
img = imread(fileName1);
% figure()
% imshow(img), title('Original image');

%% sender
K1 = 2^11;
K2 = 2^13;
K3 = 2^15;
[Sender.L_prime, Sender.L, Sender.Z_prime, Sender.Z, Sender.h_prime, Sender.h] = extractH(img, K1, K2, K3);

%% receiver
% L0 = M0; L0_prime = M0_prime
h0 = Sender.h; % "primit de la sender"
h0_prime = h0;
Z0 = h0_prime(1:22);
L0 = h0_prime(23:end);

receivedImg = imread(fileName2);
[Receiver.L_prime, Receiver.L, Receiver.Z_prime, Receiver.Z, Receiver.h_prime, Receiver.h] = extractH(receivedImg, K1, K2, K3); % calculat local

%% testing zone

% testing de verificare
test_h = sum(h0_prime == Sender.h_prime)/length(h0_prime); 
test_Z = sum(Z0 == Sender.Z)/length(Z0);
test_L = sum(L0 == Sender.L)/length(L0);
% sf testing
%

%% prima data se compara h0_prime cu h_prime2
% deci avem de la sender, descifrat local, hash intermediare: [Z0 L0]
% la receiver avem ca hash intermediare: [Z2 L2]
% care se compara (pas 1)
%
% pas 2. calculez: DL = L0_prime - L1_prime adica DL = L0_decrypted -
% L2_decrypted


%% 


% L SENDER = [ dimSF surfFeatures surfPoints ]
L0_decrypted = decryptHash(L0, K1);
% DL = L0_decrypted - L2_decrypted;

Sender.dimSF = double(L0_decrypted(1,1))/10^10;
tempSurfFeatures = L0_decrypted(1,2:Sender.dimSF+1);
tempSurfPoints = L0_decrypted(2+Sender.dimSF: end);

% receive surf features and test
[SurfFeatures,l,c] = ConvertArraySurfFeaturesToSurfFeatures(tempSurfFeatures);
% end receive surf features and test

% receptie surf points + test
tempPoints = double(tempSurfPoints)/10^10;
count = tempPoints(1,1);

SurfPoints.Scale = single(tempPoints(1,2:count+1)');
SurfPoints.SignOfLaplacian = int8(2*tempPoints(1,(2+count):(2*count)+1)' - 1);
SurfPoints.Orientation = single(tempPoints(1,(2*count+2):(3*count)+1)');
SurfPoints.Location(:,1) = single((tempPoints(1,(3*count+2) : (4*count)+1))');
SurfPoints.Location(:,2) = single((tempPoints(1,(4*count+2) : (5*count)+1))');
SurfPoints.Metric = single(tempPoints(1,(5*count+2) : (6*count)+1)');
SurfPoints.Count = tempPoints(1,1);

% sf receptie + test

% L RECEIVER = [ dimSF surfFeatures surfPoints ]
L2_decrypted = Receiver.L_prime;
% DL = L0_decrypted - L2_decrypted;

Receiver.dimSF = double(L2_decrypted(1,1))/10^10;
tempSurfFeatures = L2_decrypted(1,2:Receiver.dimSF+1);
tempSurfPoints = L2_decrypted(2+Receiver.dimSF: end);

% receive surf features and test
[SurfFeatures1,l,c] = ConvertArraySurfFeaturesToSurfFeatures(tempSurfFeatures);
% end receive surf features and test

% receptie surf points + test
tempPoints = double(tempSurfPoints)/10^10;
count = tempPoints(1,1);

SurfPoints1.Scale = single(tempPoints(1,2:count+1)');
SurfPoints1.SignOfLaplacian = int8(2*tempPoints(1,(2+count):(2*count)+1)' - 1);
SurfPoints1.Orientation = single(tempPoints(1,(2*count+2):(3*count)+1)');
SurfPoints1.Location(:,1) = single((tempPoints(1,(3*count+2) : (4*count)+1))');
SurfPoints1.Location(:,2) = single((tempPoints(1,(4*count+2) : (5*count)+1))');
SurfPoints1.Metric = single(tempPoints(1,(5*count+2) : (6*count)+1)');
SurfPoints1.Count = tempPoints(1,1);

% sf receptie + test

min1 = size(SurfFeatures,1);
min2 = size(SurfFeatures1,1);
if(min1<min2)
    boxPairs = matchFeatures(SurfFeatures, SurfFeatures1(1:size(SurfFeatures,1),:), 'unique', true);
else 
    boxPairs = matchFeatures(SurfFeatures(1:size(SurfFeatures1,1),:), SurfFeatures1, 'unique', true);
end

matchedImg.Scale = SurfPoints.Scale(boxPairs(:,1));
matchedImg.SignOfLaplacian = SurfPoints.SignOfLaplacian(boxPairs(:,1));
matchedImg.Orientation = SurfPoints.Orientation(boxPairs(:,1));
matchedImg.Location = SurfPoints.Location(boxPairs(:,1),:);
matchedImg.Metric = SurfPoints.Metric(boxPairs(:,1));
matchedImg.Count = size(boxPairs(:,1),1);

matchedImg1.Scale = SurfPoints1.Scale(boxPairs(:,2));
matchedImg1.SignOfLaplacian = SurfPoints1.SignOfLaplacian(boxPairs(:,2));
matchedImg1.Orientation = SurfPoints1.Orientation(boxPairs(:,2));
matchedImg1.Location = SurfPoints1.Location(boxPairs(:,2),:);
matchedImg1.Metric = SurfPoints1.Metric(boxPairs(:,2));
matchedImg1.Count = size(boxPairs(:,2),1);
%%
%%
%%
%% receiver Z

Z2_decrypted = double(Receiver.Z_prime);
Z0_decrypted = double(decryptHash(Z0,K2));

% Receiverr.dimSF = doubl
% DZ = Z0_decrypted - Z2_decrypted;

% D = sum([DL DZ])/size([DL DZ],2);
% errL = abs(L0_decrypted - L2_decrypted)/L2_decrypted * 100;
errZ = abs(Z0_decrypted - Z2_decrypted)/Z0_decrypted * 100;
errZ2 = sum(sum(sqrt((Z0_decrypted - Z2_decrypted).^2)))/100;


% if(object_name ~= 'none')
% save_path = strcat('data_test_',num2str(object_name),'.mat');
% save(save_path);
% end

end