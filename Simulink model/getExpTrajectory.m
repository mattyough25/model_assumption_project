function [nKin] = getExpTrajectory(idTrial,nRate,tPeriod,sAngList,sTable,sSignalList,bPlot)

nSmpl = round(nanmean(tPeriod(:,2)-tPeriod(:,1))*nRate);
for iSignal = 1:numel(sAngList)
    kin = real(getSignal(idTrial,...
        qry('sTable',sTable,'sSignal',sSignalList{iSignal}),tPeriod,...
        'bNormalized',1,'nSample',nSmpl))';
    if numel(tPeriod)>2
        kin = nanmean(kin,1);
    end
    kin         = kin*pi/180; % joint angles are in degrees
    % add a steady state in the beginning
    kin       = [kin(1)*ones(1,nRate/10),kin];
    nRadFilt    = butterfilt(kin,nRate,5);
    [nData]     = splineKin(nRadFilt', nRate);
    nKin.(sAngList{iSignal}) = nData;
end

nSmpl       = numel(nKin.(sAngList{1})(:,1));
tTime  = [0:1:nSmpl-1]'/nRate;
nKin.tTime  = tTime;
%% plotting: only works for a pre-set group of signals
if bPlot
    nPlot = ceil(numel(sAngList)/2);
    [hFig,hPlot] = setPlot('nRow',nPlot,'nCol',3,'sAnnotation','kinematics');
    for iPlot = 1:nPlot
        plot(hPlot(iPlot,1),tTime,nKin.(sAngList{iPlot*2-1})(:,1)*180/pi,'.r',...
            tTime,nKin.(sAngList{iPlot*2})(:,1)*180/pi,'.b')
        ylabel(hPlot(iPlot,1),'kin (deg)')
        plot(hPlot(iPlot,2),tTime,nKin.(sAngList{iPlot*2-1})(:,2)*180/pi,'r',...
            tTime,nKin.(sAngList{iPlot*2})(:,2)*180/pi,'b')
        plot(hPlot(iPlot,3),tTime,nKin.(sAngList{iPlot*2-1})(:,3)*180/pi,'r',...
            tTime,nKin.(sAngList{iPlot*2})(:,3)*180/pi,'b')
        legend(hPlot(iPlot,3),sAngList([iPlot*2-1,iPlot*2]),...
            'Interpreter','none','Location','eastoutside')
    end
    xlabel(hPlot(nPlot,1),'time (s)')
    xlabel(hPlot(nPlot,2),'time (s)')
    xlabel(hPlot(nPlot,3),'time (s)')
end