% function mat2mot(file,motfilename)
% CREATE .MOT FILE FROM .MAT STRUCTURE OF KINEMATICS
%__________________________________________________________________________
% .mat file must be formatted as a structure whose field names include
% 'pos' which is the parent to a list of DOFs that must match the OpenSim
% model. Each DOF is expected to be a time vector of joint angle values
% correspond to that DOF.
%
% INPUTS
%
% file:         <1 x n> string array of the mat file location and name to
%                be converted
%
% motfilename:  <1 x n> string array of the desire mot file name to be
%                created
%
% PROPERTIES
%
% units:        <1 x n> string array of the input units either 'rad' or
%               'deg'; (default: 'rad'). Output data is transformed to
%               degree if necessary
%
% SavePath:     <1 x n> string array of directory where mot file will be
%               saved. The save path is assumed to have a subfolder named
%               'mot files'.
%
% EXAMPLE
% sPath = 'G:\Shared drives\LABS\PROJECTS\PRJ OS Model Kinematic Hand\Inverse dynamics\Results_18DOF';
% sFile = 'Tor_idSubject6_idTrialType202.mat';
% file = [sPath,filesep,sFile];
% motfilename='Trial.mot';
% mat2mot(file,motfilename)
%__________________________________________________________________________

function sSimTime = mat2mot(file,motfilename,metaDOF,varargin)

in.units = 'rad';
in.SavePath = cd;

if ~isempty(varargin)
    for i = 1:numel(varargin)/2
        in.(varargin{(i-1)*2+1}) = varargin{i*2};
    end
end

cData = load(file);

nPosList = fieldnames(cData.pos);

% Find Time Variable and create time vector as first column
try
    ixTime = find(strcmp(nPosList,'tTime'));
    nDataList{1} = 'time';
    nData(1,:)=cData.pos.tTime;
    sSimTime = [num2str(nData(1,1)),' ',num2str(nData(1,end))];
catch
    error('Cannot find time variable (tTime). Check naming conventions.');
end

% Iterate through each position value (except for time) and restructure for
% STO writer
c=2;
for ix = 1:numel(nPosList)
    %if statement skips over time variable
    if ix ~=ixTime
        % Check to see if signal name in mat file matches metaDOF file for
        % the model
        bSig = strfind(metaDOF.sDOF,nPosList{ix});
        bSum=0;
        % Find index that is not empty
        for i=1:numel(bSig)
            bEmpty=~isempty(bSig{i});
            bSum=bSum+bEmpty;
        end
        % If one index is found insert that sDOF into .mot file list
        if bSum ==1
            nDataList{c} = nPosList{ix};
        % If no index is found, check the old naming convention
        elseif bSum ==0
            bNewSig = strfind(metaDOF.sDOFOld,nPosList{ix});
            
            for i=1:numel(bNewSig)
                if bNewSig{i}==1
                ixNew = i;
                end
            end
            
            nDataList{c} = metaDOF.sDOF{ixNew};
            
            % If multiple indices found, then give error message
        else
            error('Multiple indices matched. Naming conventions are not aligning');
        end
        
        switch in.units
            case 'rad'
                nData(c,:) = cData.pos.(nPosList{ix});
            case 'deg'
                nData(c,:) = cData.pos.(nPosList{ix})*pi/180;
        end
        
        c=c+1;
    end
end

% if strcmp(nDataList{end},'tTime')
% nDataList = flipud(nDataList);
% nDataList{1} = 'time';
% end
sFullFile = [in.SavePath,filesep,'mot files',filesep,motfilename];

motWriter(nDataList,nData',sFullFile);