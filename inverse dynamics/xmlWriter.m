sFile = 'template.xml';

sModelPath ='C:\Repositories\os_hand_kin\Model';
sModelName ='full_arm_model_osv4.osim';

sModel = [sModelPath,filesep,sModelName];

sSimTime = '0 0.9';

motfilename='Trial.mot';

xmlfilename = 'output.xml';

% Requires Control System Toolbox
% function write_id_xml(sModel,sSimTime,motfilename,xmlfilename)
xmlFile         = xmlread(sFile);

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

% change mot file
jmodel_file = xmlFile.getElementsByTagName('output_gen_force_file');
a=jmodel_file.item(0).getFirstChild;
a.setData(xmlfilename);

% xmlFile = 'NewFile.xml';
xmlwrite(xmlfilename,xmlFile);