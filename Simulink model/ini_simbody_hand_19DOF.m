% initialize model
function ini_simbody_hand_19DOF(pos,vel,acc,nScale)

g           = 9.81; %Gravity, m/s^2
assignin('base','g',g)
assignin('base','nScale',nScale)

%% assign kinematic variables
iStep       = pos.tTime(2)-pos.tTime(1);     % simulation step
assignin('base','iStep',iStep)

tTimeEnd    = pos.tTime(end);                % time to end simulation
assignin('base','tTimeEnd',tTimeEnd)

% wrist F/E kinematics
InKinWX.time                = pos.tTime;
InKinWX.signals.values      = [pos.ra_wr_e_f',vel.ra_wr_e_f',acc.ra_wr_e_f'];
InKinWX.signals.dimensions  = 3;
assignin('base','InKinWX',InKinWX)

% wrist abd/add kinematics
InKinWY.time                = pos.tTime;
InKinWY.signals.values      = [pos.ra_wr_ad_ab',vel.ra_wr_ad_ab',acc.ra_wr_ad_ab'];
InKinWY.signals.dimensions  = 3;
assignin('base','InKinWY',InKinWY)

% wrist pro/sup kinematics
InKinWZ.time                = pos.tTime;
InKinWZ.signals.values      = [pos.ra_wr_s_p',vel.ra_wr_s_p',acc.ra_wr_s_p'];
InKinWZ.signals.dimensions  = 3;
assignin('base','InKinWZ',InKinWZ)

% thumb abd/add kinematics
InKinP1X.time               = pos.tTime;
InKinP1X.signals.values     = [pos.ra_cmc1_f_e',vel.ra_cmc1_f_e',acc.ra_cmc1_f_e'];
InKinP1X.signals.dimensions = 3;
assignin('base','InKinP1X',InKinP1X)

% thumb F/E kinematics
InKinP1Y.time               = pos.tTime;
InKinP1Y.signals.values     = [pos.ra_cmc1_ad_ab',vel.ra_cmc1_ad_ab',acc.ra_cmc1_ad_ab'];
InKinP1Y.signals.dimensions = 3;
assignin('base','InKinP1Y',InKinP1Y)

% thumb Mid DOF kinematics
InKinP1MZ.time               = pos.tTime;
InKinP1MZ.signals.values     = [pos.ra_mcp1_f_e',vel.ra_mcp1_f_e',acc.ra_mcp1_f_e'];
InKinP1MZ.signals.dimensions = 3;
assignin('base','InKinP1MZ',InKinP1MZ)

% thumb Dist DOF kinematics
InKinP1DZ.time               = pos.tTime;
InKinP1DZ.signals.values     = [pos.ra_ip1_f_e',vel.ra_ip1_f_e',acc.ra_ip1_f_e'];
InKinP1DZ.signals.dimensions = 3;
assignin('base','InKinP1DZ',InKinP1DZ)

% index finger F/E kinematics
InKinP2X.time               = pos.tTime;
InKinP2X.signals.values     = [pos.ra_mcp2_e_f',vel.ra_mcp2_e_f',acc.ra_mcp2_e_f'];
InKinP2X.signals.dimensions = 3;
assignin('base','InKinP2X',InKinP2X)

% index finger Mid DOF kinematics
InKinP2MX.time               = pos.tTime;
InKinP2MX.signals.values     = [pos.ra_pip2_e_f',vel.ra_pip2_e_f',acc.ra_pip2_e_f'];
InKinP2MX.signals.dimensions = 3;
assignin('base','InKinP2MX',InKinP2MX)

% index finger Dist DOF kinematics
InKinP2DX.time               = pos.tTime;
InKinP2DX.signals.values     = [pos.ra_dip2_e_f',vel.ra_dip2_e_f',acc.ra_dip2_e_f'];
InKinP2DX.signals.dimensions = 3;
assignin('base','InKinP2DX',InKinP2DX)

% middle finger F/E kinematics
InKinP3X.time               = pos.tTime;
InKinP3X.signals.values     = [pos.ra_mcp3_e_f',vel.ra_mcp3_e_f',acc.ra_mcp3_e_f'];
InKinP3X.signals.dimensions = 3;
assignin('base','InKinP3X',InKinP3X)

% middle finger Mid DOF kinematics
InKinP3MX.time               = pos.tTime;
InKinP3MX.signals.values     = [pos.ra_pip3_e_f',vel.ra_pip3_e_f',acc.ra_pip3_e_f'];
InKinP3MX.signals.dimensions = 3;
assignin('base','InKinP3MX',InKinP3MX)

% middle finger Dist DOF kinematics
InKinP3DX.time               = pos.tTime;
InKinP3DX.signals.values     = [pos.ra_dip3_e_f',vel.ra_dip3_e_f',acc.ra_dip3_e_f'];
InKinP3DX.signals.dimensions = 3;
assignin('base','InKinP3DX',InKinP3DX)

% ring finger F/E kinematics
InKinP4X.time               = pos.tTime;
InKinP4X.signals.values     = [pos.ra_mcp4_e_f',vel.ra_mcp4_e_f',acc.ra_mcp4_e_f'];
InKinP4X.signals.dimensions = 3;
assignin('base','InKinP4X',InKinP4X)

% ring finger Mid DOF kinematics
InKinP4MX.time               = pos.tTime;
InKinP4MX.signals.values     = [pos.ra_pip4_e_f',vel.ra_pip4_e_f',acc.ra_pip4_e_f'];
InKinP4MX.signals.dimensions = 3;
assignin('base','InKinP4MX',InKinP4MX)

% ring finger Dist DOF kinematics
InKinP4DX.time               = pos.tTime;
InKinP4DX.signals.values     = [pos.ra_dip4_e_f',vel.ra_dip4_e_f',acc.ra_dip4_e_f'];
InKinP4DX.signals.dimensions = 3;
assignin('base','InKinP4DX',InKinP4DX)

% pinky finger F/E kinematics
InKinP5X.time               = pos.tTime;
InKinP5X.signals.values     = [pos.ra_mcp5_e_f',vel.ra_mcp5_e_f',acc.ra_mcp5_e_f'];
InKinP5X.signals.dimensions = 3;
assignin('base','InKinP5X',InKinP5X)

% pinky finger Mid DOF kinematics
InKinP5MX.time               = pos.tTime;
InKinP5MX.signals.values     = [pos.ra_pip5_e_f',vel.ra_pip5_e_f',acc.ra_pip5_e_f'];
InKinP5MX.signals.dimensions = 3;
assignin('base','InKinP5MX',InKinP5MX)

% pinky finger Dist DOF kinematics
InKinP5DX.time               = pos.tTime;
InKinP5DX.signals.values     = [pos.ra_dip5_e_f',vel.ra_dip5_e_f',acc.ra_dip5_e_f'];
InKinP5DX.signals.dimensions = 3;
assignin('base','InKinP5DX',InKinP5DX)
%% initial conditions for forward simulation
IC_WX   = [pos.ra_wr_e_f(1),vel.ra_wr_e_f(1)];
assignin('base','IC_WX',IC_WX)
IC_WY   = [pos.ra_wr_ad_ab(1),vel.ra_wr_ad_ab(1)];
assignin('base','IC_WY',IC_WY)
IC_WZ   = [pos.ra_wr_s_p(1),vel.ra_wr_s_p(1)];
assignin('base','IC_WZ',IC_WZ)

IC_P1X  = [pos.ra_cmc1_f_e(1),vel.ra_cmc1_f_e(1)];
assignin('base','IC_P1X',IC_P1X)
IC_P1Y  = [pos.ra_cmc1_ad_ab(1),vel.ra_cmc1_ad_ab(1)];
assignin('base','IC_P1Y',IC_P1Y)
IC_P1MZ  = [pos.ra_mcp1_f_e(1),vel.ra_mcp1_f_e(1)];
assignin('base','IC_P1MZ',IC_P1MZ)
IC_P1DZ  = [pos.ra_ip1_f_e(1),vel.ra_ip1_f_e(1)];
assignin('base','IC_P1DZ',IC_P1DZ)

IC_P2X  = [pos.ra_mcp2_e_f(1),vel.ra_mcp2_e_f(1)];
assignin('base','IC_P2X',IC_P2X)
IC_P2MX  = [pos.ra_pip2_e_f(1),vel.ra_pip2_e_f(1)];
assignin('base','IC_P2MX',IC_P2MX)
IC_P2DX  = [pos.ra_dip2_e_f(1),vel.ra_dip2_e_f(1)];
assignin('base','IC_P2DX',IC_P2DX)

IC_P3X  = [pos.ra_mcp3_e_f(1),vel.ra_mcp3_e_f(1)];
assignin('base','IC_P3X',IC_P3X)
IC_P3MX  = [pos.ra_pip3_e_f(1),vel.ra_pip3_e_f(1)];
assignin('base','IC_P3MX',IC_P3MX)
IC_P3DX  = [pos.ra_dip3_e_f(1),vel.ra_dip3_e_f(1)];
assignin('base','IC_P3DX',IC_P3DX)

IC_P4X  = [pos.ra_mcp4_e_f(1),vel.ra_mcp4_e_f(1)];
assignin('base','IC_P4X',IC_P4X)
IC_P4MX  = [pos.ra_pip4_e_f(1),vel.ra_pip4_e_f(1)];
assignin('base','IC_P4MX',IC_P4MX)
IC_P4DX  = [pos.ra_dip4_e_f(1),vel.ra_dip4_e_f(1)];
assignin('base','IC_P4DX',IC_P4DX)

IC_P5X  = [pos.ra_mcp5_e_f(1),vel.ra_mcp5_e_f(1)];
assignin('base','IC_P5X',IC_P5X)
IC_P5MX  = [pos.ra_pip5_e_f(1),vel.ra_pip5_e_f(1)];
assignin('base','IC_P5MX',IC_P5MX)
IC_P5DX  = [pos.ra_dip5_e_f(1),vel.ra_dip5_e_f(1)];
assignin('base','IC_P5DX',IC_P5DX)
