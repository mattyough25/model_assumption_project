function [nTableOS] = getModelParam_OSarm_kin
%       Winter Bioomechanics and Motor cotnrol of Human Movement 
%       Kodak Ergonomic design Phylosophy
%       Proportions are based on human height=1.74 m and weight=75 kg
% NOTE: the long axis of segments in OS coordinates -Y = +Z in simulink
% NOTE: the width of segments in OS coordinates +Z = +X in simulink
% NOTE: the thickness of segments in OS coordinates +X = +Y in simulink
nTable           = load_csv('sFile','nModelParam_Anthro.csv');
nTableOS         = load_csv('sFile','nModelParam_OSIM.csv');

%% MC (metacarpals) segment
MC_thikn   = double(nTable.nDim2(3));  % thikness of the palm
MC_width   = double(nTable.nDim1(3));   % width of the palm
MC_length  = double(nTable.nLength(3));   % length of the palm without fingers
MC_mass    = double(nTable.nMass(3));      % segment mass in kg
MC_cm      = MC_length/2;      % segment center of mass

% MC rectangular prism inertia
MC_Ih      = MC_mass*(MC_width^2 + MC_thikn^2)/12;
MC_Iw      = MC_mass*(MC_length^2 + MC_thikn^2)/12;
MC_Id      = MC_mass*(MC_width^2 + MC_length^2)/12;

nTableOS.nIxx(1) = MC_Id; % MC thikness
nTableOS.nIyy(1) = MC_Ih; % MC length/height
nTableOS.nIzz(1) = MC_Iw; % MC width
nTableOS.nMCx(1) = 0; % center of mass x coordinate in OS
nTableOS.nMCy(1) = -MC_cm; % center of mass y coordinate in OS
nTableOS.nMCz(1) = 0; % center of mass z coordinate in OS
nTableOS.nMass(1)= MC_mass; % segment mass 

%% P1 (proximal thumb) segment
P1_rad       = double(nTable.nDim1(4));   % radius of finger
P1_length    = double(nTable.nLength(4));    % length of finger
P1_mass      = double(nTable.nMass(4));    % segment mass in kg
P1_cm        = P1_length/2;      % segment center of mass

% P1 cyllinder inertia
P1_Ih   = P1_mass*P1_rad^2/2;
P1_Iw   = P1_mass*(3*P1_rad^2 + P1_length^2)/12;

nTableOS.nIxx(2) = P1_Iw; % P1 thikness
nTableOS.nIyy(2) = P1_Ih; % P1 length/height
nTableOS.nIzz(2) = P1_Iw; % P1 width
nTableOS.nMCx(2) = 0; % center of mass x coordinate in OS
nTableOS.nMCy(2) = -P1_cm; % center of mass y coordinate in OS
nTableOS.nMCz(2) = 0; % center of mass z coordinate in OS
nTableOS.nMass(2)= P1_mass; % segment mass 

%% P1M (middle thumb) segment
P1M_rad       = double(nTable.nDim1(5));   % radius of finger
P1M_length    = double(nTable.nLength(5));    % length of finger
P1M_mass      = double(nTable.nMass(5));    % segment mass in kg
P1M_cm        = P1M_length/2;      % segment center of mass

% P1M cyllinder inertia
P1M_Ih   = P1M_mass*P1M_rad^2/2;
P1M_Iw   = P1M_mass*(3*P1M_rad^2 + P1M_length^2)/12;

nTableOS.nIxx(3) = P1M_Iw; % P1M thikness
nTableOS.nIyy(3) = P1M_Ih; % P1M length/height
nTableOS.nIzz(3) = P1M_Iw; % P1M width
nTableOS.nMCx(3) = 0; % center of mass x coordinate in OS
nTableOS.nMCy(3) = -P1M_cm; % center of mass y coordinate in OS
nTableOS.nMCz(3) = 0; % center of mass z coordinate in OS
nTableOS.nMass(3)= P1M_mass; % segment mass 

%% P1D (distal thumb) segment
P1D_rad       = double(nTable.nDim1(6));   % radius of finger
P1D_length    = double(nTable.nLength(6));    % length of finger
P1D_mass      = double(nTable.nMass(6));    % segment mass in kg
P1D_cm        = P1D_length/2;      % segment center of mass

% P1D cyllinder inertia
P1D_Ih   = P1D_mass*P1D_rad^2/2;
P1D_Iw   = P1D_mass*(3*P1D_rad^2 + P1D_length^2)/12;

