% Set path to subject specific folders
sParentPath = 'C:\Repositories\os_hand_kin\Data and Database\Subject Data';

% Pull directory contents to parent path
listing = dir(sParentPath);

% Remove Matlab '.' and '..' listed contents
listing(1:2) = [];

sPrefix = {'osim','sim'};
sDataFolder = {'OS','Sim'};

%%%FOR TROUBLESHOOTING, DONT FORGET TO REMOVE%%%
% listing(1:end-1) = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Iterate through each subject folder
for inxSubject = 1:numel(listing)
    
    multiWaitbar('Sessions',inxSubject/numel(listing),'Color',[0.8 0.0 0.1] );
    
    %Create path list to NI, Delsys, and motion capture data
    sPathList = {[sParentPath,'\',listing(inxSubject).name,'\CSVs\OpenSim'],...
        [sParentPath,'\',listing(inxSubject).name,'\CSVs\Simulink']};
    
    % Import each signal type
    for iPath = 1:length(sPathList)
        
        multiWaitbar('sTables',iPath/numel(sPathList),'Color',[0.1 0.5 0.8] );
        
        %% Adjust metaTrial sPath
        sPath = sPathList{iPath};
        sFile = [sPrefix{iPath},'_metaTrial.csv'];
        
        metaTrial = load_csv('sPath',sPath,'sFile',sFile);
        metaTrial.sPath(1:numel(metaTrial.sFile)) = {[sParentPath,...
            '\',listing(inxSubject).name,'\',sDataFolder{iPath}]};
        save_csv(metaTrial,'sFile',sFile,'sPath',sPath);
        
        
        %% Import Data
        sci_db_import('sPath',sPath);
        
        % Save after each signal type is imported
        save_TrialData([],'bVerbose',0)
    end
    
end