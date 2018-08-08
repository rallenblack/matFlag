source_table;
scan_table;

onoffs = {};
idx = 1;

% AGBT16B_400_01 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
session = AGBT16B_400_01;
on_scan = 9;  off_scan = 10;
source = source3C295;
LO_freq = 1450;
onoffs{idx,1} = session;
onoffs{idx,2} = on_scan;
onoffs{idx,3} = off_scan;
onoffs{idx,4} = source;
onoffs{idx,5} = LO_freq;
idx = idx + 1;

% AGBT16B_400_02 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
session = AGBT16B_400_02;
on_scan = 11;  off_scan = 12;
source = source3C295;
LO_freq = 1450;
onoffs{idx,1} = session;
onoffs{idx,2} = on_scan;
onoffs{idx,3} = off_scan;
onoffs{idx,4} = source;
onoffs{idx,5} = LO_freq;
idx = idx + 1;

% AGBT16B_400_03 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
session = AGBT16B_400_03;
on_scan = 7;  off_scan = 8;
source = source3C295;
LO_freq = 1450;
onoffs{idx,1} = session;
onoffs{idx,2} = on_scan;
onoffs{idx,3} = off_scan;
onoffs{idx,4} = source;
onoffs{idx,5} = LO_freq;
idx = idx + 1;

% AGBT16B_400_04 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
session = AGBT16B_400_04;
on_scan = 10;  off_scan = 11;
source = source3C295;
LO_freq = 1450;
onoffs{idx,1} = session;
onoffs{idx,2} = on_scan;
onoffs{idx,3} = off_scan;
onoffs{idx,4} = source;
onoffs{idx,5} = LO_freq;
idx = idx + 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 1st Frequency sweep
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% AGBT16B_400_05 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
session = AGBT16B_400_05;
on_scan = 2;  off_scan = 3;
source = source3C48;
LO_freq = 1350;
onoffs{idx,1} = session;
onoffs{idx,2} = on_scan;
onoffs{idx,3} = off_scan;
onoffs{idx,4} = source;
onoffs{idx,5} = LO_freq;
idx = idx + 1;

session = AGBT16B_400_05;
on_scan = 4;  off_scan = 5;
source = source3C147;
LO_freq = 1350;
onoffs{idx,1} = session;
onoffs{idx,2} = on_scan;
onoffs{idx,3} = off_scan;
onoffs{idx,4} = source;
onoffs{idx,5} = LO_freq;
idx = idx + 1;

session = AGBT16B_400_05;
on_scan = 6;  off_scan = 7;
source = source3C147;
LO_freq = 1075;
onoffs{idx,1} = session;
onoffs{idx,2} = on_scan;
onoffs{idx,3} = off_scan;
onoffs{idx,4} = source;
onoffs{idx,5} = LO_freq;
idx = idx + 1;

session = AGBT16B_400_05;
on_scan = 8;  off_scan = 9;
source = source3C147;
LO_freq = 1200;
onoffs{idx,1} = session;
onoffs{idx,2} = on_scan;
onoffs{idx,3} = off_scan;
onoffs{idx,4} = source;
onoffs{idx,5} = LO_freq;
idx = idx + 1;

session = AGBT16B_400_05;
on_scan = 10;  off_scan = 11;
source = source3C147;
LO_freq = 1325;
onoffs{idx,1} = session;
onoffs{idx,2} = on_scan;
onoffs{idx,3} = off_scan;
onoffs{idx,4} = source;
onoffs{idx,5} = LO_freq;
idx = idx + 1;

session = AGBT16B_400_05;
on_scan = 12;  off_scan = 13;
source = source3C147;
LO_freq = 1450;
onoffs{idx,1} = session;
onoffs{idx,2} = on_scan;
onoffs{idx,3} = off_scan;
onoffs{idx,4} = source;
onoffs{idx,5} = LO_freq;
idx = idx + 1;

session = AGBT16B_400_05;
on_scan = 14;  off_scan = 15;
source = source3C147;
LO_freq = 1575;
onoffs{idx,1} = session;
onoffs{idx,2} = on_scan;
onoffs{idx,3} = off_scan;
onoffs{idx,4} = source;
onoffs{idx,5} = LO_freq;
idx = idx + 1;

