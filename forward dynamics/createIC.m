sFileMOT = 'C:\Repositories\os_hand_kin\inverse dynamics\19DOF\mot files\Sim_RHand_19DOF_Inv_idTrialType1_idTrial1.mot';
IC_fileName = 'InitialConditions.sto';
% function createIC(sFileMOT,IC_fileName)

FID = fopen(sFileMOT,'r');

formatSpec = ['%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s ',...
    '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s'];

sText = textscan(FID, formatSpec,'Delimiter','\t','EmptyValue',-Inf);
fclose(FID);

nHeaderRow = 7;
nDataRow = 8;
nCol = 20;

FID_new = fopen(IC_fileName,'wb');

fprintf(FID_new,'Initial Conditions\n');
fprintf(FID_new,'version=1\n');
fprintf(FID_new,['nRows=',num2str(nDataRow),'\n']);
fprintf(FID_new,['nColumns=',num2str(nCol),'\n']);
fprintf(FID_new,'inDegrees=no\n');
fprintf(FID_new,'endheader\n');

% Write Column Headers
for ix = 1:nCol
    
    if ix == nCol
        fprintf(FID,[sText{1,ix}{nHeaderRow,1},'\n']);
    else
        fprintf(FID,[sText{1,ix}{nHeaderRow,1},'\t']);
    end
end

% Write Initial Conditions
for ix = 1:nCol
    
    if ix == nCol
        fprintf(FID,[sText{1,ix}{nDataRow,1},'\n']);
    else
        fprintf(FID,[sText{1,ix}{nDataRow,1},'\t']);
    end
end