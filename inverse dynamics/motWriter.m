% Inputs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% nDataList <cell> Cell of string names for columns usually muscle names for openSim
% nData <numeric> Matrix of data to be written. (First column needs to be time values)
% fileName <string> Name of the file.sto
%
% Output %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Creates a .sto file in the current directory with the filename specified
%
% Example Script %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% nTime = [0:0.0001:1];
% nInput = 0.2*gaussmf(nTime,[0.1,0.5]);
%
% nDataList = {'time','DELT3','DELT1','TRIlat','BICshort','BRA','APL','EDC',...
%              'EDCR','ECU','ECRL','FDPR','FCU','FCR'};
% nData = [nTime',nInput'*ones(1,14)];
% fileName = 'Trial.sto';
%
% stoWriter(nDataList,nData,fileName)
%
% By Matthew Boots

function motWriter(nDataList,nData,fileName)

nColumns = numel(nDataList);
nRows = numel(nData(:,1));
FID = fopen(fileName,'wb');

fprintf(FID,'Coordinates\n');
fprintf(FID,'version=1\n');
fprintf(FID,['nRows=',num2str(nRows),'\n']);
fprintf(FID,['nColumns=',num2str(nColumns),'\n']);
fprintf(FID,'inDegrees=no\n');
fprintf(FID,'endheader\n');

for i = 1:nColumns
    if i == nColumns
        fprintf(FID,[nDataList{i},'\n']);
    else
        fprintf(FID,[nDataList{i},'\t']);
    end
end

for i = 1:nRows
    for j = 1:nColumns
        if j == nColumns
            fprintf(FID,'%.6f\n',nData(i,j));
        else
            fprintf(FID,'%.6f\t',nData(i,j));
        end
    end
end