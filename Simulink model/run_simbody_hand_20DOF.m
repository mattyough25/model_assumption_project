% script to run model

% NOTE: idTrialType 1:13 are movements, 14 is testing
% NOTE: forward simuations need to be updated to latest Inv wrist
sPath               = cd;
sDataPath           = '/Volumes/Computer2/Desktop/Simulink Test Data';
sModel              = 'RHand_20DOF_Inv_RU2.slx';
sFile_metaSegment   = 'metaSegment_arm_RU2_50.csv';
sFile_metaDOF       = 'metaDOF_arm.csv';

sPathRef            = ['/Volumes/Computer2/Desktop/OpenSim Test Data'];
sPathMeta           = cd;
%% list of idDOFs for movement types are based on IDs in metaDOF
idTrialTypeList        = [1:13]; %[1:65];
% pronation
sDOFlist_move{1}       = 8;
nRangelist_move{1}     = 0.4;
% supination
sDOFlist_move{2}       = 8;
nRangelist_move{2}     = -0.4;
% wrist flexion with adduction
sDOFlist_move{3}       = [10,30];
nRangelist_move{3}     = [0.4,-0.4];
% wrist extension with abduction
sDOFlist_move{4}       = [10,30];
nRangelist_move{4}     = [0.4,-0.4];
%  hand close
sDOFlist_move{5}       = [10:25];
nRangelist_move{5}     = [0.4,0.4,-0.4,-0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4];
%  hand open
sDOFlist_move{6}       = [10:25];
nRangelist_move{6}     = [-0.4,-0.4,0.4,0.4,-0.4,-0.4,-0.4,-0.4,-0.4,-0.4,-0.4,-0.4,-0.4,-0.4,-0.4,-0.4];
% hand close with pronation
sDOFlist_move{7}       = [8,10:25];
nRangelist_move{7}     = [0.4,0.4,0.4,-0.4,-0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4];
% hand open with pronation
sDOFlist_move{8}       = [8,10:25];
nRangelist_move{8}     = [0.4,-0.4,-0.4,0.4,0.4,-0.4,-0.4,-0.4,-0.4,-0.4,-0.4,-0.4,-0.4,-0.4,-0.4,-0.4,-0.4];
% hand close with supination
sDOFlist_move{9}       = [8,10:25];
nRangelist_move{9}     = [-0.4,0.4,0.4,-0.4,-0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4];
% hand open with supination
sDOFlist_move{10}       = [8,10:25];
nRangelist_move{10}     = [-0.4,-0.4,-0.4,0.4,0.4,-0.4,-0.4,-0.4,-0.4,-0.4,-0.4,-0.4,-0.4,-0.4,-0.4,-0.4,-0.4];
% wrist flexion with hand close in supination
sDOFlist_move{11}       = [9,10:25];
nRangelist_move{11}     = [0.4,0.4,0.4,-0.4,-0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4];
% wrist extension with hand open in pronation
sDOFlist_move{12}       = [9,10:25];
nRangelist_move{12}     = [-0.4,-0.4,-0.4,0.4,0.4,-0.4,-0.4,-0.4,-0.4,-0.4,-0.4,-0.4,-0.4,-0.4,-0.4,-0.4,-0.4];
% hand opening with thumb flexion
sDOFlist_move{13}       = [10:25];
nRangelist_move{13}     = [0.4,-0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4,0.4];

nIC_el_e_f             = [29,90*pi/180;29,45*pi/180;29,0]; % elbow at 90, 45, or 0 (fully extended) degrees
nIC_wrist_ab_ad        = [30,0*pi/180]; % wrist AbAd at 0 degrees
nIC_wrist_s_p          = [8,-80*pi/180;8,80*pi/180]; % wrist in supination or pronation

tSim                = 0.5;  % duration of movement and simulation
nRate               = 1000; % the number of samples in a trial
bPlot               = 0;    % plotting ideal kinematics
bReturn             = 0; % kinematics for return movement is created
bRMSE               = 0; % plotting RMSE values between models
bTraj               = 0; %plotting trajectories
bErr                = 0; %plotting trajectory errors

%% create movement kinematics
metaDOF         = load_csv('sFile',sFile_metaDOF);
idDOF_list      = metaDOF.idDOF_simulink(~metaDOF.bLocked_simulink); % list of simulated idDOF
nSignal         = numel(idDOF_list);

