function plotRMSE(nData,nRMSE,sDataPath,sPath)

%% RMSE Histograms

% Define signals
nElbowDOFs = [19];
nWristDOFs = [1:2 20];
nThumbDOFs = [3:6];
nFingerDOFs = [7:18];

figure
hElbow = histogram(nRMSE(nElbowDOFs,:));
title('Elbow RMSE')

figure
hWrist = histogram(nRMSE(nWristDOFs,:));
title('Wrist RMSE')

figure
hThumb = histogram(nRMSE(nThumbDOFs,:));
title('Thumb RMSE')

figure
hFinger = histogram(nRMSE(nFingerDOFs,:));
title('Finger RMSE')

%% Normalize RMSE Data
sSignalList         = fields(nData);
bTime               = strcmp(sSignalList,'tTime');
sSignalList(bTime)  = [];
nSignal             = numel(sSignalList);

% Define signals
nElbowDOFs = [19];
nWristDOFs = [1:2 20];
nThumbDOFs = [3:6];
nFingerDOFs = [7:18];

for i = 1:numel(nData)
    cData(:,i) = struct2cell(nData(i));
end
 nDataF = cell2mat(cData');

 %Create data array of the max values for each DOF
for k = 1:nSignal
    nDOF_Max(k) = max(nDataF(:,k));
end

%Organize max values by DOF category (Elbow, wrist, thumb, fingers)
nElbowMax = max(nDOF_Max(nElbowDOFs));
nWristMax = max(nDOF_Max(nWristDOFs));
nThumbMax = max(nDOF_Max(nThumbDOFs));
nFingerMax = max(nDOF_Max(nFingerDOFs));

%Normalize RMSE data by DOF category
nNormRMSE_Elbow = nRMSE(nElbowDOFs,:)/nElbowMax;
nNormRMSE_Wrist = nRMSE(nWristDOFs,:)/nWristMax;
nNormRMSE_Thumb = nRMSE(nThumbDOFs,:)/nThumbMax;
nNormRMSE_Finger = nRMSE(nFingerDOFs,:)/nFingerMax;

%Normalized RMSE Histograms
figure
hElbow = histogram(nNormRMSE_Elbow);
title('Normalized Elbow RMSE')

figure
hWrist = histogram(nNormRMSE_Wrist);
title('Normalized Wrist RMSE')

figure
hThumb = histogram(nNormRMSE_Thumb);
title('Normalized Thumb RMSE')

figure
hFinger = histogram(nNormRMSE_Finger);
title('Normalized Finger RMSE')