nTableOS.nIxx(4) = P1D_Iw; % P1D thikness
nTableOS.nIyy(4) = P1D_Ih; % P1D length/height
nTableOS.nIzz(4) = P1D_Iw; % P1D width
nTableOS.nMCx(4) = 0; % center of mass x coordinate in OS
nTableOS.nMCy(4) = -P1D_cm; % center of mass y coordinate in OS
nTableOS.nMCz(4) = 0; % center of mass z coordinate in OS
nTableOS.nMass(4)= P1D_mass; % segment mass 

%% P2 (proximal index) segment
P2_rad       = double(nTable.nDim1(7));   % radius of finger
P2_length    = double(nTable.nLength(7));    % length of finger
P2_mass      = double(nTable.nMass(7));    % segment mass in kg
P2_cm        = P2_length/2;      % segment center of mass

% P2 cyllinder inertia
P2_Ih   = P2_mass*P2_rad^2/2;
P2_Iw   = P2_mass*(3*P2_rad^2 + P2_length^2)/12;

nTableOS.nIxx(5) = P2_Iw; % P2 thikness
nTableOS.nIyy(5) = P2_Ih; % P2 length/height
nTableOS.nIzz(5) = P2_Iw; % P2 width
nTableOS.nMCx(5) = 0; % center of mass x coordinate in OS
nTableOS.nMCy(5) = -P2_cm; % center of mass y coordinate in OS
nTableOS.nMCz(5) = 0; % center of mass z coordinate in OS
nTableOS.nMass(5)= P2_mass; % segment mass 

%% P2M (middle index) segment
P2M_rad       = double(nTable.nDim1(8));   % radius of finger
P2M_length    = double(nTable.nLength(8));    % length of finger
P2M_mass      = double(nTable.nMass(8));    % segment mass in kg
P2M_cm        = P2M_length/2;      % segment center of mass

% P2 cyllinder inertia
P2M_Ih   = P2M_mass*P2M_rad^2/2;
P2M_Iw   = P2M_mass*(3*P2M_rad^2 + P2M_length^2)/12;

nTableOS.nIxx(6) = P2M_Iw; % P2M thikness
nTableOS.nIyy(6) = P2M_Ih; % P2M length/height
nTableOS.nIzz(6) = P2M_Iw; % P2M width
nTableOS.nMCx(6) = 0; % center of mass x coordinate in OS
nTableOS.nMCy(6) = -P2M_cm; % center of mass y coordinate in OS
nTableOS.nMCz(6) = 0; % center of mass z coordinate in OS
nTableOS.nMass(6)= P2M_mass; % segment mass 

%% P2D (distal index) segment
P2D_rad       = double(nTable.nDim1(9));   % radius of finger
P2D_length    = double(nTable.nLength(9));    % length of finger
P2D_mass      = double(nTable.nMass(9));    % segment mass in kg
P2D_cm        = P2D_length/2;      % segment center of mass

% P2D cyllinder inertia
P2D_Ih   = P2D_mass*P2D_rad^2/2;
P2D_Iw   = P2D_mass*(3*P2D_rad^2 + P2D_length^2)/12;

nTableOS.nIxx(7) = P2D_Iw; % P2D thikness
nTableOS.nIyy(7) = P2D_Ih; % P2D length/height
nTableOS.nIzz(7) = P2D_Iw; % P2D width
nTableOS.nMCx(7) = 0; % center of mass x coordinate in OS
nTableOS.nMCy(7) = -P2D_cm; % center of mass y coordinate in OS
nTableOS.nMCz(7) = 0; % center of mass z coordinate in OS
nTableOS.nMass(7)= P2D_mass; % segment mass 

%% P3 (proximal middle) segment
P3_rad       = double(nTable.nDim1(10));   % radius of finger
P3_length    = double(nTable.nLength(10));    % length of finger
P3_mass      = double(nTable.nMass(10));    % segment mass in kg
P3_cm        = P3_length/2;      % segment center of mass

% P3 cyllinder inertia
P3_Ih   = P3_mass*P3_rad^2/2;
P3_Iw   = P3_mass*(3*P3_rad^2 + P3_length^2)/12;

