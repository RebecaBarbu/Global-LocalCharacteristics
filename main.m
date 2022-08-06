%% testing zone
clear; close all ;clc;

%%
addpath('./zernike/');
addpath('./data/');
addpath('./functions/');

addpath('./images/Compressed/Flowers/');
addpath('./images/Compressed/Lighthouse/');
addpath('./images/Compressed/Lena/');
addpath('./images/Compressed/Pisica/');
addpath('./images/Compressed/Pylon/');
addpath('./images/Compressed/Car/');

addpath('./images/Fake/Car');
addpath('./images/Fake/Lighthouse');
addpath('./images/Fake/Flowers');
addpath('./images/Fake/Pisica');
addpath('./images/Fake/Pylon');
addpath('./images/Fake/Lena');

addpath('./images/Resized/Car');
addpath('./images/Resized/Lighthouse');
addpath('./images/Resized/Flowers');
addpath('./images/Resized/Pisica');
addpath('./images/Resized/Pylon');
addpath('./images/Resized/Lena');

addpath('./images/Intensity/Minus/Car');
addpath('./images/Intensity/Minus/Lighthouse');
addpath('./images/Intensity/Minus/Flowers');
addpath('./images/Intensity/Minus/Pisica');
addpath('./images/Intensity/Minus/Pylon');
addpath('./images/Intensity/Minus/Lena');

addpath('./images/Intensity/Plus/Car');
addpath('./images/Intensity/Plus/Lighthouse');
addpath('./images/Intensity/Plus/Flowers');
addpath('./images/Intensity/Plus/Pisica');
addpath('./images/Intensity/Plus/Pylon');
addpath('./images/Intensity/Plus/Lena');
%%
object_array = ["Car", "Flowers", "Lena" ,"Lighthouse" ,"Pisica", "Pylon"];
prag_nr_features = 50;

for j=1:size(object_array,2)
    load(strcat('./data/data_', object_array(1,j) ,'.mat'));
    display(strcat('Obiect= ', object_array(1,j)));
	Q_forced = 50;
	dim_imag_forced = 256; % min
	nivel = 100;
    
    %% test compresie jpeg
    display('=====================');
    display('=====================');
    display('Test compresie JPEG ');
	for i=1:6
		display(strcat('=====================================test', num2str(i), '====================================='));
		
	%     fileName1 = strcat('patrat_2_compressed_100.jpg');
		fileName1 = strcat(object_array(1,j),'_compressed_100.jpg');
		fileName2 = strcat(object_array(1,j),'_compressed_',num2str(nivel),'.jpg');
