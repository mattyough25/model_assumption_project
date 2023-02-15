% function tor = sto2mat(sFile)
% READ STO RESULTS INTO STRUCTURE ARRAY
%__________________________________________________________________________
% This function is specific to the formatting of the full_arm_model_osv4
% kinematic model. More generalized use would require changes to the number
% of expected columns and possibly the removal of header rows.
%
% INPUTS
%
% sFile:         <1 x n> string array of the sto file
%
% OUTPUTS
%
% tor:           <struct> structure array of generalized moments around the
%                model DOFs
%
% EXAMPLE
% stofilename = 'TrialResults.sto';
% sFile = [cd,filesep,'results',filesep,stofilename];
%__________________________________________________________________________

function tor = sto2mat(sFile)

FID = fopen(sFile,'r');

formatSpec = ['%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s'];

sText = textscan(FID, formatSpec,'Delimiter','\t','EmptyValue',-Inf);
fclose(FID);

nRowRemove = 6;

tor = [];
for ixSig = 1:numel(sText)
    
    sfield = sText{ixSig}(nRowRemove+1);
    nData = str2double(sText{ixSig}(nRowRemove+2:end));
    tor.(sfield{:})=nData;
end