nTableOS.nIxx(8) = P3_Iw; % P3 thikness
nTableOS.nIyy(8) = P3_Ih; % P3 length/height
nTableOS.nIzz(8) = P3_Iw; % P3 width
nTableOS.nMCx(8) = 0; % center of mass x coordinate in OS
nTableOS.nMCy(8) = -P3_cm; % center of mass y coordinate in OS
nTableOS.nMCz(8) = 0; % center of mass z coordinate in OS
nTableOS.nMass(8)= P3_mass; % segment mass 

%% P3M (middle middle) segment
P3M_rad       = double(nTable.nDim1(11));   % radius of finger
P3M_length    = double(nTable.nLength(11));    % length of finger
P3M_mass      = double(nTable.nMass(11));    % segment mass in kg
P3M_cm        = P3M_length/2;      % segment center of mass

% P3M cyllinder inertia
P3M_Ih   = P3M_mass*P3M_rad^2/2;
P3M_Iw   = P3M_mass*(3*P3M_rad^2 + P3M_length^2)/12;

nTableOS.nIxx(9) = P3M_Iw; % P3M thikness
nTableOS.nIyy(9) = P3M_Ih; % P3M length/height
nTableOS.nIzz(9) = P3M_Iw; % P3M width
nTableOS.nMCx(9) = 0; % center of mass x coordinate in OS
nTableOS.nMCy(9) = -P3M_cm; % center of mass y coordinate in OS
nTableOS.nMCz(9) = 0; % center of mass z coordinate in OS
nTableOS.nMass(9)= P3M_mass; % segment mass 

%% P3D (distal middle) segment
P3D_rad       = double(nTable.nDim1(12));   % radius of finger
P3D_length    = double(nTable.nLength(12));    % length of finger
P3D_mass      = double(nTable.nMass(12));    % segment mass in kg
P3D_cm        = P3D_length/2;      % segment center of mass

% P3D cyllinder inertia
P3D_Ih   = P3D_mass*P3D_rad^2/2;
P3D_Iw   = P3D_mass*(3*P3D_rad^2 + P3D_length^2)/12;

nTableOS.nIxx(10) = P3D_Iw; % P3D thikness
nTableOS.nIyy(10) = P3D_Ih; % P3D length/height
nTableOS.nIzz(10) = P3D_Iw; % P3D width
nTableOS.nMCx(10) = 0; % center of mass x coordinate in OS
nTableOS.nMCy(10) = -P3D_cm; % center of mass y coordinate in OS
nTableOS.nMCz(10) = 0; % center of mass z coordinate in OS
nTableOS.nMass(10)= P3D_mass; % segment mass 

%% P4 (proximal ring) segment
P4_rad       = double(nTable.nDim1(13));   % radius of finger
P4_length    = double(nTable.nLength(13));    % length of finger
P4_mass      = double(nTable.nMass(13));    % segment mass in kg
P4_cm        = P4_length/2;      % segment center of mass

% P4 cyllinder inertia
P4_Ih   = P4_mass*P4_rad^2/2;
P4_Iw   = P4_mass*(3*P4_rad^2 + P4_length^2)/12;

nTableOS.nIxx(11) = P4_Iw; % P4 thikness
nTableOS.nIyy(11) = P4_Ih; % P4 length/height
nTableOS.nIzz(11) = P4_Iw; % P4 width
nTableOS.nMCx(11) = 0; % center of mass x coordinate in OS
nTableOS.nMCy(11) = -P4_cm; % center of mass y coordinate in OS
nTableOS.nMCz(11) = 0; % center of mass z coordinate in OS
nTableOS.nMass(11)= P4_mass; % segment mass 

%% P4M (middle ring) segment
P4M_rad       = double(nTable.nDim1(14));   % radius of finger
P4M_length    = double(nTable.nLength(14));    % length of finger
P4M_mass      = double(nTable.nMass(14));    % segment mass in kg
P4M_cm        = P4M_length/2;      % segment center of mass

% P4M cyllinder inertia
P4M_Ih   = P4M_mass*P4M_rad^2/2;
P4M_Iw   = P4M_mass*(3*P4M_rad^2 + P4M_length^2)/12;

nTableOS.nIxx(12) = P4M_Iw; % P4M thikness
nTableOS.nIyy(12) = P4M_Ih; % P4M length/height
nTableOS.nIzz(12) = P4M_Iw; % P4M width
nTableOS.nMCx(12) = 0; % center of mass x coordinate in OS
nTableOS.nMCy(12) = -P4M_cm; % center of mass y coordinate in OS
nTableOS.nMCz(12) = 0; % center of mass z coordinate in OS
nTableOS.nMass(12)= P4M_mass; % segment mass 