metaDOFsim.sDOFList             = metaDOF.sDOF(~metaDOF.bLocked_simulink);
metaDOFsim.idDOF_simulink       = metaDOF.idDOF_simulink(~metaDOF.bLocked_simulink); % default DOF initial conditions
metaDOFsim.nViscosity           = metaDOF.nViscosity(~metaDOF.bLocked_simulink); % default DOF initial conditions
metaDOFsim.nStiffness_spring    = metaDOF.nStiffness_spring(~metaDOF.bLocked_simulink); % default DOF initial conditions
metaDOFsim.nAngle_spring_ref    = metaDOF.nAngle_spring_ref(~metaDOF.bLocked_simulink); % default DOF initial conditions
metaDOFsim.nGravity             = 9.81; %Gravity, m/s^2
metaDOFsim.nRangeMin            = metaDOF.nRangeMin(~metaDOF.bLocked_simulink); % DOF min angle
metaDOFsim.nRangeMax            = metaDOF.nRangeMax(~metaDOF.bLocked_simulink); % DOF max angle
sDOFList    = metaDOFsim.sDOFList ;
nRange      = [metaDOF.nRangeMin,metaDOF.nRangeMax];
nIC         = metaDOF.nIC;
idTrial     = 1;
for iElbow = 1:numel(nIC_el_e_f)
    nIC_sim       = nIC;
    nIC_sim(nIC_el_e_f(iElbow,1)) = nIC_el_e_f(iElbow,2); % adjust elbow posture
    for idTrialType = idTrialTypeList
        if idTrialType>6 && idTrialType<13
            nIC_sim(nIC_wrist_ab_ad(1)) = nIC_wrist_ab_ad(2); % adjust wrist AbAd posture
        elseif idTrialType==11
            nIC_sim(nIC_wrist_s_p(1,1)) = nIC_wrist_s_p(1,2); % set hand in supination
        elseif idTrialType==12
            nIC_sim(nIC_wrist_s_p(2,1)) = nIC_wrist_s_p(2,2); % set hand in pronation
        end       
        metaDOFsim.nIC                  = nIC_sim(~metaDOF.bLocked_simulink); % default DOF initial conditions

        %% generate movement for each DOF
        [nMoveRange] = setMoveRange(sDOFlist_move{idTrialType},nRangelist_move{idTrialType},nIC_sim,nRange);
        nMoveRange(metaDOF.bLocked_simulink==1,:) = [];
        % set simulation kinematics
        % first 7 DOFs are unsued in Simulink model
        nKin  = getIdealTrajectory(nRate,tSim,sDOFList,nMoveRange,bReturn,bPlot);
        clear pos vel acc
        for iField = 1:nSignal
            pos.(sDOFList{iField}) = double(nKin.(sDOFList{iField})(:,1)');
            vel.(sDOFList{iField}) = double(nKin.(sDOFList{iField})(:,2)');
            acc.(sDOFList{iField}) = double(nKin.(sDOFList{iField})(:,3)');
        end
        pos.tTime = nKin.tTime;
        vel.tTime = nKin.tTime;
        acc.tTime = nKin.tTime;
        
        % get model parameters and initialize
        metaSegment = get_metaSegment('sFile',sFile_metaSegment);
        save_csv(metaSegment,'sFile',[sPath,filesep,'_model_param.csv'])
        
        % initialize model
        ini_simbody(pos,vel,acc,metaSegment,metaDOFsim)
        
        %   run inverse & forward simulations
        %     hInv = Simulink.SimulationInput('RHand_20DOF_Inv_RU2.slx');
        %
        tTimeInv = sim(sModel); % inverse simulation to get applied torques
        %
        clear tor
        for iField = 1:nSignal
            tor.(sDOFList{iField}) = tor_sim.signals.values(:,metaDOFsim.idDOF_simulink(iField));
        end
        tor.tTime = tor_sim.time;
        
        sFileRef     = ['Sim_RHand_20DOF_Inv_idTrialType',num2str(idTrialType),'_idTrial',num2str(idTrialType),'.mat'];
        
        nRMSE(:,idTrialType) = plot_simbody_output(bTraj,bErr,tor,'bCompare',1,'sPathRef',sPathRef,'sFileRef',sFileRef,'bError',1);
        
        %     sim('RHand_20DOF_Fw.slx'); % forward simulation to apply torques and get
        %% plot errors
        %     psim.('ra_wr_e_f')      = pos_sim.signals.values(:,1);
        %     psim.('ra_wr_ad_ab')    = pos_sim.signals.values(:,2);
        %     psim.('ra_wr_s_p')      = pos_sim.signals.values(:,3);
        %     psim.('ra_cmc1_f_e')    = pos_sim.signals.values(:,4);
        %     psim.('ra_cmc1_ad_ab')  = pos_sim.signals.values(:,5);
        %     for iField = 6:nSignal
        %         psim.(sAngList{iField-1}) = pos_sim.signals.values(:,iField);
        %     end
        %     psim.tTime = pos_sim.time;
        %     nErr = plot_simbody_output(pos,psim,bPlot);
        %     err.('ra_wr_e_f')       = nErr(1);
        %     err.('ra_wr_ad_ab')     = nErr(2);
        %     err.('ra_wr_s_p')       = nErr(3);
        %     err.('ra_cmc1_f_e')     = nErr(4);
        %     err.('ra_cmc1_ad_ab')   = nErr(5);
        %     for iField = 6:nSignal
        %         err.(sAngList{iField-1}) = nErr(iField);
        %     end
        err = NaN;
        %% save data
        sFile = [sDataPath,filesep,'RHand_20DOF_Inv_idTrialType',num2str(idTrialType),'_idTrial',num2str(idTrialType),'.mat'];
        save(sFile,'pos','vel','acc','tor','err')
        
        sFileName(idTrialType) = string(['RHand_20DOF_Inv_idTrialType',num2str(idTrialType),'_idTrial',num2str(idTrialType),'.mat']);
        
        nData(idTrialType) = tor;
        
        % nRMSE(idTrialType,:) = calcRMSE(sFile,sFileRef,idTrialTypeList,sPath,sDataPath,sPathRef);
        
        %% save metaSim info
        sFileMeta = ['metaSim_idTrial_',num2str(idTrial),'.csv'];
        save_csv(metaDOFsim,'sFile',sFileMeta,'sPath',sPathMeta);
        idTrial = idTrial + 1;
    end
end
if bRMSE
    plotRMSE(nData,nRMSE,sDataPath,sPath);
end