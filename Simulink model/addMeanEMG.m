clear
%%
idSubjectList        = [6]; % on 2017/04/18 did 6; 7 & 8 - not all trial types are in database
idTrialTypeList  = [204,205,213,22,21,202,207,211,77,214];
sTableEvent           = 'JointAngles';
sSignalEventList = {'pro_sup','RA3M_RA4P2_X','pro_sup','RA3M_RA4P1_Z',...
    'RA3M_RA4P1_X','RA2R_RA3M_X','RA3M_RA4P2_X','RA2R_RA3M_X',...
    'RA3M_RA4P1_X','RA3M_RA4P2_X'};

sTable           = 'EMGmean';
sSignalList      = {  'SUP'  'PTER'  ...
    'ECR_LO' 'ECU'  'FCU' 'FCR' ...
    'EPL'  'APL'  'FPL' 'APB' ...
    'EIND' 'FDP4' 'FDP2' 'FDS2' 'FDS3' 'FDS4' 'ED4' 'ED3' 'ED2'};
nRate            = 100;
%%
for idSubject = idSubjectList
    idTrialList      = getMeta('metaTrial',qry('idSubject',idSubject,...
        'idTrialType',idTrialTypeList,'bTrial',1));
    
    for iTrial = 1:numel(idTrialList)
        idTrial = idTrialList(iTrial);
        idTrialType =  getMeta('metaTrial',qry('idTrial',idTrial),'idTrialType');
        iTrialType  = find(idTrialTypeList==idTrialType);
        %% read from BOXSCI
        idSession   = getMeta('metaTrial',qry('idTrial',idTrial),'idSession');
        tOn         = getEvent(idTrial,qry('sTable',sTableEvent,'sSignal',sSignalEventList{iTrialType}),'on'); % get events in trials
        tOff        = getEvent(idTrial,qry('sTable',sTableEvent,'sSignal',sSignalEventList{iTrialType}),'off'); % get events in trials
        tPeriod     = [tOn-0.1,tOff];
        nSmpl       = round(nanmean(tPeriod(:,2)-tPeriod(:,1))*nRate);
        for iSignal = 1:numel(sSignalList)
            nData = getSignal(idTrial,...
                qry('sTable',sTable,'sSignal',sSignalList{iSignal}),[],...
                'bNormalized',1,'nSample',nSmpl)';
            if ~isempty(nData)
                emg.(sSignalList{iSignal}) = nData;
            end
        end
        tTime  = [1:nSmpl]/nRate;
        emg.tTime  = tTime;
        %% update data files
        sFile       = ['Tor_idSubject',num2str(idSubject),...
            '_idTrialType',num2str(idTrialType),'.mat'];
        save(['Results/',sFile],'emg','-append')
        clear emg
    end
end