% 		figure,subplot(1,2,1), imshow(imread(fileName1)); title('original'); subplot(1,2,2); imshow(imread(fileName2)); title('modificat');
        
		[fileName1, fileName2] = force_Redimen_50Quantiz(Q_forced,dim_imag_forced, fileName1, fileName2);
		[errZ2, errZ, matchedImg, SurfFeatures, SurfPoints, matchedImg1, SurfFeatures1, SurfPoints1, matchedPairs] = doMain(fileName1, fileName2);
		figure(i),showMatchedFeatures(imread(fileName1),imread(fileName2), matchedImg.Location, matchedImg1.Location, 'montage'); title(strcat('rezultat test ',num2str(i)));
	
		display(strcat('errorZ:',num2str(errZ), ' errorZ2:', num2str(errZ2)));
		
		errorF = sum(sum(sqrt((SurfFeatures(matchedPairs(:,1)) - SurfFeatures(matchedPairs(:,2))).^2)))/100;
		display(strcat('eroare features: ',num2str(errorF), 'features 1:', num2str(size(SurfFeatures,1)), 'features 2:', num2str(size(SurfFeatures1,1))));
		
		errorS = sum(sum(sqrt((matchedImg.Scale - matchedImg1.Scale).^2)))/100;
		display(strcat('eroare matched Scale: ',num2str(errorS)));
		
	%     errorSOL = sum(sum(sqrt((matchedImg.SignOfLaplacian - matchedImg1.SignOfLaplacian).^2)))/100;
	%     display(strcat('eroare matched SignOfLaplacian: ',num2str(errorF)));
		
		errorO = sum(sum(sqrt((matchedImg.Orientation - matchedImg1.Orientation).^2)))/100;
		display(strcat('eroare matched Orientation: ',num2str(errorO)));
		
		errorL1 = sum(sum(sqrt((matchedImg.Location(:,1) - matchedImg1.Location(:,1)).^2)))/100;
		display(strcat('eroare matched Location1: ',num2str(errorL1)));
		
		errorL2 = sum(sum(sqrt((matchedImg.Location(:,2) - matchedImg1.Location(:,2)).^2)))/100;
		display(strcat('eroare matched Location2: ',num2str(errorL2)));
		
		errorM = sum(sum(sqrt((matchedImg.Metric - matchedImg1.Metric).^2)))/100;
		display(strcat('eroare matched Metric: ',num2str(errorM)));
		
		count1 = SurfPoints.Count; count2 = SurfPoints1.Count;
		display(strcat('surfpoints count', num2str(count1), '-', num2str(count2)));
		nivel = nivel-10;
		
        %% rezultat test
        display(' ');
        display(strcat('rezultat. scor_caracteristici_generale: <val_curenta=', num2str(errZ2), ' vs prag=', num2str(pragZ2),'> || scor_numar_caracteristici_locale: |', num2str(count1), ' - ', num2str(count2), '| = ', num2str(abs(count1-count2)), ' vs prag=', num2str(prag_nr_features)));
        if(errZ2 > pragZ2 || ( abs(count1 - count2) > prag_nr_features) )
            display('fals'); 
        else
            display('in regula');
        end
    end
    
    %% test falsificare
    
    display('=====================');
    display('=====================');
    display('Test falsificare ');
    for i=1:6
		display(strcat('=====================================test', num2str(i), '====================================='));
		
		fileName1 = strcat(object_array(1,j),'_compressed_100.jpg');
		fileName2 = strcat(object_array(1,j),'_modif_compressed_',num2str(i),'.jpg');
% 		figure,subplot(1,2,1), imshow(imread(fileName1)); title('original'); subplot(1,2,2); imshow(imread(fileName2)); title('modificat');
        
		[fileName1, fileName2] = force_Redimen_50Quantiz(Q_forced,dim_imag_forced, fileName1, fileName2);
		[errZ2, errZ, matchedImg, SurfFeatures, SurfPoints, matchedImg1, SurfFeatures1, SurfPoints1, matchedPairs] = doMain(fileName1, fileName2);
		figure(i),showMatchedFeatures(imread(fileName1),imread(fileName2), matchedImg.Location, matchedImg1.Location, 'montage'); title(strcat('rezultat test ',num2str(i)));
	
		display(strcat('errorZ:',num2str(errZ), ' errorZ2:', num2str(errZ2)));
		
		errorF = sum(sum(sqrt((SurfFeatures(matchedPairs(:,1)) - SurfFeatures(matchedPairs(:,2))).^2)))/100;
		display(strcat('eroare features: ',num2str(errorF), 'features 1:', num2str(size(SurfFeatures,1)), 'features 2:', num2str(size(SurfFeatures1,1))));
		
		errorS = sum(sum(sqrt((matchedImg.Scale - matchedImg1.Scale).^2)))/100;
		display(strcat('eroare matched Scale: ',num2str(errorS)));
		
	%     errorSOL = sum(sum(sqrt((matchedImg.SignOfLaplacian - matchedImg1.SignOfLaplacian).^2)))/100;
	%     display(strcat('eroare matched SignOfLaplacian: ',num2str(errorF)));
		
		errorO = sum(sum(sqrt((matchedImg.Orientation - matchedImg1.Orientation).^2)))/100;
		display(strcat('eroare matched Orientation: ',num2str(errorO)));
		
		errorL1 = sum(sum(sqrt((matchedImg.Location(:,1) - matchedImg1.Location(:,1)).^2)))/100;
		display(strcat('eroare matched Location1: ',num2str(errorL1)));
		
		errorL2 = sum(sum(sqrt((matchedImg.Location(:,2) - matchedImg1.Location(:,2)).^2)))/100;
		display(strcat('eroare matched Location2: ',num2str(errorL2)));
		
		errorM = sum(sum(sqrt((matchedImg.Metric - matchedImg1.Metric).^2)))/100;
		display(strcat('eroare matched Metric: ',num2str(errorM)));
		
		
		count1 = SurfPoints.Count; count2 = SurfPoints1.Count;
		display(strcat('surfpoints count', num2str(count1), '-', num2str(count2)));
		nivel = nivel-10;
		
        %% rezultat test
        display(' ');
        display(strcat('rezultat. scor_caracteristici_generale: <val_curenta=', num2str(errZ2), ' vs prag=', num2str(pragZ2),'> || scor_numar_caracteristici_locale: |', num2str(count1), ' - ', num2str(count2), '| = ', num2str(abs(count1-count2)), ' vs prag=', num2str(prag_nr_features)));
        if(errZ2 > pragZ2 || ( abs(count1 - count2) > prag_nr_features) )
            display('fals'); 
        else
            display('in regula');
        end
    end
    
    %% test resize
    
    display('=====================');
    display('=====================');
    display('Test resize ');
    dim = [128 128];
	for i=1:6
		display(strcat('=====================================test', num2str(i), '====================================='));
		dim = 2*dim;
		fileName1 = strcat(object_array(1,j),'_compressed_100.jpg');
		fileName2 = strcat(object_array(1,j),'_', num2str(dim), '_compressed_',num2str(i),'.jpg');
