function create_metaData(sFileName,sDataPath,smetaTablePath,sDriverPath,idTrialTypeList,idDOFsim_list)

%% metaSignal
nSignal = [1:length(idDOFsim_list)]';
sSignalRaw = {'ra_el_e_f','ra_wr_s_p','ra_wr_e_f','ra_wr_ad_ab','ra_cmc1_ad_ab','ra_cmc1_f_e','ra_mcp2_e_f','ra_mcp3_e_f','ra_mcp4_e_f','ra_mcp5_e_f','ra_mcp1_f_e','ra_pip2_e_f','ra_pip3_e_f','ra_pip4_e_f','ra_pip5_e_f','ra_ip1_f_e','ra_dip2_e_f','ra_dip3_e_f','ra_dip4_e_f','ra_dip5_e_f'}';
sSignal = sSignalRaw;

tor = {'tor'};
nRate = zeros(20,1);
Nm = {'Nm'};
sim = {'sim'};
for i = 1:length(nSignal)
    sTable_0(i) = string(tor);
    nRate(i) = 1000;
    sUnit_0(i) = string(Nm);
    sNote_0(i) = sim;
end
sTable = sTable_0';
sUnit = sUnit_0';
sNote = sNote_0';

metaSignal = table(nSignal,sSignalRaw,sSignal,sTable,nRate,sUnit,sNote);
cd(smetaTablePath); % Directory where you want the metaTables to go
writetable(metaSignal,'metaSignal.csv')
%% metaSubject
sSubject = {'Subject01'};
sPrefix = {'SIM'};
sSession = {'Session01'};
sNote = {'NA'};
nHeight = 1.5;
nDOByear = 1996;
sSex = {'m'};
nWeight = 75;

metaSubject = table(sSubject,sPrefix,sSession,sNote,nHeight,nDOByear,sSex,nWeight);
writetable(metaSubject,'metaSubject.csv')
%% metaTrial
sFile =  string(sFileName)';
sPath =  string(sDataPath);
sTrialType = {'Reach 1','Grasp 1'}';
nTrial = [1:length(idTrialTypeList)]';

bTrial = zeros(length(nTrial),1);
tSync = zeros(length(nTrial),1);
nSampleStart = zeros(length(nTrial),1);
nSampleEnd = cell(length(nTrial),1);
idTrial = cell(length(nTrial),1);
sim = {'sim'};
for i = 1:length(nTrial)
    sPath_0(i) = string(sPath);
    sSubject_0(i) = string(sSubject);
    sPrefix_0(i) = string(sPrefix);
    bTrial(i) = 1;
    sSession_0(i) = string(sSession);
    nSampleStart(i) = 1;
    sModel_0(i) = string(sim);
end
sSubject = sSubject_0';
sPrefix = sPrefix_0';
sSession = sSession_0';
sModel = sModel_0';
sPath = sPath_0';

metaTrial = table(sFile,sPath,sTrialType,sSubject,sPrefix,bTrial,nTrial,tSync,sSession,idTrial,nSampleStart,nSampleEnd,sModel);
writetable(metaTrial,'metaTrial.csv')
%% metaTrialType
idTrialType = nTrial;

metaTrialType = table(idTrialType,sTrialType);
writetable(metaTrialType,'metaTrialType.csv')
cd(sDriverPath); % Return to 'run_simbody_hand' directory