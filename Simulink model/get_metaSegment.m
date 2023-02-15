% _________________________________________________________________________
% function metaSegment = get_metaSegment( ...<PROPERTIES>)
% LOAD anthropometric measurements from CSV file
% Default proportions are based on human height=1.74 m and weight=75 kg
% REFS --------------------------------------------------------------------
%       Winter Bioomechanics and Motor cotnrol of Human Movement 
%       Kodak Ergonomic design Phylosophy
% INPUT -------------------------------------------------------------------
%  sFile    <string> file name, default is default.csv
%
% PROPERTIES --------------------------------------------------------------
%  sPath    <string> file path, default is current directory
% 
% OUTPUT --------------------------------------------------------------
%  metaSegment   <structure> segment parameters in fields with names of bodies
%           [length, dim1, dim2, center of mass distance along length, mass]
%
% Examples ---------------------------------------------------------------- 
%   metaSegment = get_metaSegment('sFile','nAnthroArm_RU2_50.csv');
%
% Matthew Yough, Valeriya Gritsenko © 2020
% 7-Jan-2021 © NEURAL REHABILITATION ENGINEERING LAB

function metaSegment = get_metaSegment(varargin)

in.sFile        = 'default.csv'; % 
in.sPath        = cd;

if nargin>1
   for i = 1:numel(varargin)/2
      in.(varargin{(i-1)*2+1}) = varargin{i*2};
   end
end

% load data
try
    nTable = load_csv('sFile',in.sFile,'sPath',in.sPath);
catch
    [in.sFile,in.sPath] = uiputfile('*.csv','find CSV file with anthropometric measurements');
    nTable = load_csv('sFile',in.sFile,'sPath',in.sPath);
end

% convert numerical variables to double precision for Simulink
sFields = fieldnames(nTable);
for iField = 1:numel(sFields)
    sField = sFields{iField};
    if strcmp(sField(1),'n')
        nTable.(sField) = double(nTable.(sField));
    end
end
% make segment variables
sBody = nTable.sBody;
for iBody = 1:numel(sBody)
    metaSegment.(sBody{iBody}) = [nTable.nLength(iBody),nTable.nDim1(iBody),...
        nTable.nDim2(iBody),nTable.nCM(iBody),nTable.nMass(iBody)];
end