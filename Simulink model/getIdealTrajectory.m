function [nKin] = getIdealTrajectory(nRate,tSim,sAngList,nMoveRange,bReturn,bPlot)
nSmpl       = nRate*tSim;
tTime   = [0:1:nSmpl-1]/nRate;
if bReturn
    nSmpl = floor(nSmpl/2); 
end
% default sigmoidal trajectory with bell-shaped velocity profile
x       = [-nSmpl/2:nSmpl/2-1]'*2*pi/nSmpl;
z       = sech(x);
z       = (z-min(z))/(max(z)-min(z));
if bReturn
    z = [z;-z]; % negative velocity for return
end
ffkin   = cumsum(z);
ffkin   = ffkin/max(ffkin);
% figure(1);plot(tTime',ffkin)

nAngMax = nMoveRange(:,2)-nMoveRange(:,1);% movement amplitude in rad
for iDOF = 1:numel(sAngList)
    if nAngMax(iDOF)~=0
        nRadFilt = ffkin*nAngMax(iDOF); % scale the sigmoid to max angle
        [nData] = splineKin(nRadFilt, nRate);
        nData(:,1) = nData(:,1) + nMoveRange(iDOF,1); % add back IC
    else
        nData(:,1) = nMoveRange(iDOF,1)*ones(length(tTime),1);
        nData(:,2:3) = zeros(length(tTime),2);
    end
    nKin.(sAngList{iDOF}) = nData;
end

nKin.tTime   = tTime;

%% plotting: only works for a pre-set group of signals
if bPlot   
    [hFig, hPlot]  = setPlot('nRow',2,'nCol',ceil(numel(sAngList)/2),'sAnnotation','angular kinematics');   
    for iPlot = 1:numel(sAngList)
        plot(hPlot(iPlot),tTime,nKin.(sAngList{iPlot})(:,1)*180/pi,'.r',...
            tTime,nKin.(sAngList{iPlot})(:,2)*180/pi,'g',...
            tTime,nKin.(sAngList{iPlot})(:,3)*180/pi,'--b')
        ylabel(hPlot(iPlot),sAngList(iPlot),'Interpreter','none')
    end
    xlabel(hPlot(iPlot),'time (s)')
    legend(hPlot(iPlot),'ang','vel','acc')
end