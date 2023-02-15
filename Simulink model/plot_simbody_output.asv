function nRMSE = plot_simbody_output(bTraj,bErr,nData,varargin)


in.bCompare     = 0; % compare to another simulation
in.bError       = 0; % plot errors
in.sPathRef     = cd;
in.sFileRef     = 'default.mat';
in.data_compare = [];

if nargin>1
    for i = 1:(numel(varargin))/2
        in.(varargin{(i-1)*2+1}) = varargin{i*2};
    end
end

sSignalList         = fields(nData);
bTime               = strcmp(sSignalList,'tTime');
sSignalList(bTime)  = [];
nSignal             = numel(sSignalList);

if isempty(in.data_compare) && in.bCompare
    sFileFull       = [in.sPathRef,filesep,in.sFileRef];
    in.data_compare = load(sFileFull);
    sField = fields(in.data_compare);
    in.data_compare = in.data_compare.(sField{:});
end

if in.bCompare
    nDataF_ref = zeros(numel(nData.(sSignalList{1})),nSignal);
    if length(in.data_compare.tTime)~=length(nData.tTime)
        % resample data to match sampling rates
        iStep           = nData.tTime(2)-nData.tTime(1);     % simulation step
        iTime           = [0:iStep:nData.tTime(end)]';
        % create an array of reference data that matches input data
        for iSignal = 1:nSignal
            pp1             = spline(in.data_compare.tTime,in.data_compare.(sSignalList{iSignal}));
            iData           = ppval(pp1,iTime);
            nDataF_ref(:,iSignal) = iData;
        end
    else
        % create an array of reference data
        for iSignal = 1:nSignal
            nDataF_ref(:,iSignal) = in.data_compare.(sSignalList{iSignal})';
        end
    end
end
% create an array of input data
nDataF = zeros(numel(nData.(sSignalList{1})),nSignal);
for iSignal = 1:nSignal
    nDataF(:,iSignal) = nData.(sSignalList{iSignal})';
end
%% plot trajectories
if bTraj
[hFig, hPlot]  = setPlot('nRow',2,'nCol',ceil(nSignal/2),'sAnnotation','trajectories');
for iPlot = 1:nSignal
    if in.bCompare
        plot(hPlot(iPlot),nData.tTime,nDataF(:,iPlot),'k',...
            nData.tTime,nDataF_ref(:,iPlot),'r')
    else
        plot(hPlot(iPlot),nData.tTime,nDataF(:,iPlot),'k')        
    end
    ylabel(hPlot(iPlot),sSignalList(iPlot),'Interpreter','none')
end
xlabel(hPlot(iPlot),'time (s)')
legend(hPlot(iPlot),'data','ref data')
end   
%% plot errors
if bErr
if in.bError
    nPosErr  = nDataF_ref  - nDataF;       % error
    [hFig, hPlot]  = setPlot('nRow',2,'nCol',ceil(nSignal/2),'sAnnotation','error');   
    for iPlot = 1:nSignal
        plot(hPlot(iPlot),nData.tTime,nPosErr(:,iPlot),'b')
        ylabel(hPlot(iPlot),sSignalList(iPlot),'Interpreter','none')
    end
    xlabel(hPlot(iPlot),'time (s)')
end
end

%% Calculate RMSE
for i = 1:width(nDataF)
nRMSE(i,:) = calcRMSE(nDataF(:,i),nDataF_ref(:,i));
end

