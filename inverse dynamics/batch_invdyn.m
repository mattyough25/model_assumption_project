% EXAMPLE
% % File Names
% % Kinematics Files
% % sPath = 'G:\Shared drives\LABS\PROJECTS\PRJ OS Model Kinematic Hand\Inverse dynamics\Results_18DOF';
% % sFile = 'Tor_idSubject6_idTrialType202.mat';
% % kinfile = [sPath,filesep,sFile];
% % 
% % sRepoPath = 'C:\Repositories\os_kin_hand';
% % 
% % Motion File
% % motfilename='TrialMotion.mot';
% % 
% % XML File for Inverse Dynamics
% % xmlfilename = 'TrialXML.xml';
% % 
% % STO Output
% % stofilename = 'TrialResults.sto';
% %
% % matfilename = 'TrialResults.mat'
% % 
% % Opensim model
% % sModelPath ='C:\Repositories\os_kin_hand\Model';
% % sModelName ='full_arm_model_osv4.osim';
% % sModel = [sModelPath,filesep,sModelName];

function tSimTime = batch_invdyn(sDataPath,sRepoPath,kinfile,motfilename,xmlfilename,stofilename,matfilename,sModel)

%% Inverse Dynamics Folder Path
sPath = [sRepoPath];

%% Load metaDOF CSV
try
metaDOF = load_csv('sFile','metaDOF_arm.csv');
catch
    disp('File not found. Please select it manually');
    metaDOF = load_csv();
end

%% Convert mat file to mot file
sSimTime = mat2mot(kinfile,motfilename,metaDOF,'units','rad');

%% Create XML File
sFullXML = [cd,filesep,'xml files',filesep,xmlfilename];
sFullMOT = [cd,filesep,'mot files',filesep,motfilename];

resultspath = [sPath,filesep,'results'];
write_id_xml(sModel,sSimTime,sFullMOT,sFullXML,stofilename,resultspath)

%% Inverse Dynamics
% Pull in the modeling classes straight from the OpenSim distribution
tic
import org.opensim.modeling.*
osim = Model(sModel);

% Initialize System
osim.initSystem();

% Run Inverse Dynamics
idTool = InverseDynamicsTool(sFullXML);

% Tell Tool to use the loaded model
idTool.setModel(osim);
% idTool.setOutputGenForceFileName(stofilename)

 %Run IK
 idTool.run()
 tSimTime = toc;

 %% Convert sto to mat
 sFullSTO = [cd,filesep,'results',filesep,stofilename];
 
tor = sto2mat(sFullSTO);
cd(sDataPath);
save(matfilename,'tor')
cd(sRepoPath)
 
 %% Forward Dynamics
 
% fdpath = [sRepoPath,filesep,'forward dynamics'];
% cd(fdpath);
% 
% actuators = [sRepoPath,filesep,'forward dynamics',filesep,...
%     'actuator files',filesep,'Trial_Actuators.xml'];
% createActuators(osim,actuators);
%  
%  % Initialize System
% osim.initSystem();
% 
% fdTool = ForwardTool();
% 
% fdTool.setModel(osim);
% 
% fdTool.run();
 
 