% 		figure,subplot(1,2,1), imshow(imread(fileName1)); title('original'); subplot(1,2,2); imshow(imread(fileName2)); title('modificat');
        
		[fileName1, fileName2] = force_Redimen_50Quantiz(Q_forced,dim_imag_forced, fileName1, fileName2);
		[errZ2, errZ, matchedImg, SurfFeatures, SurfPoints, matchedImg1, SurfFeatures1, SurfPoints1, matchedPairs] = doMain(fileName1, fileName2);
		figure(i),showMatchedFeatures(imread(fileName1),imread(fileName2), matchedImg.Location, matchedImg1.Location, 'montage'); title(strcat('rezultat test ',num2str(i)));
	
		display(strcat('errorZ:',num2str(errZ), ' errorZ2:', num2str(errZ2)));
		
		errorF = sum(sum(sqrt((SurfFeatures(matchedPairs(:,1)) - SurfFeatures(matchedPairs(:,2))).^2)))/100;
		display(strcat('eroare features: ',num2str(errorF), 'features 1:', num2str(size(SurfFeatures,1)), 'features 2:', num2str(size(SurfFeatures1,1))));
		
		errorS = sum(sum(sqrt((matchedImg.Scale - matchedImg1.Scale).^2)))/100;
		display(strcat('eroare matched Scale: ',num2str(errorS)));
		
	%     errorSOL = sum(sum(sqrt((matchedImg.SignOfLaplacian - matchedImg1.SignOfLaplacian).^2)))/100;
	%     display(strcat('eroare matched SignOfLaplacian: ',num2str(errorF)));
		
		errorO = sum(sum(sqrt((matchedImg.Orientation - matchedImg1.Orientation).^2)))/100;
		display(strcat('eroare matched Orientation: ',num2str(errorO)));
		
		errorL1 = sum(sum(sqrt((matchedImg.Location(:,1) - matchedImg1.Location(:,1)).^2)))/100;
		display(strcat('eroare matched Location1: ',num2str(errorL1)));
		
		errorL2 = sum(sum(sqrt((matchedImg.Location(:,2) - matchedImg1.Location(:,2)).^2)))/100;
		display(strcat('eroare matched Location2: ',num2str(errorL2)));
		
		errorM = sum(sum(sqrt((matchedImg.Metric - matchedImg1.Metric).^2)))/100;
		display(strcat('eroare matched Metric: ',num2str(errorM)));
		
		
		count1 = SurfPoints.Count; count2 = SurfPoints1.Count;
		display(strcat('surfpoints count', num2str(count1), '-', num2str(count2)));
		nivel = nivel-10;
		
        %% rezultat test
        display(' ');
        display(strcat('rezultat. scor_caracteristici_generale: <val_curenta=', num2str(errZ2), ' vs prag=', num2str(pragZ2),'> || scor_numar_caracteristici_locale: |', num2str(count1), ' - ', num2str(count2), '| = ', num2str(abs(count1-count2)), ' vs prag=', num2str(prag_nr_features)));
        if(errZ2 > pragZ2 || ( abs(count1 - count2) > prag_nr_features) )
            display('fals'); 
        else
            display('in regula');
        end
    
    end
    
    %% test luminozitate - plus
    
    display('=====================');
    display('=====================');
    display('Test modificare luminozitate pe plus ');
    intensity = 0;
	for i=1:6
		display(strcat('=====================================test', num2str(i), '====================================='));
		intensity = intensity+20;
		fileName1 = strcat(object_array(1,j),'_compressed_100.jpg');
		fileName2 = strcat(object_array(1,j),'_', num2str(intensity), '_compressed_',num2str(i),'.jpg');
