clear
%% SET Simulation Parameters
N       = 18;
nRep    = 5;
nRate   = 100;
sSignalList     = {'pro_sup','RA2R_RA3M_X','RA3M_RA4P1_Z','RA3M_RA4P1_X',...
    'RA3M_RA4P2_X','RA3M_RA4P3_X','RA3M_RA4P4_X','RA3M_RA4P5_X'}; %list of all needed MJC DOFs
idDOF_MJCall    = [5,7:9,12,15,18,21];
idDOF_MJC       = [5,7:9,12];
clear nRange
nRange(:,1)     = getMeta('metaDOF',qry('idDOF_MJC',idDOF_MJC),'nRangeMin');
nRange(:,2)     = getMeta('metaDOF',qry('idDOF_MJC',idDOF_MJC),'nRangeMax');
%% create posture matrix and get DOF handles
sAngList    = {'WZ','WX','P1X','P1Y','P2X'};  %list of all needed MATLAB DOFs
nDOFused    = numel(idDOF_MJC);
nStep       = (nRange(:,2)-nRange(:,1))/(nRep-1); %get angle increments for each DOF
nGrid       = zeros(nDOFused,nRep);
for iDOF = 1:nDOFused
    nGrid(iDOF,:) = [nRange(iDOF,1):nStep(iDOF):nRange(iDOF,2)];
end
[X1,X2,X3,X4,X5] = ndgrid(nGrid(1,:),nGrid(2,:),nGrid(3,:),nGrid(4,:),nGrid(5,:));
X1      = reshape(X1,numel(X1),1);
X2      = reshape(X2,numel(X2),1);
X3      = reshape(X3,numel(X3),1);
X4      = reshape(X4,numel(X4),1);
X5      = reshape(X5,numel(X5),1);
nData   = [X1,X2,X3,X4,X5];
clear X*
M       = length(nData);
%% asign variables and run models
% [nScale] = getModelParam_Arm10DOF;
[nScale] = getModelParam_MuJoCo;
iStep       = 1/nRate;     % simulation step
tSim        = iStep; % duration of simulation
g           = 9.81; %Gravity, m/s^2
[hFig, hPlot]  = setPlot('nRow',3,'nCol',2,'sAnnotation','static torques');
plot(hPlot(1,1),0,[0,0],'o')
ylabel(hPlot(1,1),'wrist error (deg)')
legend(hPlot(1,1),'WX','WZ')
plot(hPlot(2,1),0,[0,0],'o')
ylabel(hPlot(2,1),'thumb error (deg)')
legend(hPlot(2,1),'P1X','P1Y')
plot(hPlot(3,1),0,0,'bo')
ylabel(hPlot(3,1),'P2 error (deg)')
xlabel(hPlot(3,1),'rep')
plot(hPlot(1,2),0,[0,0],'o')
ylabel(hPlot(1,2),'wrist tor (Nm)')
legend(hPlot(1,2),'WX','WZ')
plot(hPlot(2,2),0,[0,0],'o')
ylabel(hPlot(2,2),'thumb tor (Nm)')
legend(hPlot(2,2),'P1X','P1Y')
plot(hPlot(3,2),0,0,'bo')
ylabel(hPlot(3,2),'P2 tor (Nm)')
xlabel(hPlot(3,2),'rep')
hold(hPlot(1,1),'on')
hold(hPlot(2,1),'on')
hold(hPlot(3,1),'on')
hold(hPlot(1,2),'on')
hold(hPlot(2,2),'on')
hold(hPlot(3,2),'on')
%%
for iPosture = 1:M
    %% get kinematics
    clear nTor* nSimPos* nPos* tor_sim
    tTimeEnd    = iStep;
    
    clear InKin*
    InKinWZ.time                = [0;tTimeEnd];
    InKinWZ.signals.values      = [nData(iPosture,1),0,0;nData(iPosture,1),0,0];
    InKinWZ.signals.dimensions  = 3;
    
    InKinWX.time                = [0;tTimeEnd];
    InKinWX.signals.values      = [nData(iPosture,2),0,0;nData(iPosture,2),0,0];
    InKinWX.signals.dimensions  = 3;
    
    InKinP1X.time               = [0;tTimeEnd];
    InKinP1X.signals.values     = [nData(iPosture,3),0,0;nData(iPosture,3),0,0];
    InKinP1X.signals.dimensions = 3;
    
    InKinP1Y.time               = [0;tTimeEnd];
    InKinP1Y.signals.values     = [nData(iPosture,4),0,0;nData(iPosture,4),0,0];
    InKinP1Y.signals.dimensions = 3;
    
    InKinP2X.time               = [0,tTimeEnd];
    InKinP2X.signals.values     = [nData(iPosture,5),0,0;nData(iPosture,5),0,0];
    InKinP2X.signals.dimensions = 3;
    
    % initial conditions for forward simulation
    IC_WZ   = [nData(iPosture,1),0];
    IC_WX   = [nData(iPosture,2),0];
    IC_P1X  = [nData(iPosture,3),0];
    IC_P1Y  = [nData(iPosture,4),0];
    IC_P2X  = [nData(iPosture,5),0];
    
    %%   run inverse simulation
    tTimeInv = sim('RHand_5DOF_Inv.slx'); % inverse simulation to get applied torques
    iTime = [0:iStep:tor_sim.time(end)]';
    
    nTStatic(iPosture,1) = tor_sim.signals.values(end,2);    
    nTStatic(iPosture,2) = tor_sim.signals.values(end,1);    
    nTStatic(iPosture,3:5) = tor_sim.signals.values(end,3:5);    
    %%   run forward simulation
    
    sim('RHand_5DOF_Fw.slx'); % forward simulation to apply torques and get
    