session = AGBT16B_400_05;
on_scan = 16;  off_scan = 17;
source = source3C147;
LO_freq = 1700;
onoffs{idx,1} = session;
onoffs{idx,2} = on_scan;
onoffs{idx,3} = off_scan;
onoffs{idx,4} = source;
onoffs{idx,5} = LO_freq;
idx = idx + 1;

session = AGBT16B_400_05;
on_scan = 19;  off_scan = 20;
source = source3C147;
LO_freq = 1450;
onoffs{idx,1} = session;
onoffs{idx,2} = on_scan;
onoffs{idx,3} = off_scan;
onoffs{idx,4} = source;
onoffs{idx,5} = LO_freq;
idx = idx + 1;

session = AGBT16B_400_13;
on_scan = 112;  off_scan = 113;
source = source3C123;
LO_freq = 1075;
onoffs{idx,1} = session;
onoffs{idx,2} = on_scan;
onoffs{idx,3} = off_scan;
onoffs{idx,4} = source;
onoffs{idx,5} = LO_freq;
idx = idx + 1;

session = AGBT16B_400_13;
on_scan = 114;  off_scan = 115;
source = source3C123;
LO_freq = 1150;
onoffs{idx,1} = session;
onoffs{idx,2} = on_scan;
onoffs{idx,3} = off_scan;
onoffs{idx,4} = source;
onoffs{idx,5} = LO_freq;
idx = idx + 1;

session = AGBT16B_400_13;
on_scan = 118;  off_scan = 119;
source = source3C123;
LO_freq = 1225;
onoffs{idx,1} = session;
onoffs{idx,2} = on_scan;
onoffs{idx,3} = off_scan;
onoffs{idx,4} = source;
onoffs{idx,5} = LO_freq;
idx = idx + 1;

session = AGBT16B_400_13;
on_scan = 120;  off_scan = 121;
source = source3C123;
LO_freq = 1450;
onoffs{idx,1} = session;
onoffs{idx,2} = on_scan;
onoffs{idx,3} = off_scan;
onoffs{idx,4} = source;
onoffs{idx,5} = LO_freq;
idx = idx + 1;

session = AGBT16B_400_13;
on_scan = 122;  off_scan = 123;
source = source3C123;
LO_freq = 1375;
onoffs{idx,1} = session;
onoffs{idx,2} = on_scan;
onoffs{idx,3} = off_scan;
onoffs{idx,4} = source;
onoffs{idx,5} = LO_freq;
idx = idx + 1;

session = AGBT16B_400_13;
on_scan = 124;  off_scan = 125;
source = source3C123;
LO_freq = 1300;
onoffs{idx,1} = session;
onoffs{idx,2} = on_scan;
onoffs{idx,3} = off_scan;
onoffs{idx,4} = source;
onoffs{idx,5} = LO_freq;
idx = idx + 1;

session = AGBT16B_400_13;
on_scan = 126;  off_scan = 127;
source = source3C123;
LO_freq = 1150;
onoffs{idx,1} = session;
onoffs{idx,2} = on_scan;
onoffs{idx,3} = off_scan;
onoffs{idx,4} = source;
onoffs{idx,5} = LO_freq;
idx = idx + 1;

session = AGBT16B_400_13;
on_scan = 128;  off_scan = 129;
source = source3C123;
LO_freq = 1525;
onoffs{idx,1} = session;
onoffs{idx,2} = on_scan;
onoffs{idx,3} = off_scan;
onoffs{idx,4} = source;
onoffs{idx,5} = LO_freq;
idx = idx + 1;

session = AGBT16B_400_13;
on_scan = 130;  off_scan = 131;
source = source3C123;
LO_freq = 1600;
onoffs{idx,1} = session;
onoffs{idx,2} = on_scan;
onoffs{idx,3} = off_scan;
onoffs{idx,4} = source;
onoffs{idx,5} = LO_freq;
idx = idx + 1;