% 		figure,subplot(1,2,1), imshow(imread(fileName1)); title('original'); subplot(1,2,2); imshow(imread(fileName2)); title('modificat');
        
		[fileName1, fileName2] = force_Redimen_50Quantiz(Q_forced,dim_imag_forced, fileName1, fileName2);
		[errZ2, errZ, matchedImg, SurfFeatures, SurfPoints, matchedImg1, SurfFeatures1, SurfPoints1, matchedPairs] = doMain(fileName1, fileName2);
		figure(i),showMatchedFeatures(imread(fileName1),imread(fileName2), matchedImg.Location, matchedImg1.Location, 'montage'); title(strcat('rezultat test ',num2str(i)));
	
		display(strcat('errorZ:',num2str(errZ), ' errorZ2:', num2str(errZ2)));
		
		errorF = sum(sum(sqrt((SurfFeatures(matchedPairs(:,1)) - SurfFeatures(matchedPairs(:,2))).^2)))/100;
		display(strcat('eroare features: ',num2str(errorF), 'features 1:', num2str(size(SurfFeatures,1)), 'features 2:', num2str(size(SurfFeatures1,1))));
		
		errorS = sum(sum(sqrt((matchedImg.Scale - matchedImg1.Scale).^2)))/100;
		display(strcat('eroare matched Scale: ',num2str(errorS)));
		
	%     errorSOL = sum(sum(sqrt((matchedImg.SignOfLaplacian - matchedImg1.SignOfLaplacian).^2)))/100;
	%     display(strcat('eroare matched SignOfLaplacian: ',num2str(errorF)));
		
		errorO = sum(sum(sqrt((matchedImg.Orientation - matchedImg1.Orientation).^2)))/100;
		display(strcat('eroare matched Orientation: ',num2str(errorO)));
		
		errorL1 = sum(sum(sqrt((matchedImg.Location(:,1) - matchedImg1.Location(:,1)).^2)))/100;
		display(strcat('eroare matched Location1: ',num2str(errorL1)));
		
		errorL2 = sum(sum(sqrt((matchedImg.Location(:,2) - matchedImg1.Location(:,2)).^2)))/100;
		display(strcat('eroare matched Location2: ',num2str(errorL2)));
		
		errorM = sum(sum(sqrt((matchedImg.Metric - matchedImg1.Metric).^2)))/100;
		display(strcat('eroare matched Metric: ',num2str(errorM)));
		
		
		count1 = SurfPoints.Count; count2 = SurfPoints1.Count;
		display(strcat('surfpoints count', num2str(count1), '-', num2str(count2)));
		nivel = nivel-10;
		
        %% rezultat test
        display(' ');
        display(strcat('rezultat. scor_caracteristici_generale: <val_curenta=', num2str(errZ2), ' vs prag=', num2str(pragZ2),'> || scor_numar_caracteristici_locale: |', num2str(count1), ' - ', num2str(count2), '| = ', num2str(abs(count1-count2)), ' vs prag=', num2str(prag_nr_features)));
        if(errZ2 > pragZ2 || ( abs(count1 - count2) > prag_nr_features) )
            display('fals'); 
        else
            display('in regula');
        end
	end
    
    %% test luminozitate - minus
    
    display('=====================');
    display('=====================');
    display('Test modificare luminozitate pe minus ');
    intensity = 0;
	for i=1:6
		display(strcat('=====================================test', num2str(i), '====================================='));
		intensity = intensity-20;
		fileName1 = strcat(object_array(1,j),'_compressed_100.jpg');
		fileName2 = strcat(object_array(1,j),'_', num2str(intensity), '_compressed_',num2str(i),'.jpg');
