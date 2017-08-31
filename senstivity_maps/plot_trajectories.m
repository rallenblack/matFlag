% Plot trajectories of scans
% Aggregate weights and plot sensitvity map
close all;
clearvars;

addpath ../kernel/
scan_table; % Found in kernel directory
source_table; % Found in kernel directory

tic;

% % AGBT16B_400_01 Grid %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% session = AGBT16B_400_01;
% on_scans = [34, 35, 37, 38, 40, 41, 43, 44, 46, 47, 49, ...
%             50, 65:70, 72, 74:78, 80:85];
% off_scans = [33, 36, 39, 42, 45, 48, 51, 64, ...
%              71, 79];
% source = source3C295;

% % AGBT16B_400_02 Grid %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% session = AGBT16B_400_02;
% on_scans = [13:15, 17:19, 21:23, 25:27, 29:31,...
%             33:35, 37:39, 41:43, 45:47, 49:51, 53:55];
% off_scans = [16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56];
% source = source3C295;

% AGBT16B_400_03 Grid %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% session = AGBT16B_400_03;
% on_scans = [12:14, 16:18, 20:22, 24:26, 28:30, 32:34, 36:38, 40:42, 44:46, 48:50, 52:54];
% off_scans = [15, 19, 23, 27, 31, 35, 39, 43, 47, 51];
% source = source3C295;
% Nint = 10;

% % HI Source M101 - CALCORR
% on_scans = 56;
% off_scans = 57;
% % HI Source M101 - PFBCORR
% on_scans = [58, 59, 61, 63];
% off_scans = [60, 64];

% % AGBT16B_400_04 Grid %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% session = AGBT16B_400_04;
% % Calibrator
% on_scans = [13:19];
% off_scans = [12, 20];
% % Daisy
% on_scans = 22;
% off_scans = [21, 23];

% % AGBT16B_400_05 Grid %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% session = AGBT16B_400_05;
% on_scans = 24;
% off_scans = [23, 25];

% AGBT16B_400_09 Grid %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% session = AGBT16B_400_09;
% % % ON/OFF
% % on_scans = 5; 
% % off_scans = 12;
% % Calibrator
% on_scans = [7:11, 13:17, 19:23, 25:29, 34:38, 40:44, 46:47]; % 5; % 16& 17 bad blocks(B,C,D), 29 & 31 Bank L did not start
% off_scans = [12, 18, 24, 30, 39, 45]; % 12; % 30 Bank L stalled
% source = source3C48;

% % AGBT16B_400_09 Grid %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% session = AGBT16B_400_10;
% % % ON/OFF
% % on_scans = 5; 
% % off_scans = 12;
% % Calibrator
% on_scans = [];
% off_scans = []; 
% source = source3C295;
% Nint = 8;

% AGBT16B_400_12 Grid %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
session = AGBT16B_400_12;
% Calibrator
on_scans = [32:36, 38:42, 44:48, 50:54, 56:60, 66:70, 72:81];
off_scans = [37, 43, 49, 55, 61, 71];
source = source3C295;
Nint = 2;


on_tstamp = session.scans(on_scans);
off_tstamp = session.scans(off_scans);

proj_str = session.session_name;
ant_dir = sprintf('%s/%s/Antenna', meta_root, proj_str);


% Iterate over off pointings just to have them ready
% Iterate over on pointings and look for closest off pointing

% Iterate over off pointings
AZoff = zeros(length(off_tstamp), 1);
ELoff = zeros(length(off_tstamp), 1);
fprintf('Processing off pointings...\n');
on_off = 1;
for j = 1:length(off_tstamp)
    tmp_stmp = off_tstamp{j};
    fprintf('    Time stamp: %s - %d/%d\n', tmp_stmp, j, length(off_tstamp));
   
    % Generate filename
    filename = sprintf('%s/%s.fits', ant_dir, tmp_stmp);
    [dmjd, az_tmp, el_tmp, ra, dec] =...
        get_antenna_positions(filename, on_off, 0);
       
    % Off pointings are dwell scans; need single R, az, and el
    az = mean(az_tmp);
    el = mean(el_tmp);
    
    % Create entry in position table
    AZoff(j) = az;
    ELoff(j) = el;
end
   
figure(1);
plot(AZoff, ELoff, 'x');

% Iterate over on pointings
fprintf('Processing on pointings...\n');
AZ = [];
EL = [];
on_off = 1;
for i = 1:length(on_tstamp)
    tmp_stmp = on_tstamp{i};
    fprintf('    Time stamp: %s - %d/%d\n', tmp_stmp, i, length(on_tstamp));
   
    % Generate filename
    filename = sprintf('%s/%s.fits', ant_dir, tmp_stmp);
    
    [dmjd, az, el, ra, dec] =...
        get_antenna_positions(filename, on_off, 0);
    
    % Off pointings are dwell scans; need single R, az, and el
    hold on;
    plot(az, el, '-b'); % 'rx'
    hold off;
    drawnow;
end