session = AGBT16B_400_13;
on_scan = 132;  off_scan = 133;
source = source3C123;
LO_freq = 1675;
onoffs{idx,1} = session;
onoffs{idx,2} = on_scan;
onoffs{idx,3} = off_scan;
onoffs{idx,4} = source;
onoffs{idx,5} = LO_freq;
idx = idx + 1;

session = AGBT16B_400_13;
on_scan = 134;  off_scan = 135;
source = source3C123;
LO_freq = 1750;
onoffs{idx,1} = session;
onoffs{idx,2} = on_scan;
onoffs{idx,3} = off_scan;
onoffs{idx,4} = source;
onoffs{idx,5} = LO_freq;
idx = idx + 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2nd Frequency sweep
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
idx = 1;
% AGBT17B_360_06 LO = 1075 Seven-pt cal %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
onoffs_7pt = {};

session = AGBT17B_360_06;
on_scan = [6:12];
off_scan = [5,13];
source = source3C48;
LO_freq = 1075;
onoffs_7pt{idx,1} = session;
onoffs_7pt{idx,2} = on_scan;
onoffs_7pt{idx,3} = off_scan;
onoffs_7pt{idx,4} = source;
onoffs_7pt{idx,5} = LO_freq;
idx = idx + 1;


% AGBT17B_360_06 LO = 1250 Seven-pt cal %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
session = AGBT17B_360_06;
on_scan = [15:21];
off_scan = [14,22];
source = source3C48;
LO_freq = 1250;
onoffs_7pt{idx,1} = session;
onoffs_7pt{idx,2} = on_scan;
onoffs_7pt{idx,3} = off_scan;
onoffs_7pt{idx,4} = source;
onoffs_7pt{idx,5} = LO_freq;
idx = idx + 1;

% AGBT17B_360_06 LO = 1350 Seven-pt cal %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
session = AGBT17B_360_06;
on_scan = [24:30];
off_scan = [23,31];
source = source3C48;
LO_freq = 1350;
onoffs_7pt{idx,1} = session;
onoffs_7pt{idx,2} = on_scan;
onoffs_7pt{idx,3} = off_scan;
onoffs_7pt{idx,4} = source;
onoffs_7pt{idx,5} = LO_freq;
idx = idx + 1;

% AGBT17B_360_06 LO = 1550 Seven-pt cal %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
session = AGBT17B_360_06;
on_scan = [33:39];
off_scan = [32,40];
source = source3C48;
LO_freq = 1550;
onoffs_7pt{idx,1} = session;
onoffs_7pt{idx,2} = on_scan;
onoffs_7pt{idx,3} = off_scan;
onoffs_7pt{idx,4} = source;
onoffs_7pt{idx,5} = LO_freq;
idx = idx + 1;

% AGBT17B_360_06 LO = 1650 Seven-pt cal %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

session = AGBT17B_360_06;
on_scan = [42:48];
off_scan = [41,49];
source = source3C48;
LO_freq = 1650;
onoffs_7pt{idx,1} = session;
onoffs_7pt{idx,2} = on_scan;
onoffs_7pt{idx,3} = off_scan;
onoffs_7pt{idx,4} = source;
onoffs_7pt{idx,5} = LO_freq;
idx = idx + 1;

% AGBT17B_360_06 LO = 1750 Seven-pt cal %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
session = AGBT17B_360_06;
on_scan = [51:57];
off_scan = [50,58];
source = source3C48;
LO_freq = 1750;
onoffs_7pt{idx,1} = session;
onoffs_7pt{idx,2} = on_scan;
onoffs_7pt{idx,3} = off_scan;
onoffs_7pt{idx,4} = source;
onoffs_7pt{idx,5} = LO_freq;
idx = idx + 1;

% AGBT17B_360_06 LO = 1450 Seven-pt cal %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
session = AGBT17B_360_06;
on_scan = [63:69];
off_scan = [62,70];
source = source3C48;
LO_freq = 1450;
onoffs_7pt{idx,1} = session;
onoffs_7pt{idx,2} = on_scan;
onoffs_7pt{idx,3} = off_scan;
onoffs_7pt{idx,4} = source;
onoffs_7pt{idx,5} = LO_freq;
idx = idx + 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%