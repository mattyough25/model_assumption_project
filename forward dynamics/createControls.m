% function sto2controls

sFile = 'C:\Repositories\os_hand_kin\inverse dynamics\19DOF\results\Sim_RHand_19DOF_Inv_idTrialType1_idTrial1.sto';
sFileTemplate = 'C:\Repositories\os_hand_kin\forward dynamics\Controls_Template.xml';

FID = fopen(sFile,'r');

formatSpec = ['%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s ',...
    '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s',...
    '%s %s %s %s %s %s'];

sText = textscan(FID, formatSpec,'Delimiter','\t','EmptyValue',-Inf);
fclose(FID);

nHeaderRow = 7;

% load template file
xmlFile         = xmlread(sFileTemplate);

% change results directory
act = xmlFile.getElementsByTagName('ControlLinear');
len = act.getLength;

for ix = 0:act.getLength-1
    
    current = act.item(ix);
    currAttribute = current.getAttribute('name');

    
    for iJoint = 1:size(sText,2)
        
        sJoint = sText{1,iJoint}{nHeaderRow,1};
        
        if strcmp(sJoint,currAttribute)
            
            children = current.getChildNodes;
            subnodes =children.getChildNodes;
            xnodes = subnodes.item(11);
            nTP = size(sText{1,iJoint},1)-nHeaderRow;
            
            for iT = 1:nTP
               
                newNode = xmlFile.createElement('ControlLinearNode');
                newtime = newNode.setAttribute('t',sText{1,1}{iT+nHeaderRow,1});
%                 newvalue = newNode.createElement('value');
                
                
                
            end
            xnodes.appendChild(newNode);
        end
    end
end