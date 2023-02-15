% _________________________________________________________________________
% function ini_simbody(pos,vel,acc,metaSegment,metaDOFsim)
% ASSIGN VARIABLES IN WORKSPACE for defining parameters of Simulink Simbody
% model
% INPUT -------------------------------------------------------------------
%  pos    <structure> angular trajectories for driving joints (DOFs)
%  vel    <structure> angular velocity for driving DOFs
%  acc    <structure> angular acceleration for driving DOFs
%  metaSegment   <structure> segment parameters in fields with names of bodies
%           [length, dim1, dim2, center of mass distance along length, mass]
%  metaDOFsim   <structure> simulation parameters in fields including gravity, 
%           names of DOFs, DOF ranges, DOF initial conditions, DOF viscocity, 
%           DOF stiffness, DOF spring angle.
%
% Examples ---------------------------------------------------------------- 
%   ini_simbody(pos,vel,acc,metaSegment,metaDOFsim)
%
% Matthew Yough, Valeriya Gritsenko © 2020
% 7-Jan-2021 © NEURAL REHABILITATION ENGINEERING LAB


function ini_simbody(pos,vel,acc,metaSegment,metaDOFsim)

assignin('base','g',metaDOFsim.nGravity)
assignin('base','nScale',metaSegment)

iStep       = pos.tTime(2)-pos.tTime(1);     % simulation step
assignin('base','iStep',iStep)

tTimeEnd    = pos.tTime(end);                % time to end simulation
assignin('base','tTimeEnd',tTimeEnd)

sDOFList = metaDOFsim.sDOFList;
%% assign kinematic variables
for iDOF = 1:numel(sDOFList)
    sDOF = sDOFList{iDOF};
    
    eval(['akin_',sDOF,'.time = pos.tTime;']) 
    eval(['akin_',sDOF,'.signals.values = [pos.(sDOF)'',vel.(sDOF)'',acc.(sDOF)''];'])
    eval(['akin_',sDOF,'.signals.dimensions = 3;'])
    eval(['assignin(''base'',''akin_',sDOF,''',akin_',sDOF,')'])% angular kinematics
    
    eval(['ic_',sDOF,' = [pos.(sDOF)(1),vel.(sDOF)(1)];'])  
    eval(['assignin(''base'',''ic_',sDOF,''',ic_',sDOF,')'])% initial conditions

    eval(['dof_mech_',sDOF,' = double([metaDOFsim.nAngle_spring_ref(iDOF),metaDOFsim.nStiffness_spring(iDOF),metaDOFsim.nViscosity(iDOF)]);'])
    eval(['assignin(''base'',''dof_mech_',sDOF,''',dof_mech_',sDOF,')']) % joint spring and dampening/viscosity

    eval(['range_',sDOF,' = double([metaDOFsim.nRangeMin(iDOF),metaDOFsim.nRangeMax(iDOF)]);'])
    eval(['assignin(''base'',''range_',sDOF,''',range_',sDOF,')']) % joint limits
end
%% set joint viscocity and stiffness parameters
% MuJuCo values are in units of velocity and acceleration,              
% Simbody are in units of torque
%% joint viscosity
% distal IP joints: 0.0081 * distal segment mass
% proximal IP joints: 0.0105 * middle segment mass
% MCP joints: 0.0142 * digit mass
% wrist joint: 0.01 * hand mass
