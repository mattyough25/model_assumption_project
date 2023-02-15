% function write_id_xml(sModel,sSimTime,motfilename,xmlfilename,stofilename,...
%     resultspath,varargin)
% CREATE .XML FILE FOR INVERSE DYNAMICS FROM TEMPLATE FILE
%__________________________________________________________________________
% template.xml must be located in the same folder or another must be
% provided via 'sFile' property. Script requires the Matlab add-on 
% Control System Toolbox to be installed 
%
% INPUTS
%
% sModel:         <1 x n> string array of the opensim model to be used
%
% sSimTime:       <1 x n> string array of the start and stop simulation
%                 times. This should be taken directly from mot file.
%
% motfilename:    <1 x n> string array of the mot file which will be used for
%                 simulation
%
% xmlfilename:    <1 x n> string array of the desired xml file to be
%                 created
%
% stofilename:    <1 x n> string array of the desired sto file to be
%                 created during simulations
%
% resultspath:    <1 x n> string array of the desired directory will
%                 simulation results will be saved
%
% PROPERTIES
%
% sFile:        <1 x n> string array of the XML template to be used
%
% SavePath:     <1 x n> string array of directory where xml file will be
%               saved. The save path is assumed to have a subfolder named
%               'xml files'.
%
% EXAMPLE
% sFile = 'template.xml';
% sModelPath ='C:\Repositories\os_hand_kin\Model';
% sModelName ='full_arm_model_osv4.osim';
% sModel = [sModelPath,filesep,sModelName];
% sSimTime = '0 0.9';
% motfilename='Trial.mot';
% xmlfilename = 'output.xml';
% stofilename = 'inverse_dynamics.sto';

% Requires Control System Toolbox
%__________________________________________________________________________
function write_fd_xml(sModel,sSimTime,motfilename,xmlfilename,stofilename,...
    resultspath,varargin)

in.sFile = 'template.xml';
in.SavePath = cd;

if ~isempty(varargin)
    for i = 1:numel(varargin)/2
        in.(varargin{(i-1)*2+1}) = varargin{i*2};
    end
end

% load template file
xmlFile         = xmlread(in.sFile);

% change results directory
jmodel_file = xmlFile.getElementsByTagName('results_directory');
a=jmodel_file.item(0).getFirstChild;
a.setData(resultspath);

% change model name
jmodel_file = xmlFile.getElementsByTagName('model_file');
a=jmodel_file.item(0).getFirstChild;
a.setData(sModel);

% change model name
jmodel_file = xmlFile.getElementsByTagName('time_range');
a=jmodel_file.item(0).getFirstChild;
a.setData(sSimTime);

% change mot file
jmodel_file = xmlFile.getElementsByTagName('coordinates_file');
a=jmodel_file.item(0).getFirstChild;
a.setData(motfilename);

% change xml file
jmodel_file = xmlFile.getElementsByTagName('output_gen_force_file');
a=jmodel_file.item(0).getFirstChild;
a.setData(stofilename);

% xmlFile = 'NewFile.xml';
cd([in.SavePath,filesep,'xml files'])
xmlwrite(xmlfilename,xmlFile);
cd(in.SavePath);