% 		figure,subplot(1,2,1), imshow(imread(fileName1)); title('original'); subplot(1,2,2); imshow(imread(fileName2)); title('modificat');
        
		[fileName1, fileName2] = force_Redimen_50Quantiz(Q_forced,dim_imag_forced, fileName1, fileName2);
		[errZ2, errZ, matchedImg, SurfFeatures, SurfPoints, matchedImg1, SurfFeatures1, SurfPoints1, matchedPairs] = doMain(fileName1, fileName2);
		figure(i),showMatchedFeatures(imread(fileName1),imread(fileName2), matchedImg.Location, matchedImg1.Location, 'montage'); title(strcat('rezultat test ',num2str(i)));
	
		display(strcat('errorZ:',num2str(errZ), ' errorZ2:', num2str(errZ2)));
		
		errorF = sum(sum(sqrt((SurfFeatures(matchedPairs(:,1)) - SurfFeatures(matchedPairs(:,2))).^2)))/100;
		display(strcat('eroare features: ',num2str(errorF), 'features 1:', num2str(size(SurfFeatures,1)), 'features 2:', num2str(size(SurfFeatures1,1))));
		
		errorS = sum(sum(sqrt((matchedImg.Scale - matchedImg1.Scale).^2)))/100;
		display(strcat('eroare matched Scale: ',num2str(errorS)));
		
	%     errorSOL = sum(sum(sqrt((matchedImg.SignOfLaplacian - matchedImg1.SignOfLaplacian).^2)))/100;
	%     display(strcat('eroare matched SignOfLaplacian: ',num2str(errorF)));
		
		errorO = sum(sum(sqrt((matchedImg.Orientation - matchedImg1.Orientation).^2)))/100;
		display(strcat('eroare matched Orientation: ',num2str(errorO)));
		
		errorL1 = sum(sum(sqrt((matchedImg.Location(:,1) - matchedImg1.Location(:,1)).^2)))/100;
		display(strcat('eroare matched Location1: ',num2str(errorL1)));
		
		errorL2 = sum(sum(sqrt((matchedImg.Location(:,2) - matchedImg1.Location(:,2)).^2)))/100;
		display(strcat('eroare matched Location2: ',num2str(errorL2)));
		
		errorM = sum(sum(sqrt((matchedImg.Metric - matchedImg1.Metric).^2)))/100;
		display(strcat('eroare matched Metric: ',num2str(errorM)));
		
		
		count1 = SurfPoints.Count; count2 = SurfPoints1.Count;
		display(strcat('surfpoints count', num2str(count1), '-', num2str(count2)));
		nivel = nivel-10;
		
        %% rezultat test
        display(' ');
        display(strcat('rezultat. scor_caracteristici_generale: <val_curenta=', num2str(errZ2), ' vs prag=', num2str(pragZ2),'> || scor_numar_caracteristici_locale: |', num2str(count1), ' - ', num2str(count2), '| = ', num2str(abs(count1-count2)), ' vs prag=', num2str(prag_nr_features)));
        if(errZ2 > pragZ2 || ( abs(count1 - count2) > prag_nr_features) )
            display('fals'); 
        else
            display('in regula');
        end
	end
    
end


