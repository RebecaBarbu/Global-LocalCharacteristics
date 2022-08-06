clear; close all;clc;
addpath('./zernike/');
addpath('./images/Compressed/Flowers/');
addpath('./images/Compressed/Lighthouse/');
addpath('./images/Compressed/Lena/');
addpath('./images/Compressed/Pisica/');
addpath('./images/Compressed/Pylon/');
addpath('./images/Compressed/Car/');

Q_forced = 50;
dim_imag_forced = 256; % min

object_array = ["Car", "Flowers", "Lena" ,"Lighthouse" ,"Pisica", "Pylon"];

for j=1:size(object_array,2)
    
    fileName1 = strcat(object_array(1,j),'_compressed_100.jpg');
    fileName2 = strcat(object_array(1,j),'_compressed_50.jpg');
       
       
    [fileName1, fileName2] = force_Redimen_50Quantiz(Q_forced,dim_imag_forced, fileName1, fileName2);
    [errZ2, errZ, matchedImg, SurfFeatures, SurfPoints, matchedImg1, SurfFeatures1, SurfPoints1, matchedPairs] = doMain(fileName1, fileName2);
    figure(j),showMatchedFeatures(imread(fileName1),imread(fileName2), matchedImg.Location, matchedImg1.Location, 'montage'); title(strcat('rezultat test', object_array(1,j) , '_',num2str(j)));

    pragZ = errZ; pragZ2 = errZ2;
    display(strcat('pragZ:',num2str(pragZ), ' pragZ2:', num2str(pragZ2)));
    
    pragF = sum(sum(sqrt((SurfFeatures(matchedPairs(:,1)) - SurfFeatures(matchedPairs(:,2))).^2)))/100;
    display(strcat('prag features: ',num2str(pragF), 'features 1:', num2str(size(SurfFeatures,1)), 'features 2:', num2str(size(SurfFeatures1,1))));
    
    pragS = sum(sum(sqrt((matchedImg.Scale - matchedImg1.Scale).^2)))/100;
    display(strcat('prag matched Scale: ',num2str(pragS)));
    
%     errorSOL = sum(sum(sqrt((matchedImg.SignOfLaplacian - matchedImg1.SignOfLaplacian).^2)))/100;
%     display(strcat('eroare matched SignOfLaplacian: ',num2str(errorF)));
    
    pragO = sum(sum(sqrt((matchedImg.Orientation - matchedImg1.Orientation).^2)))/100;
    display(strcat('prag matched Orientation: ',num2str(pragO)));
    
    pragL1 = sum(sum(sqrt((matchedImg.Location(:,1) - matchedImg1.Location(:,1)).^2)))/100;
    display(strcat('prag matched Location1: ',num2str(pragL1)));
    
    pragL2 = sum(sum(sqrt((matchedImg.Location(:,2) - matchedImg1.Location(:,2)).^2)))/100;
    display(strcat('prag matched Location2: ',num2str(pragL2)));
    
    pragM = sum(sum(sqrt((matchedImg.Metric - matchedImg1.Metric).^2)))/100;
    display(strcat('prag matched Metric: ',num2str(pragM)));
    
    
    display(strcat('surfpoints count', num2str(SurfPoints.Count), '-', num2str(SurfPoints1.Count))); 
    
    save_path = strcat('./data/data_', object_array(1,j) ,'.mat');
    save(save_path);
end