%% P4D (distal ring) segment
P4D_rad       = double(nTable.nDim1(15));   % radius of finger
P4D_length    = double(nTable.nLength(15));    % length of finger
P4D_mass      = double(nTable.nMass(15));    % segment mass in kg
P4D_cm        = P4D_length/2;      % segment center of mass

% P4D cyllinder inertia
P4D_Ih   = P4D_mass*P4D_rad^2/2;
P4D_Iw   = P4D_mass*(3*P4D_rad^2 + P4D_length^2)/12;

nTableOS.nIxx(13) = P4D_Iw; % P4D thikness
nTableOS.nIyy(13) = P4D_Ih; % P4D length/height
nTableOS.nIzz(13) = P4D_Iw; % P4D width
nTableOS.nMCx(13) = 0; % center of mass x coordinate in OS
nTableOS.nMCy(13) = -P4D_cm; % center of mass y coordinate in OS
nTableOS.nMCz(13) = 0; % center of mass z coordinate in OS
nTableOS.nMass(13)= P4D_mass; % segment mass 

%% P5 (proximal little) segment
P5_rad       = double(nTable.nDim1(16));   % radius of finger
P5_length    = double(nTable.nLength(16));    % length of finger
P5_mass      = double(nTable.nMass(16));    % segment mass in kg
P5_cm        = P5_length/2;      % segment center of mass

% P5 cyllinder inertia
P5_Ih   = P5_mass*P5_rad^2/2;
P5_Iw   = P5_mass*(3*P5_rad^2 + P5_length^2)/12;

nTableOS.nIxx(14) = P5_Iw; % P5 thikness
nTableOS.nIyy(14) = P5_Ih; % P5 length/height
nTableOS.nIzz(14) = P5_Iw; % P5 width
nTableOS.nMCx(14) = 0; % center of mass x coordinate in OS
nTableOS.nMCy(14) = -P5_cm; % center of mass y coordinate in OS
nTableOS.nMCz(14) = 0; % center of mass z coordinate in OS
nTableOS.nMass(14)= P5_mass; % segment mass 

%% P5M (middle little) segment
P5M_rad       = double(nTable.nDim1(17));   % radius of finger
P5M_length    = double(nTable.nLength(17));    % length of finger
P5M_mass      = double(nTable.nMass(17));    % segment mass in kg
P5M_cm        = P5M_length/2;      % segment center of mass

% P5 cyllinder inertia
P5M_Ih   = P5M_mass*P5M_rad^2/2;
P5M_Iw   = P5M_mass*(3*P5M_rad^2 + P5M_length^2)/12;

nTableOS.nIxx(15) = P5M_Iw; % P5M thikness
nTableOS.nIyy(15) = P5M_Ih; % P5M length/height
nTableOS.nIzz(15) = P5M_Iw; % P5M width
nTableOS.nMCx(15) = 0; % center of mass x coordinate in OS
nTableOS.nMCy(15) = -P5M_cm; % center of mass y coordinate in OS
nTableOS.nMCz(15) = 0; % center of mass z coordinate in OS
nTableOS.nMass(15)= P5M_mass; % segment mass 

%% P5D (distal little) segment
P5D_rad       = double(nTable.nDim1(18));   % radius of finger
P5D_length    = double(nTable.nLength(18));    % length of finger
P5D_mass      = double(nTable.nMass(18));    % segment mass in kg
P5D_cm        = P5D_length/2;      % segment center of mass

% P5D cyllinder inertia
P5D_Ih   = P5D_mass*P5D_rad^2/2;
P5D_Iw   = P5D_mass*(3*P5D_rad^2 + P5D_length^2)/12;

nTableOS.nIxx(16) = P5D_Iw; % P5D thikness
nTableOS.nIyy(16) = P5D_Ih; % P5D length/height
nTableOS.nIzz(16) = P5D_Iw; % P5D width
nTableOS.nMCx(16) = 0; % center of mass x coordinate in OS
nTableOS.nMCy(16) = -P5D_cm; % center of mass y coordinate in OS
nTableOS.nMCz(16) = 0; % center of mass z coordinate in OS
nTableOS.nMass(16)= P5D_mass; % segment mass 

%% save csv
save_csv(nTableOS,'sFile','nModelParam_Anthro2OSIM.csv');