% 
% %% 
% % OKKKKK varianta 1
% clear; close all; clc;
% object_name = 'none';
% 
% addpath('./zernike/');
% addpath('./images/Compressed/Lena');
% addpath('./functions/');
% 
% Q_forced = 50;
% dim_imag_forced = 256; % min
% 
% % test0
% fileName1 = 'Lena_compressed100.jpg';
% fileName2 = 'Lena_compressed100.jpg';
% [fileName1, fileName2] = force_Redimen_50Quantiz(Q_forced,dim_imag_forced, fileName1, fileName2);
% 
% [errZ, matchedImg, SurfFeatures, SurfPoints, matchedImg1, SurfFeatures1, SurfPoints1] = doMain(fileName1, fileName2,object_name);
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %% daca exista data.mat, se poate rula direct de aici>> clear ; close all; clc;
% 
% errZ
% error = sum(sum(sqrt((matchedImg.Scale - matchedImg1.Scale).^2)))/100
% 
% % Display putatively matched features. 
% figure;
% showMatchedFeatures(imread(fileName1),imread(fileName2), matchedImg.Location, ...
%     matchedImg1.Location, 'montage');
% title('Putatively Matched Points (Including Outliers)');
% %%
% 
% 
% % 
% % % test1
% % fileName1 = 'compressed100_edited.jpg';
% % fileName2 = 'compressed100_edited.jpg';
% % [D,errL, errZ] = doMain(fileName1, fileName2);
% % D
% % errL
% % errZ
% % 
% % % test2
% % fileName1 = 'compressed100_edited2.jpg';
% % fileName2 = 'compressed100_edited2.jpg';
% % [D,errL, errZ] = doMain(fileName1, fileName2);
% % D
% % errL
% % errZ
% % % test3
% % fileName1 = 'compressed100_edited3.jpg';
% % fileName2 = 'compressed100_edited3.jpg';
% % [D,errL, errZ] = doMain(fileName1, fileName2);
% % D
% % errL
% % errZ
% % 
% % % test4
% % fileName1 = 'compressed100.jpg';
% % fileName2 = 'compressed100_edited.jpg';
% % [D,errL, errZ] = doMain(fileName1, fileName2);
% % D
% % errL
% % errZ
% % 
% % % test5
% % fileName1 = 'compressed100.jpg';
% % fileName2 = 'compressed100_edited2.jpg';
% % [D,errL, errZ] = doMain(fileName1, fileName2);
% % D
% % errL
% % errZ
% % 
% % % test6
% % fileName1 = 'compressed100.jpg';
% % fileName2 = 'compressed100_edited3.jpg';
% % [D,errL, errZ] = doMain(fileName1, fileName2);
% % D
% % errL
% % errZ
% % 
% % 
% 
% 
% 
% 
% %% Testing. Rezultate
% %% Compresie JPEG. varianta 1
% % 100 > 90 : 
% % ans = -0.0656
% % ans = 5.7465
% % ans = 0.1017
% 
% % 90 > 80:
% %
% % 6.99
% % 0.30
% 
% % 80 > 70
% % - 0.0519
% % 9.9
% % 0.2816
% 
% % 70 > 60
% % -0.0745
% % 10.92
% % 0.5992
% 
% % 60 > 50
% % -0.0595
% % 10.21%
% % 1.0387
% 
% % 50 > 40
% % -0.0611
% % 10.1214
% % 1.2184
% 
% % 40 > 30
% % -0.0787
% % 12.7214
% % 1.2853
% 
% % 30 > 20
% % -0.1243
% % 56.86
% % 1.5472
% 
% %% Compresie JPEG. varianta 2
% % 100 > 100
% % D =   -0.0674
% % errL =    2.1499
% % errZ =     0
% % 
% % 100 > 90
% % D =   -0.0656
% % errL =    5.7465
% % errZ =    0.1017
% % 
% % 100 > 80
% % D =   -0.0795
% % errL =    7.2702
% % errZ =    0.2066
% % 
% % 100 > 70
% % D =   -0.0640
% % errL =    9.4002
% % errZ =    0.2456
% % 
% % 100 > 60
% % D =   -0.0711
% % errL =    8.0769
% % errZ =    0.6755
% % 
% % 100 > 50
% % D =   -0.0632
% % errL =    8.2950
% % errZ =    0.7759
% % 
% % 100 > 40
% % D =   -0.0569
% % errL =   12.8893
% % errZ =    0.7508
% % 
% % 100 > 30
% % D =   -0.0682
% % errL =   19.8904
% % errZ =    0.6844
% % 
% % 100 > 20
% % D =   -0.0577
% % errL =   54.1499
% % errZ =    1.2850
% % 
% % 100 > 10
% % D =   -0.0929
% % errL =   57.6638
% % errZ =    3.9197
% % 
% %% Imagine modificata compres jpeg Q=100 
% % 
% % orig > orig
% % D =   -0.0674
% % errL =    2.1499
% % errZ =     0
% 
% % edited > edited 
% % D =   -0.0674
% % errL =    2.1956
% % errZ =     0
% % 
% % edited2 > edited2
% % D =   -0.0674
% % errL =    2.1711
% % errZ =     0
% % 
% % edited3 > edited3
% % D =   -0.0674
% % errL =    2.1891
% % errZ =     0
% % 
% % orig > edited
% % D =    0.1011
% % errL =    8.6022
% % errZ =   18.8099
% % modificare foarte mare
% % 
% % orig > edited2
% % D =   -0.0650
% % errL =    5.5016
% % errZ =    0.1982
% % 
% % orig > edited3
% % D =   -0.0232
% % errL =    6.7223
% % errZ =    5.7466
% % 
% % orig > edited4
% % D =    0.1106
% % errL =   10.8086
% % errZ =   19.9616
