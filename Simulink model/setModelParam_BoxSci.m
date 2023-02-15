clear
%% SET Simulation Parameters
idSubject        = 6; % on 2017/04/18 did 6; 7 & 8 - not all trial types are in database
idTrialTypeList  = [204,205,213,22,21,202,207,211,77,214];
sTable           = 'JointAngles';
sSignalEventList = {'pro_sup','RA3M_RA4P2_X','pro_sup','RA3M_RA4P1_Z',...
    'RA3M_RA4P1_X','RA2R_RA3M_X','RA3M_RA4P2_X','RA2R_RA3M_X',...
    'RA3M_RA4P1_X','RA3M_RA4P2_X'};

sSignalList     = {'RA2R_RA3M_X','pro_sup',...
    'RA3M_RA4P1_X','RA3M_RA4P1_Z','RA3M_RA4P2_X'};
sAngList        = {'WX','WZ','P1X','P1Y','P2X'};

nRate           = 100;  %sampling frequency
% SET alternate Simulation Parameters
% tSim        = 1; % 1 sec
bPlot           = 1;
%%
for iTrialType = 1:numel(idTrialTypeList)
    idTrialType = idTrialTypeList(iTrialType);
    sFile       = ['Tor_idSubject',num2str(idSubject),...
        '_idTrialType',num2str(idTrialType),'.mat'];
    %% read from BOXSCI
    idTrial   = getMeta('metaTrial',qry('idSubject',idSubject,...
        'idTrialType',idTrialType,'bTrial',1));
    if ~isempty(idTrial)
        tOn       = getEvent(idTrial,qry('sTable',sTable,'sSignal',sSignalEventList{iTrialType}),'on'); % get events in trials
        tOff      = getEvent(idTrial,qry('sTable',sTable,'sSignal',sSignalEventList{iTrialType}),'off'); % get events in trials
        tPeriod     = [tOn-0.1,tOff];
        %% get subject anatomy
        % [nScale] = getModelParam_Arm10DOF;
        [nScale] = getModelParam_MuJoCo;     
        %% get kinematics       
        % nAngMax     = [0,-45,0,0,45,0,0,0,45,45]; %maximal angles for each DOF (deg)
        % [nKin]      = getIdealTrajectory(nRate,tSim,sAngList,nAngMax,1);
        [nKin]      = getExpTrajectory(idTrial,nRate,tPeriod,sAngList,sTable,sSignalList,bPlot);
        nSmpl       = numel(nKin.tTime);
        %% asign variables and run models
        tSim        = nanmean(tPeriod(:,2)-tPeriod(:,1)); % duration of simulation
        iStep       = 1/nRate;     % simulation step
        g           = 9.81; %Gravity, m/s^2
        nRep        = 1;
        nSmplRep = floor(nSmpl/nRep);
        for iRep = 1:nRep
             clear nTor* nSimPos* nPos* tor_sim
           %%
            nSmplList = [nSmplRep*iRep-nSmplRep+1:nSmplRep*iRep];
            
            tTimeEnd    = nKin.tTime(numel(nSmplList));
            
            clear InKin*
            InKinWX.time                = nKin.tTime(1:numel(nSmplList));
            InKinWX.signals.values      = nKin.WX(nSmplList,:);
            InKinWX.signals.dimensions  = 3;
            
            InKinWZ.time                = nKin.tTime(1:numel(nSmplList));
            InKinWZ.signals.values      = nKin.WZ(nSmplList,:);
            InKinWZ.signals.dimensions  = 3;
            
            InKinP2X.time               = nKin.tTime(1:numel(nSmplList));
            InKinP2X.signals.values     = nKin.P2X(nSmplList,:);
            InKinP2X.signals.dimensions = 3;
            
            InKinP1X.time               = nKin.tTime(1:numel(nSmplList));
            InKinP1X.signals.values     = nKin.P1X(nSmplList,:);
            InKinP1X.signals.dimensions = 3;
            
            InKinP1Y.time               = nKin.tTime(1:numel(nSmplList));
            InKinP1Y.signals.values     = nKin.P1Y(nSmplList,:);
            InKinP1Y.signals.dimensions = 3;
            
            % initial conditions for forward simulation
            IC_WX   = nKin.WX(nSmplList(1),[1:2]);
            IC_WZ   = nKin.WZ(nSmplList(1),[1:2]);
            IC_P2X  = nKin.P2X(nSmplList(1),[1:2]);
            IC_P1X  = nKin.P1X(nSmplList(1),[1:2]);
            IC_P1Y  = nKin.P1Y(nSmplList(1),[1:2]);
            
            %%   run inverse simulation
            tTimeInv = sim('RHand_5DOF_Inv.slx'); % inverse simulation to get applied torques
            iTime = [0:iStep:tor_sim.time(end)]';

            pp1 = spline(tor_sim.time,tor_sim.signals.values(:,1));
            nTorW(:,1) = ppval(pp1,iTime);
            pp1 = spline(tor_sim.time,tor_sim.signals.values(:,2));
            nTorW(:,2) = ppval(pp1,iTime);
            pp1 = spline(tor_sim.time,tor_sim.signals.values(:,3));
            nTorP1(:,1) = ppval(pp1,iTime);
            pp1 = spline(tor_sim.time,tor_sim.signals.values(:,4));
            nTorP1(:,2) = ppval(pp1,iTime);
            pp1 = spline(tor_sim.time,tor_sim.signals.values(:,5));
            nTorP2(:,1) = ppval(pp1,iTime);            %%
            
            %%   run forward simulation
            
            sim('RHand_5DOF_Fw.slx'); % forward simulation to apply torques and get
                        
            % error eval
            pp1 = spline(pos_sim.time,pos_sim.signals.values(:,1));
            nSimPosW(:,1) = ppval(pp1,iTime);
            pp1 = spline(pos_sim.time,pos_sim.signals.values(:,2));
            nSimPosW(:,2) = ppval(pp1,iTime);
            pp1 = spline(pos_sim.time,pos_sim.signals.values(:,3));
            nSimPosP1(:,1) = ppval(pp1,iTime);
            pp1 = spline(pos_sim.time,pos_sim.signals.values(:,4));
            nSimPosP1(:,2) = ppval(pp1,iTime);
            pp1 = spline(pos_sim.time,pos_sim.signals.values(:,5));
            nSimPosP2(:,1) = ppval(pp1,iTime);   
            
            nPosWErr(nSmplList,:) = nSimPosW - [nKin.WX(nSmplList,1),nKin.WZ(nSmplList,1)];
            nPosP2Err(nSmplList,:) = nSimPosP2 - nKin.P2X(nSmplList,1);
            nPosP1Err(nSmplList,:) = nSimPosP1 - [nKin.P1X(nSmplList,1),nKin.P1Y(nSmplList,1)];
        end
        %% plot errors
        figure(11)
        subplot(3,1,1)
        plot(nKin.tTime,nPosWErr*180/pi)
        % ylim([-1,1])
        ylabel('wrist error (deg)')
        legend('WX','WZ')
        subplot(3,1,2)
        plot(nKin.tTime,nPosP1Err*180/pi)
        % ylim([-1,1])
        ylabel('thumb error (deg)')
        xlabel('time (s)')
        legend('P1X','P1Y')
        subplot(3,1,3)
        plot(nKin.tTime,nPosP2Err*180/pi,'b')
        % ylim([-1,1])
        ylabel('P2 error (deg)')

        %% saving simulation data
        tor.(sSignalList{1})   = nTorW(1+nRate/10:end,1)'; %exclude added steady state
        tor.(sSignalList{2})   = nTorW(1+nRate/10:end,2)';
        tor.(sSignalList{3})   = nTorP1(1+nRate/10:end,1)';
        tor.(sSignalList{4})   = nTorP1(1+nRate/10:end,2)';
        tor.(sSignalList{5})   = nTorP2(1+nRate/10:end,1)'/4;
        tor.RA3M_RA4P3_X       = nTorP2(1+nRate/10:end,1)'/4;
        
        ic.(sSignalList{1})   = nKin.WX(1+nRate/10,[1:2]);
        ic.(sSignalList{2})   = nKin.WZ(1+nRate/10,[1:2]);
        ic.(sSignalList{3})   = nKin.P1X(1+nRate/10,[1:2]);
        ic.(sSignalList{4})   = nKin.P1Y(1+nRate/10,[1:2]);
        ic.(sSignalList{5})   = nKin.P2X(1+nRate/10,[1:2]);
        ic.RA3M_RA4P3_X       = nKin.P2X(1+nRate/10,[1:2]);
        
        pos.(sSignalList{1})   = nKin.WX(1+nRate/10:end,1)';
        pos.(sSignalList{2})   = nKin.WZ(1+nRate/10:end,1)';
        pos.(sSignalList{3})   = nKin.P1X(1+nRate/10:end,1)';
        pos.(sSignalList{4})   = nKin.P1Y(1+nRate/10:end,1)';
        pos.(sSignalList{5})   = nKin.P2X(1+nRate/10:end,1)';
        pos.RA3M_RA4P3_X       = nKin.P2X(1+nRate/10:end,1)';
        
        vel.(sSignalList{1})   = nKin.WX(1+nRate/10:end,2)';
        vel.(sSignalList{2})   = nKin.WZ(1+nRate/10:end,2)';
        vel.(sSignalList{3})   = nKin.P1X(1+nRate/10:end,2)';
        vel.(sSignalList{4})   = nKin.P1Y(1+nRate/10:end,2)';
        vel.(sSignalList{5})   = nKin.P2X(1+nRate/10:end,2)';
        vel.RA3M_RA4P3_X       = nKin.P2X(1+nRate/10:end,2)';
        
        acc.(sSignalList{1})   = nKin.WX(1+nRate/10:end,3)';
        acc.(sSignalList{2})   = nKin.WZ(1+nRate/10:end,3)';
        acc.(sSignalList{3})   = nKin.P1X(1+nRate/10:end,3)';
        acc.(sSignalList{4})   = nKin.P1Y(1+nRate/10:end,3)';
        acc.(sSignalList{5})   = nKin.P2X(1+nRate/10:end,3)';
        acc.RA3M_RA4P3_X       = nKin.P2X(1+nRate/10:end,3)';
        
        
%         nPosErr = sum([sqrt(mean(nPosWErr.^2)),sqrt(mean(nPosP1Err.^2)),sqrt(mean(nPosP2Err.^2))]);
%         setMeta('metaTrial',qry('idTrial',idTrial),'nSimRMS',nPosErr)
%         %% save data in BoxSci
%         tSync       = 0; % getMeta('metaSync',qry('idTrial',idTrial),sTable);      % read tSync from database
%         setData_BoxSci(tor,pos,vel,acc,idTrial,tSync,nRate)
        %% saving mat file
        tor.tTime           = iTime(1:end-nRate/10)';
        pos.tTime           = iTime(1:end-nRate/10)';
        vel.tTime           = iTime(1:end-nRate/10)';
        acc.tTime           = iTime(1:end-nRate/10)';
        save(sFile,'tor','ic','pos','vel','acc')
        
        clear tor pos vel acc ic nPos*
    end
end