% Path to output torque data
sDataPath = '/Volumes/Computer2/Desktop/OpenSim Test Data';

% Kinematics Data Files
sPath = '/Volumes/Computer2/Desktop/Simulink Test Data'; %gets directory
sFilenames = dir(fullfile(sPath,'*.mat')); %gets all mat files in struct

% Path to Repository
sRepoPath = '/Volumes/Computer2/Documents/Repository/os_hand_kin/inverse dynamics'; 

%Open Sim Model
sModelPath = '/Volumes/Computer2/Documents/Repository/os_hand_kin/OpenSim_Model';
sModelName = 'full_arm_model_osv4_forearm_euler50.osim';

for k = 1:length(sFilenames)
   cd('/Volumes/Computer2/Documents/Repository/os_hand_kin/inverse dynamics');
  sFile = sFilenames(k).name;
  kinfile = [sPath,filesep,sFile];

  % File Naming
  sNewFiles = ['Sim_',sFile(1:end-4)];

  motfilename=[sNewFiles,'.mot'];
  xmlfilename = [sNewFiles,'.xml'];
  stofilename = [sNewFiles,'.sto'];
  matfilename = [sNewFiles,'.mat'];

  % Opensim model
  sModel = [sModelPath,filesep,sModelName];

  % Run Simulations
  tSimTime(k) = batch_invdyn(sDataPath,sRepoPath,kinfile,motfilename,xmlfilename,stofilename,matfilename,sModel);
end

% Change data file field names
sFullmat = [sDataPath,filesep,matfilename];
setFields(sDataPath,sFullmat);