%     % error eval
%     pp1 = spline(pos_sim.time,pos_sim.signals.values(:,1));
%     nSimPosW(:,1) = ppval(pp1,iTime);
%     pp1 = spline(pos_sim.time,pos_sim.signals.values(:,2));
%     nSimPosW(:,2) = ppval(pp1,iTime);
%     pp1 = spline(pos_sim.time,pos_sim.signals.values(:,3));
%     nSimPosP1(:,1) = ppval(pp1,iTime);
%     pp1 = spline(pos_sim.time,pos_sim.signals.values(:,4));
%     nSimPosP1(:,2) = ppval(pp1,iTime);
%     pp1 = spline(pos_sim.time,pos_sim.signals.values(:,5));
%     nSimPosP2(:,1) = ppval(pp1,iTime);
%     
%     nPosWErr(iPosture,:) = nSimPosW(2,:) - [nData(iPosture,2),nData(iPosture,1)];
%     nPosP2Err(iPosture,:) = nSimPosP2(2,:) - nData(iPosture,5);
%     nPosP1Err(iPosture,:) = nSimPosP1(2,:) - [nData(iPosture,3),nData(iPosture,4)];
%     %% plot errors
%     plot(hPlot(1,1),iPosture,nPosWErr(iPosture,:)*180/pi,'o')
%     plot(hPlot(2,1),iPosture,nPosP1Err(iPosture,:)*180/pi,'o')
%     plot(hPlot(3,1),iPosture,nPosP2Err(iPosture,:)*180/pi,'bo')
%     plot(hPlot(1,2),iPosture,nTStatic(iPosture,[2,1]),'o')
%     plot(hPlot(2,2),iPosture,nTStatic(iPosture,[3,4]),'o')
%     plot(hPlot(3,2),iPosture,nTStatic(iPosture,5),'bo')
%     drawnow
end

%% saving simulation data
% sSignalList     = {'pro_sup','RA2R_RA3M_X','RA3M_RA4P1_Z','RA3M_RA4P1_X',...
%     'RA3M_RA4P2_X','RA3M_RA4P3_X','RA3M_RA4P4_X','RA3M_RA4P5_X'}; %list of all needed MJC DOFs
% sAngList    = {'WZ','WX','P1X','P1Y','P2X'};  %list of all needed MATLAB DOFs
nPos        = zeros(N,M);
nTorque     = zeros(N,M);

nPos(1:4,:) = nData(:,1:4)';
nPos(7,:)   = nData(:,5)';
nPos(10,:)  = nData(:,5)';
nPos(13,:)  = nData(:,5)';
nPos(16,:)  = nData(:,5)';

nTorque(1:4,:) = nTStatic(:,1:4)';
nTorque(7,:)   = nTStatic(:,5)'/4;
nTorque(10,:)  = nTStatic(:,5)'/4;
nTorque(13,:)  = nTStatic(:,5)'/4;
nTorque(16,:)  = nTStatic(:,5)'/4;

%% saving mat file
sFile   = 'nStaticTorque.mat';
save(sFile,'nPos','nTorque','N','M')