%% 
%  This script changes the field names of OpenSim output files to match 
%  those from the Simulink model
%%

function sFileFull = setFields(sDataPath,sFullmat)

sPathRef     = sDataPath;
sDir = dir(sPathRef);
for iFile = 4:numel(sDir)   
    sFileList(iFile-3) = {sDir(iFile).name};   
end
nFile = numel(sFileList);
for iFile = 1:nFile
    sFileFull       = [sPathRef,filesep,sFileList{iFile}];
    load(sFileFull);
    if iFile == 1
        sDOFlist = fields(tor);
        bTime = strfind(sDOFlist,'time');
        for iRep = 1:numel(bTime)
            if bTime{iRep} == 1
                sDOFlist(iRep) = [];
                break
            end
        end
    end
    for iDOF = 1:numel(sDOFlist)
        sDOF = sDOFlist{iDOF};
        sDOF1 = sDOF(1:end-7);
        tor1.(sDOF1) = tor.(sDOF);
    end
    tor1.tTime = tor.time;
    tor = tor1;
    save(sFileFull,'tor');
end