% Global parameters
data_root = '/lustre/flag';
meta_root = '/home/gbtdata';
meta_root1 = '/home/archive/science-data/16B';
weight_dir = '/home/groups/flag/weight_files/';
proj_id = 'AGBT16B_400';
proj_id_2 = 'AGBT17B_360';
proj_id_3 = 'AGBT17B_221';
proj_id_4 = 'AGBT17B_455';
proj_id_5 = 'AGBT18A_443';
proj_id_6 = 'AGBT19A_407';
proj_id_7 = 'AGBT19A_221';
proj_id_8 = 'AGBT18B_358';
proj_id_9 = 'AGBT19A_091';
proj_id_10 = 'AGBT19A_365';
proj_id_11 ='AGBT19A_116';
obs_long = 38.419531;
obs_lat  = -79.831808;
G = 6.6; % Approximate for constant of the year used to calculate GST

%% AGBT16B_400_01
% Scan numbers and time stamps
AGBT16B_400_01.session_name = 'AGBT16B_400_01';
log_filename = sprintf('%s/%s_01/ScanLog.fits', meta_root1, proj_id);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT16B_400_01.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [ 21:25,   41:45,   81:100,... 
             121:125, 141:145, 181:200,...
             221:225, 241:245, 281:300,...
             321:325, 341:345, 381:400,...
             421:425, 441:445, 481:500];
AGBT16B_400_01.bad_freqs = bad_freqs;

% Element mappings
X = [1:19];
Y = [21, 20, 23:39];
goodX = X; goodX(X < 9) = [];
goodY = Y; goodY(Y==34) = [];

AGBT16B_400_01.X = X;
AGBT16B_400_01.Y = Y;
AGBT16B_400_01.goodX = goodX;
AGBT16B_400_01.goodY = goodY;

AGBT16B_400_01.fudge = 35/51;
AGBT16B_400_01.Xdims = [-0.25, 0.25];
AGBT16B_400_01.Ydims = [-0.175, 0.275];

AGBT16B_400_01.on_scans  = [34, 35, 37, 38, 40, 41, 43, 44, 46, 47, 49, ...
                            50, 65:70, 72, 74:78, 80:85];
AGBT16B_400_01.off_scans = [33, 36, 39, 42, 45, 48, 51, 64, ... 
                            71, 79];
                        
AGBT16B_400_01.beam_el = [0.2, 0.2, 0.05, 0.05, 0.05, -0.1, -0.1];
AGBT16B_400_01.beam_az = [-0.22, 0.1, -0.14, -0.03, 0.1, -0.2, 0.2];

%% AGBT16B_400_02
AGBT16B_400_02.session_name = 'AGBT16B_400_02';
log_filename = sprintf('%s/%s_02/ScanLog.fits', meta_root1, proj_id);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT16B_400_02.scans{i} = my_stamp;
    % Get GMST to calculate az and el using ra and dec.
    ut_hr = str2double([my_stamp(12) my_stamp(13)]);
    ut_min = str2double([my_stamp(15) my_stamp(16)]);
    ut_sec = str2double([my_stamp(18) my_stamp(19)]);
    t = ut_hr + (ut_min/60) + (ut_sec/3600);
    my_day = str2double([my_stamp(9) my_stamp(10)]);
    day_year = 120;
    d = day_year + my_day;
    AGBT16B_400_02.GMST(i) = G + 0.0657098244*d + 1.00273791*t;
end

% Frequency mask
bad_freqs = [ 21:25,   41:45,   81:100,...
             121:125, 141:145, 181:200,...
             221:225, 241:245, 281:300,...
             321:325, 341:345, 381:400,...
             421:425, 441:445, 481:500];
AGBT16B_400_02.bad_freqs = bad_freqs;

% Element mappings
X = [1:19];
Y = [21, 20, 23:39];
goodX = X;
goodY = Y; goodY(Y==34) = [];

AGBT16B_400_02.X = X;
AGBT16B_400_02.Y = Y;
AGBT16B_400_02.goodX = goodX;
AGBT16B_400_02.goodY = goodY;

AGBT16B_400_02.Xdims = [212.3099, 213.3816];
AGBT16B_400_02.Ydims = [51.8602, 52.5221];

AGBT16B_400_02.fudge = 0;

AGBT16B_400_02.on_scans = [13:15, 17:19, 21:23, 25:27, 29:31,...
                           33:35, 37:39, 41:43, 45:47, 49:51, 53:55];
AGBT16B_400_02.off_scans = [16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56];

AGBT16B_400_02.beam_el = [52.23, 52.32, 52.1,  52.19, 52.28, 52.07, 52.19];
AGBT16B_400_02.beam_az = [212.7, 212.9, 212.7, 212.9, 213.1, 212.9, 213.1];

%% AGBT16B_400_03
AGBT16B_400_03.session_name = 'AGBT16B_400_03';
log_filename = sprintf('%s/%s_03/ScanLog.fits', meta_root1, proj_id);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT16B_400_03.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [ 21:25,   41:45,   81:100,...
             121:125, 141:145, 181:200,...
             221:225, 241:245, 281:300,...
             321:325, 341:345, 381:400,...
             421:425, 441:445, 481:500];
AGBT16B_400_03.bad_freqs = bad_freqs;

% Element mappings
X = [1:12, 14, 13, 15:19];
Y = [21, 20, 23:39];
goodX = X;
goodY = Y; goodY(Y==34) = [];

AGBT16B_400_03.X = X;
AGBT16B_400_03.Y = Y;
AGBT16B_400_03.goodX = goodX;
AGBT16B_400_03.goodY = goodY;

AGBT16B_400_03.fudge = 0;
AGBT16B_400_03.Xdims = [-0.25, 0.25];
AGBT16B_400_03.Ydims = [-0.15, 0.25];

AGBT16B_400_03.on_scans = [11:14, 16:18, 20:22, 24:26, 28:30, 32:34, ...
                           36:38, 40:42, 44:46, 48:50, 52:54];
AGBT16B_400_03.off_scans = [15, 19, 23, 27, 31, 35, 39, 43, 47, 51];

AGBT16B_400_03.beam_el = [ 1.0, 1.0,  0.0, 0.0, 0.0, -1.0, -1.0]*9/60 + 5/60;
AGBT16B_400_03.beam_az = [-0.5, 0.5, -1.0, 0.0, 1.0, -0.5,  0.5]*9/60;

%% AGBT16B_400_04
AGBT16B_400_04.session_name = 'AGBT16B_400_04';
log_filename = sprintf('%s/%s_04/ScanLog.fits', meta_root1, proj_id);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT16B_400_04.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [ 21:25,   41:45,   81:100,...
             121:125, 141:145, 181:200,...
             221:225, 241:245, 281:300,...
             321:325, 341:345, 381:400,...
             421:425, 441:445, 481:500];
AGBT16B_400_04.bad_freqs = bad_freqs;

% Element mappings
X = [1:19];
Y = [21, 20, 23:39];
goodX = X;
goodY = Y; goodY(Y==34) = [];

AGBT16B_400_04.X = X;
AGBT16B_400_04.Y = Y;
AGBT16B_400_04.goodX = goodX;
AGBT16B_400_04.goodY = goodY;

AGBT16B_400_04.fudge = 0;
AGBT16B_400_04.Xdims = [212.4, 213.3];
AGBT16B_400_04.Ydims = [51.9, 52.5];

AGBT16B_400_04.on_scans = 22;
AGBT16B_400_04.off_scans = [21, 23];

AGBT16B_400_04.beam_el = [52.35, 52.35, 52.2,  52.2, 52.2, 52.07, 52.07];% [52.23, 52.23, 52.2,  52.2, 52.2, 52.1, 52.1];
AGBT16B_400_04.beam_az = [212.9, 213.11, 212.9, 213.07, 213.16, 212.9, 213.16];

%% AGBT16B_400_05
AGBT16B_400_05.session_name = 'AGBT16B_400_05';
log_filename = sprintf('%s/%s_05/ScanLog.fits', meta_root1, proj_id);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT16B_400_05.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [ 21:25,   41:45,   81:100,...
             121:125, 141:145, 181:200,...
             221:225, 241:245, 281:300,...
             321:325, 341:345, 381:400,...
             421:425, 441:445, 481:500];
AGBT16B_400_05.bad_freqs = bad_freqs;

% Element mappings
Xtmp = [1:19];
Ytmp = [21, 20, 23:39];
goodX = X;
goodY = Y; goodY(Y==34) = [];

AGBT16B_400_05.X = X;
AGBT16B_400_05.Y = Y;
AGBT16B_400_05.goodX = goodX;
AGBT16B_400_05.goodY = goodY;

AGBT16B_400_05.fudge = 0;

AGBT16B_400_05.on_scans = 24;
AGBT16B_400_05.off_scans = [23, 25];

AGBT16B_400_05.Xdims = [85.25, 86.05];
AGBT16B_400_05.Ydims = [49.6, 50.1];

%% AGBT16B_400_07
% Scan numbers and time stamps
AGBT16B_400_07.session_name = 'AGBT16B_400_07';
log_filename = sprintf('%s/%s_07/ScanLog.fits', meta_root1, proj_id);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT16B_400_07.scans{i} = my_stamp;
end

% Frequency mask
% bad_freqs = [ 21:25,   41:45,   81:100,...
%              121:125, 141:145, 181:200,...
%              221:225, 241:245, 281:300,...
%              321:325, 341:345, 381:400,...
%              421:425, 441:445, 481:500];
bad_freqs = [];
AGBT16B_400_07.bad_freqs = bad_freqs;

% Element mappings
X = [1:7, 9:19];
Y = [21, 20, 23:39];
goodX = X; goodX(X < 9) = [];
goodY = Y; goodY(Y==34) = [];

AGBT16B_400_07.X = X;
AGBT16B_400_07.Y = Y;
AGBT16B_400_07.goodX = goodX;
AGBT16B_400_07.goodY = goodY;

AGBT16B_400_07.fudge = 0;
AGBT16B_400_07.Xdims = [-0.25, 0.25];
AGBT16B_400_07.Ydims = [-0.175, 0.275];

AGBT16B_400_07.on_scans  = [1, 2, 3];
AGBT16B_400_07.off_scans = [1, 2, 3];
                        
AGBT16B_400_07.beam_el = [0.2, 0.2, 0.05, -0.1, -0.1];
AGBT16B_400_07.beam_az = [-0.22, 0.1, 0.1, -0.2, 0.2];

%% AGBT16B_400_09
% Scan numbers and time stamps
AGBT16B_400_09.session_name = 'AGBT16B_400_09';
log_filename = sprintf('%s/%s_09/ScanLog.fits', meta_root1, proj_id);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT16B_400_09.scans{i} = my_stamp;
end

% Frequency mask
% bad_freqs = [ 21:25,   41:45,   81:100,...
%              121:125, 141:145, 181:200,...
%              221:225, 241:245, 281:300,...
%              321:325, 341:345, 381:400,...
%              421:425, 441:445, 481:500];
bad_freqs = [56:60, 156:160, 256:260, 356:360, 456:460];
AGBT16B_400_09.bad_freqs = bad_freqs;

% Element mappings
X = [1:7, 35, 9:12, 14, 13, 15:19];
Y = [21, 20, 23:33, 36:39]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y; % goodY(Y==34) = [];

AGBT16B_400_09.X = X;
AGBT16B_400_09.Y = Y;
AGBT16B_400_09.goodX = goodX;
AGBT16B_400_09.goodY = goodY;

AGBT16B_400_09.fudge = 0;
AGBT16B_400_09.Xdims = [-0.23, 0.23];
AGBT16B_400_09.Ydims = [-0.23, 0.23];

% AGBT16B_400_09.Xdims = [24.1, 24.7];
% AGBT16B_400_09.Ydims = [33, 33.3];

AGBT16B_400_09.on_scans  = [1:47];
AGBT16B_400_09.off_scans = [1:45];
                
%AGBT16B_400_09.beam_el = [0.2202, 0.2202, 0.08364, 0.08364, 0.08364, -0.04742, -0.04742];
%AGBT16B_400_09.beam_az = [-0.1036, 0.07091, -0.2018, -0.01091, 0.1636, -0.12, 0.09818];
AGBT16B_400_09.beam_el = [ 1.0, 1.0,  0.0, 0.0, 0.0, -1.0, -1.0]*9/60;
AGBT16B_400_09.beam_az = [-0.5, 0.5, -1.0, 0.0, 1.0, -0.5,  0.5]*9/60;

% AGBT16B_400_09.beam_el = [33.25, 33.25, 33.19, 33.19, 33.19, 33.13, 33.13];
% AGBT16B_400_09.beam_az = [24.2, 24.52, 24.31, 24.42, 24.57, 24.2, 24.5];

% %% AGBT16B_400_10
% % Scan numbers and time stamps
% AGBT16B_400_10.session_name = 'AGBT16B_400_10';
% log_filename = sprintf('%s/%s_10/ScanLog.fits', meta_root, proj_id);
% scan_data = fitsread(log_filename, 'bintable', 1);
% time_stamps = unique(scan_data{1});
% 
% for i = 1:length(time_stamps)
%     my_stamp = time_stamps{i};
%     my_stamp = strrep(my_stamp, '-', '_');
%     my_stamp = strrep(my_stamp, 'T', '_');
%     AGBT16B_400_10.scans{i} = my_stamp;
% end
% 
% % Frequency mask
% % bad_freqs = [ 21:25,   41:45,   81:100,...
% %              121:125, 141:145, 181:200,...
% %              221:225, 241:245, 281:300,...
% %              321:325, 341:345, 381:400,...
% %              421:425, 441:445, 481:500];
% bad_freqs = [56:60, 156:160, 256:260, 356:360, 456:460];
% AGBT16B_400_10.bad_freqs = bad_freqs;
% 
% % Element mappings
% X = [1:7, 35, 9:19];
% Y = [21, 20, 23:33, 36:39]; % [21, 20, 23:34, 8, 36:39];
% goodX = X; % goodX(X < 9) = [];
% goodY = Y; % goodY(Y==34) = [];
% 
% AGBT16B_400_10.X = X;
% AGBT16B_400_10.Y = Y;
% AGBT16B_400_10.goodX = goodX;
% AGBT16B_400_10.goodY = goodY;
% 
% AGBT16B_400_10.fudge = 0;
% AGBT16B_400_10.Xdims = [24.1, 24.7];
% AGBT16B_400_10.Ydims = [33, 33.3];
% 
% AGBT16B_400_10.on_scans  = [1:47];
% AGBT16B_400_10.off_scans = [1:45];
%                         
% AGBT16B_400_10.beam_el = [33.25, 33.25, 33.19, 33.19, 33.19, 33.13, 33.13];
% AGBT16B_400_10.beam_az = [24.2, 24.52, 24.31, 24.42, 24.57, 24.2, 24.5];


%% AGBT16B_400_11
% % Scan numbers and time stamps
AGBT16B_400_11.session_name = 'AGBT16B_400_11';
log_filename = sprintf('%s/%s_11/ScanLog.fits', meta_root1, proj_id);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT16B_400_11.scans{i} = my_stamp;
end

% Frequency mask
% bad_freqs = [ 21:25,   41:45,   81:100,...
%              121:125, 141:145, 181:200,...
%              221:225, 241:245, 281:300,...
%              321:325, 341:345, 381:400,...
%              421:425, 441:445, 481:500];
bad_freqs = [];
AGBT16B_400_11.bad_freqs = bad_freqs;

% Element mappings
X = [1:7, 35, 9:12, 14, 13, 15:19];
Y = [21, 20, 23:33, 36:39]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y; % goodY(Y==34) = [];

AGBT16B_400_11.X = X;
AGBT16B_400_11.Y = Y;
AGBT16B_400_11.goodX = goodX;
AGBT16B_400_11.goodY = goodY;

AGBT16B_400_11.fudge = 0;
AGBT16B_400_11.Xdims = [-0.23, 0.23];
AGBT16B_400_11.Ydims = [-0.23, 0.23];
                
AGBT16B_400_11.beam_el = [ 1.0, 1.0,  0.0, 0.0, 0.0, -1.0, -1.0]*9/60;
AGBT16B_400_11.beam_az = [-0.5, 0.5, -1.0, 0.0, 1.0, -0.5,  0.5]*9/60;


%% AGBT16B_400_12
% % Scan numbers and time stamps
AGBT16B_400_12.session_name = 'AGBT16B_400_12';
log_filename = sprintf('%s/%s_12/ScanLog.fits', meta_root1, proj_id);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT16B_400_12.scans{i} = my_stamp;
end

% Frequency mask
% bad_freqs = [ 21:25,   41:45,   81:100,...
%              121:125, 141:145, 181:200,...
%              221:225, 241:245, 281:300,...
%              321:325, 341:345, 381:400,...
%              421:425, 441:445, 481:500];
bad_freqs = [36:45, 136:145, 236:245, 336:345, 436:445,...
             81:85, 181:185, 281:285, 381:385, 481:485];
AGBT16B_400_12.bad_freqs = bad_freqs;

% Element mappings
X = [1:7, 35, 9:12, 14, 13, 15:19];
Y = [21, 20, 23:34, 8, 36:39]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y; goodY(Y==8) = []; goodY(Y==34) = []; goodY(Y==29) = [];

AGBT16B_400_12.X = X;
AGBT16B_400_12.Y = Y;
AGBT16B_400_12.goodX = goodX;
AGBT16B_400_12.goodY = goodY;

AGBT16B_400_12.fudge = 0;
AGBT16B_400_12.Xdims = [-0.325, 0.325];
AGBT16B_400_12.Ydims = [-0.325, 0.325];
                
AGBT16B_400_12.beam_el = [ 1.0, 1.0,  0.0, 0.0, 0.0, -1.0, -1.0]*9/60;
AGBT16B_400_12.beam_az = [-0.5, 0.5, -1.0, 0.0, 1.0, -0.5,  0.5]*9/60;


%% AGBT16B_400_13
% % Scan numbers and time stamps
AGBT16B_400_13.session_name = 'AGBT16B_400_13';
log_filename = sprintf('%s/%s_13/ScanLog.fits', meta_root1, proj_id);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT16B_400_13.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT16B_400_13.bad_freqs = bad_freqs;

% Element mappings
X = [1:7, 35, 9:12, 14, 13, 15:19];
Y = [21, 20, 23:33, 36:39]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
goodY(Y==33) = [];

AGBT16B_400_13.X = X;
AGBT16B_400_13.Y = Y;
AGBT16B_400_13.goodX = goodX;
AGBT16B_400_13.goodY = goodY;

AGBT16B_400_13.fudge = 0;
AGBT16B_400_13.Xdims = [-0.23, 0.23];
AGBT16B_400_13.Ydims = [-0.23, 0.23];
                
AGBT16B_400_13.beam_el = [ 1.0, 1.0,  0.0, 0.0, 0.0, -1.0, -1.0]*9/60;
AGBT16B_400_13.beam_az = [-0.5, 0.5, -1.0, 0.0, 1.0, -0.5,  0.5]*9/60;


%% AGBT16B_400_14
% % Scan numbers and time stamps
AGBT16B_400_14.session_name = 'AGBT16B_400_14';
log_filename = sprintf('%s/%s_14/ScanLog.fits', meta_root1, proj_id);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT16B_400_14.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT16B_400_14.bad_freqs = bad_freqs;

% Element mappings
X = [1:7, 35, 9:12, 14, 13, 15:19];
Y = [21, 20, 23:33, 36:39]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
goodY(Y==33) = [];

AGBT16B_400_14.X = X;
AGBT16B_400_14.Y = Y;
AGBT16B_400_14.goodX = goodX;
AGBT16B_400_14.goodY = goodY;

AGBT16B_400_14.fudge = 0;
AGBT16B_400_14.Xdims = [-0.23, 0.23];
AGBT16B_400_14.Ydims = [-0.23, 0.23];
                
AGBT16B_400_14.beam_el = [ 1.0, 1.0,  0.0, 0.0, 0.0, -1.0, -1.0]*9/60;
AGBT16B_400_14.beam_az = [-0.5, 0.5, -1.0, 0.0, 1.0, -0.5,  0.5]*9/60;

%% AGBT17B_360_01
% % Scan numbers and time stamps
AGBT17B_360_01.session_name = 'AGBT17B_360_01';
log_filename = sprintf('%s/%s_01/ScanLog.fits', meta_root, proj_id_2);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT17B_360_01.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT17B_360_01.bad_freqs = bad_freqs;

% Element mappings
X = [1:7, 35, 9:12, 14, 13, 15:19];
Y = [21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT17B_360_01.X = X;
AGBT17B_360_01.Y = Y;
AGBT17B_360_01.goodX = goodX;
AGBT17B_360_01.goodY = goodY;

AGBT17B_360_01.fudge = 0;
AGBT17B_360_01.Xdims = [-0.23, 0.23];
AGBT17B_360_01.Ydims = [-0.23, 0.23];
                
AGBT17B_360_01.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT17B_360_01.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;

%% AGBT17B_360_02
% % Scan numbers and time stamps
AGBT17B_360_02.session_name = 'AGBT17B_360_02';
log_filename = sprintf('%s/%s_02/ScanLog.fits', meta_root, proj_id_2);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT17B_360_02.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT17B_360_02.bad_freqs = bad_freqs;

% Element mappings
X = [1:7, 35, 9:12, 14, 13, 15:19];
Y = [21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT17B_360_02.X = X;
AGBT17B_360_02.Y = Y;
AGBT17B_360_02.goodX = goodX;
AGBT17B_360_02.goodY = goodY;

AGBT17B_360_02.fudge = 0;
AGBT17B_360_02.Xdims = [-0.23, 0.23];
AGBT17B_360_02.Ydims = [-0.23, 0.23];
                
AGBT17B_360_02.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT17B_360_02.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;

%% AGBT17B_360_03
% % Scan numbers and time stamps
AGBT17B_360_03.session_name = 'AGBT17B_360_03';
log_filename = sprintf('%s/%s_03/ScanLog.fits', meta_root, proj_id_2);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT17B_360_03.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT17B_360_03.bad_freqs = bad_freqs;

% Element mappings
X = [1:7, 35, 9:12, 14, 13, 15:19];
Y = [21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT17B_360_03.X = X;
AGBT17B_360_03.Y = Y;
AGBT17B_360_03.goodX = goodX;
AGBT17B_360_03.goodY = goodY;

AGBT17B_360_03.fudge = 0;
AGBT17B_360_03.Xdims = [-0.23, 0.23];
AGBT17B_360_03.Ydims = [-0.23, 0.23];
                
AGBT17B_360_03.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT17B_360_03.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;

%% AGBT17B_360_04
% % Scan numbers and time stamps
AGBT17B_360_04.session_name = 'AGBT17B_360_04';
log_filename = sprintf('%s/%s_04/ScanLog.fits', meta_root, proj_id_2);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT17B_360_04.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [66:70, 166:170, 266:270, 366:370, 466:470];
AGBT17B_360_04.bad_freqs = bad_freqs;

% Element mappings
X = [1:7, 35, 9:12, 14, 13, 15:19];
Y = [21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT17B_360_04.X = X;
AGBT17B_360_04.Y = Y;
AGBT17B_360_04.goodX = goodX;
AGBT17B_360_04.goodY = goodY;

AGBT17B_360_04.fudge = 0;
AGBT17B_360_04.Xdims = [-0.23, 0.23];
AGBT17B_360_04.Ydims = [-0.23, 0.23];
                
AGBT17B_360_04.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT17B_360_04.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;

%% AGBT17B_360_05
% % Scan numbers and time stamps
AGBT17B_360_05.session_name = 'AGBT17B_360_05';
log_filename = sprintf('%s/%s_05/ScanLog.fits', meta_root, proj_id_2);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT17B_360_05.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT17B_360_05.bad_freqs = bad_freqs;

% Element mappings
X = [1:7, 35, 9:12, 14, 13, 15:19];
Y = [21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT17B_360_05.X = X;
AGBT17B_360_05.Y = Y;
AGBT17B_360_05.goodX = goodX;
AGBT17B_360_05.goodY = goodY;

AGBT17B_360_05.fudge = 0;
AGBT17B_360_05.Xdims = [-0.23, 0.23];
AGBT17B_360_05.Ydims = [-0.23, 0.23];
                
AGBT17B_360_05.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT17B_360_05.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;

%% AGBT17B_360_06
% % Scan numbers and time stamps
AGBT17B_360_06.session_name = 'AGBT17B_360_06';
log_filename = sprintf('%s/%s_06/ScanLog.fits', meta_root, proj_id_2);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT17B_360_06.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT17B_360_06.bad_freqs = bad_freqs;

% Element mappings
X = [1:7, 35, 9:12, 14, 13, 15:19];
Y = [21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT17B_360_06.X = X;
AGBT17B_360_06.Y = Y;
AGBT17B_360_06.goodX = goodX;
AGBT17B_360_06.goodY = goodY;

AGBT17B_360_06.fudge = 0;
AGBT17B_360_06.Xdims = [-0.23, 0.23];
AGBT17B_360_06.Ydims = [-0.23, 0.23];
                
AGBT17B_360_06.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT17B_360_06.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;

%% AGBT17B_360_07
% % Scan numbers and time stamps
AGBT17B_360_07.session_name = 'AGBT17B_360_07';
log_filename = sprintf('%s/%s_07/ScanLog.fits', meta_root, proj_id_2);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT17B_360_07.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT17B_360_07.bad_freqs = bad_freqs;

% Element mappings
X = [1:7, 35, 9:12, 14, 13, 15:19];
Y = [21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT17B_360_07.X = X;
AGBT17B_360_07.Y = Y;
AGBT17B_360_07.goodX = goodX;
AGBT17B_360_07.goodY = goodY;

AGBT17B_360_07.fudge = 0;
AGBT17B_360_07.Xdims = [-0.23, 0.23];
AGBT17B_360_07.Ydims = [-0.23, 0.23];
                
AGBT17B_360_07.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT17B_360_07.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;

%% AGBT17B_455_01
% % Scan numbers and time stamps
AGBT17B_455_01.session_name = 'AGBT17B_455_01';
log_filename = sprintf('%s/%s_01/ScanLog.fits', meta_root, proj_id_4);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT17B_455_01.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT17B_455_01.bad_freqs = bad_freqs;

% Element mappings
X = [1:7, 35, 9:12, 14, 13, 15:19];
Y = [21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT17B_455_01.X = X;
AGBT17B_455_01.Y = Y;
AGBT17B_455_01.goodX = goodX;
AGBT17B_455_01.goodY = goodY;

AGBT17B_455_01.fudge = 0;
AGBT17B_455_01.Xdims = [-0.23, 0.23];
AGBT17B_455_01.Ydims = [-0.23, 0.23];
               
AGBT17B_455_01.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT17B_455_01.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;

%% AGBT18A_443_01
% % Scan numbers and time stamps
AGBT18A_443_01.session_name = 'AGBT18A_443_01';
log_filename = sprintf('%s/%s_01/ScanLog.fits', meta_root, proj_id_5);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT18A_443_01.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT18A_443_01.bad_freqs = bad_freqs;

% Element mappings
X = [1:7, 35, 9:12, 14, 13, 15:19];
Y = [21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT18A_443_01.X = X;
AGBT18A_443_01.Y = Y;
AGBT18A_443_01.goodX = goodX;
AGBT18A_443_01.goodY = goodY;

AGBT18A_443_01.fudge = 0;
AGBT18A_443_01.Xdims = [-0.23, 0.23];
AGBT18A_443_01.Ydims = [-0.23, 0.23];
               
AGBT18A_443_01.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT18A_443_01.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;

%% AGBT17B_221_01
% % Scan numbers and time stamps
AGBT17B_221_01.session_name = 'AGBT17B_221_01';
log_filename = sprintf('%s/%s_01/ScanLog.fits', meta_root, proj_id_3);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT17B_221_01.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT17B_221_01.bad_freqs = bad_freqs;

% Element mappings
X = [1:7, 35, 9:12, 14, 13, 15:19];
Y = [21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT17B_221_01.X = X;
AGBT17B_221_01.Y = Y;
AGBT17B_221_01.goodX = goodX;
AGBT17B_221_01.goodY = goodY;

AGBT17B_221_01.fudge = 0;
AGBT17B_221_01.Xdims = [-0.23, 0.23];
AGBT17B_221_01.Ydims = [-0.23, 0.23];
                
AGBT17B_221_01.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT17B_221_01.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;

%% AGBT17B_221_02
% % Scan numbers and time stamps
AGBT17B_221_02.session_name = 'AGBT17B_221_02';
log_filename = sprintf('%s/%s_02/ScanLog.fits', meta_root, proj_id_3);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT17B_221_02.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT17B_221_02.bad_freqs = bad_freqs;

% Element mappings
X = [1:7, 35, 9:12, 14, 13, 15:19];
Y = [21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT17B_221_02.X = X;
AGBT17B_221_02.Y = Y;
AGBT17B_221_02.goodX = goodX;
AGBT17B_221_02.goodY = goodY;

AGBT17B_221_02.fudge = 0;
AGBT17B_221_02.Xdims = [-0.23, 0.23];
AGBT17B_221_02.Ydims = [-0.23, 0.23];
                
AGBT17B_221_02.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT17B_221_02.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;

%% AGBT17B_221_03
% % Scan numbers and time stamps
AGBT17B_221_03.session_name = 'AGBT17B_221_03';
log_filename = sprintf('%s/%s_03/ScanLog.fits', meta_root, proj_id_3);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT17B_221_03.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT17B_221_03.bad_freqs = bad_freqs;

% Element mappings
X = [1:7, 35, 9:12, 14, 13, 15:19];
Y = [21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT17B_221_03.X = X;
AGBT17B_221_03.Y = Y;
AGBT17B_221_03.goodX = goodX;
AGBT17B_221_03.goodY = goodY;

AGBT17B_221_03.fudge = 0;
AGBT17B_221_03.Xdims = [-0.23, 0.23];
AGBT17B_221_03.Ydims = [-0.23, 0.23];
                
AGBT17B_221_03.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT17B_221_03.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;

%% AGBT19A_407_01
% % Scan numbers and time stamps
AGBT19A_407_01.session_name = 'AGBT19A_407_01';
log_filename = sprintf('%s/%s_01/ScanLog.fits', meta_root, proj_id_6);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT19A_407_01.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT19A_407_01.bad_freqs = bad_freqs;

% Element mappings
X = [1:7, 35, 9:12, 14, 13, 15:19]; %[1:7,9:19]; %[1:7, 35, 9:12, 14, 13, 15:19];
Y = [21, 20, 23:34, 36:38]; % [20:38]; %[21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT19A_407_01.X = X;
AGBT19A_407_01.Y = Y;
AGBT19A_407_01.goodX = goodX;
AGBT19A_407_01.goodY = goodY;

AGBT19A_407_01.fudge = 0;
AGBT19A_407_01.Xdims = [-0.23, 0.23];
AGBT19A_407_01.Ydims = [-0.23, 0.23];
                
AGBT19A_407_01.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT19A_407_01.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;

%% AGBT19A_221_01
% % Scan numbers and time stamps
AGBT19A_221_01.session_name = 'AGBT19A_221_01';
log_filename = sprintf('%s/%s_01/ScanLog.fits', meta_root, proj_id_7);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT19A_221_01.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT19A_221_01.bad_freqs = bad_freqs;

% Element mappings
X = [1:7, 35, 9:12, 14, 13, 15:19]; %[1:7,9:19]; %[1:7, 35, 9:12, 14, 13, 15:19];
Y = [21, 20, 23:34, 36:38]; % [20:38]; %[21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT19A_221_01.X = X;
AGBT19A_221_01.Y = Y;
AGBT19A_221_01.goodX = goodX;
AGBT19A_221_01.goodY = goodY;

AGBT19A_221_01.fudge = 0;
AGBT19A_221_01.Xdims = [-0.23, 0.23];
AGBT19A_221_01.Ydims = [-0.23, 0.23];
                
AGBT19A_221_01.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT19A_221_01.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;

%% AGBT19A_407_02
% % Scan numbers and time stamps
AGBT19A_407_02.session_name = 'AGBT19A_407_02';
log_filename = sprintf('%s/%s_02/ScanLog.fits', meta_root, proj_id_6);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT19A_407_02.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT19A_407_02.bad_freqs = bad_freqs;

% Element mappings
X = [1:7, 35, 9:12, 14, 13, 15:19]; %[1:7,9:19]; %[1:7, 35, 9:12, 14, 13, 15:19];
Y = [21, 20, 23:34, 36:38]; % [20:38]; %[21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT19A_407_02.X = X;
AGBT19A_407_02.Y = Y;
AGBT19A_407_02.goodX = goodX;
AGBT19A_407_02.goodY = goodY;

AGBT19A_407_02.fudge = 0;
AGBT19A_407_02.Xdims = [-0.23, 0.23];
AGBT19A_407_02.Ydims = [-0.23, 0.23];
                
AGBT19A_407_02.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT19A_407_02.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;

%% AGBT19A_407_03
% % Scan numbers and time stamps
AGBT19A_407_03.session_name = 'AGBT19A_407_03';
log_filename = sprintf('%s/%s_03/ScanLog.fits', meta_root, proj_id_6);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT19A_407_03.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT19A_407_03.bad_freqs = bad_freqs;

% Element mappings
X = [1:7, 35, 9:12, 14, 13, 15:19]; %[1:7,9:19]; %[1:7, 35, 9:12, 14, 13, 15:19];
Y = [21, 20, 23:34, 36:38]; % [20:38]; %[21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT19A_407_03.X = X;
AGBT19A_407_03.Y = Y;
AGBT19A_407_03.goodX = goodX;
AGBT19A_407_03.goodY = goodY;

AGBT19A_407_03.fudge = 0;
AGBT19A_407_03.Xdims = [-0.23, 0.23];
AGBT19A_407_03.Ydims = [-0.23, 0.23];
                
AGBT19A_407_03.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT19A_407_03.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;

%% AGBT19A_407_03
% % Scan numbers and time stamps
AGBT19A_407_03.session_name = 'AGBT19A_407_03';
log_filename = sprintf('%s/%s_03/ScanLog.fits', meta_root, proj_id_6);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT19A_407_03.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT19A_407_03.bad_freqs = bad_freqs;

% Element mappings
X = [1:7, 35, 9:12, 14, 13, 15:19]; %[1:7,9:19]; %[1:7, 35, 9:12, 14, 13, 15:19];
Y = [21, 20, 23:34, 36:38]; % [20:38]; %[21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT19A_407_03.X = X;
AGBT19A_407_03.Y = Y;
AGBT19A_407_03.goodX = goodX;
AGBT19A_407_03.goodY = goodY;

AGBT19A_407_03.fudge = 0;
AGBT19A_407_03.Xdims = [-0.23, 0.23];
AGBT19A_407_03.Ydims = [-0.23, 0.23];
                
AGBT19A_407_03.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT19A_407_03.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;

%% AGBT19A_221_03
% % Scan numbers and time stamps
AGBT19A_221_03.session_name = 'AGBT19A_221_03';
log_filename = sprintf('%s/%s_03/ScanLog.fits', meta_root, proj_id_7);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT19A_221_03.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT19A_221_03.bad_freqs = bad_freqs;

% Element mappings
X = [1:7, 35, 9:12, 14, 13, 15:19]; %[1:7,9:19]; %[1:7, 35, 9:12, 14, 13, 15:19];
Y = [21, 20, 23:34, 36:38]; % [20:38]; %[21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT19A_221_03.X = X;
AGBT19A_221_03.Y = Y;
AGBT19A_221_03.goodX = goodX;
AGBT19A_221_03.goodY = goodY;

AGBT19A_221_03.fudge = 0;
AGBT19A_221_03.Xdims = [-0.23, 0.23];
AGBT19A_221_03.Ydims = [-0.23, 0.23];
                
AGBT19A_221_03.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT19A_221_03.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;


%% AGBT19A_116_01
% % Scan numbers and time stamps
AGBT19A_116_01.session_name = 'AGBT19A_116_01';
log_filename = sprintf('%s/%s_01/ScanLog.fits', meta_root, proj_id_11);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT19A_116_01.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT19A_116_01.bad_freqs = bad_freqs;

% Element mappings
X = [1:7, 35, 9:12, 14, 13, 15:19]; %[1:7,9:19]; %[1:7, 35, 9:12, 14, 13, 15:19];
Y = [21, 20, 23:34, 36:38]; % [20:38]; %[21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT19A_116_01.X = X;
AGBT19A_116_01.Y = Y;
AGBT19A_116_01.goodX = goodX;
AGBT19A_116_01.goodY = goodY;
AGBT19A_116_01.fudge = 0;
AGBT19A_116_01.Xdims = [-0.23, 0.23];
AGBT19A_116_01.Ydims = [-0.23, 0.23];
                
AGBT19A_116_01.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT19A_116_01.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;

%% AGBT18B_358_02
% % Scan numbers and time stamps
AGBT18B_358_02.session_name = 'AGBT18B_358_02';
log_filename = sprintf('%s/%s_02/ScanLog.fits', meta_root, proj_id_8);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT18B_358_02.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT18B_358_02.bad_freqs = bad_freqs;

% Element mappings
X = [1:7,20, 9:19];
Y = [21:39];
%X = [1:7, 35, 9:12, 14, 13, 15:19]; %[1:7,9:19]; %[1:7, 35, 9:12, 14, 13, 15:19];
%Y = [21, 20, 23:34, 36:38]; % [20:38]; %[21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT18B_358_02.X = X;
AGBT18B_358_02.Y = Y;
AGBT18B_358_02.goodX = goodX;
AGBT18B_358_02.goodY = goodY;

AGBT18B_358_02.fudge = 0;
AGBT18B_358_02.Xdims = [-0.23, 0.23];
AGBT18B_358_02.Ydims = [-0.23, 0.23];
                
AGBT18B_358_02.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT18B_358_02.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;

%% AGBT18B_358_03
% % Scan numbers and time stamps
AGBT18B_358_03.session_name = 'AGBT18B_358_03';
log_filename = sprintf('%s/%s_03/ScanLog.fits', meta_root, proj_id_8);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT18B_358_03.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT18B_358_03.bad_freqs = bad_freqs;

% Element mappings
%% Spring 2019
X = [1:7,20, 9:19];
Y = [21:39];
%X = [1:7, 35, 9:12, 14, 13, 15:19]; %[1:7,9:19]; %[1:7, 35, 9:12, 14, 13, 15:19];
%Y = [21, 20, 23:34, 36:38]; % [20:38]; %[21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT18B_358_03.X = X;
AGBT18B_358_03.Y = Y;
AGBT18B_358_03.goodX = goodX;
AGBT18B_358_03.goodY = goodY;

AGBT18B_358_03.fudge = 0;
AGBT18B_358_03.Xdims = [-0.23, 0.23];
AGBT18B_358_03.Ydims = [-0.23, 0.23];
                
AGBT18B_358_03.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT18B_358_03.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;

%% AGBT18B_358_06
% % Scan numbers and time stamps
AGBT18B_358_06.session_name = 'AGBT18B_358_06';
log_filename = sprintf('%s/%s_06/ScanLog.fits', meta_root, proj_id_8);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT18B_358_06.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT18B_358_06.bad_freqs = bad_freqs;

% Element mappings
%% Spring 2019
X = [1:7,20, 9:19];
Y = [21:39];
%X = [1:7, 35, 9:12, 14, 13, 15:19]; %[1:7,9:19]; %[1:7, 35, 9:12, 14, 13, 15:19];
%Y = [21, 20, 23:34, 36:38]; % [20:38]; %[21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT18B_358_06.X = X;
AGBT18B_358_06.Y = Y;
AGBT18B_358_06.goodX = goodX;
AGBT18B_358_06.goodY = goodY;

AGBT18B_358_06.fudge = 0;
AGBT18B_358_06.Xdims = [-0.23, 0.23];
AGBT18B_358_06.Ydims = [-0.23, 0.23];
                
AGBT18B_358_06.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT18B_358_06.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;

%% AGBT18B_358_07
% % Scan numbers and time stamps
AGBT18B_358_07.session_name = 'AGBT18B_358_07';
log_filename = sprintf('%s/%s_07/ScanLog.fits', meta_root, proj_id_8);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT18B_358_07.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT18B_358_07.bad_freqs = bad_freqs;

% Element mappings
%% Spring 2019
X = [1:7,20, 9:19];
Y = [21:39];
%X = [1:7, 35, 9:12, 14, 13, 15:19]; %[1:7,9:19]; %[1:7, 35, 9:12, 14, 13, 15:19];
%Y = [21, 20, 23:34, 36:38]; % [20:38]; %[21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT18B_358_07.X = X;
AGBT18B_358_07.Y = Y;
AGBT18B_358_07.goodX = goodX;
AGBT18B_358_07.goodY = goodY;

AGBT18B_358_07.fudge = 0;
AGBT18B_358_07.Xdims = [-0.23, 0.23];
AGBT18B_358_07.Ydims = [-0.23, 0.23];
                
AGBT18B_358_07.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT18B_358_07.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;

%% AGBT19A_091_02
% % Scan numbers and time stamps
AGBT19A_091_02.session_name = 'AGBT19A_091_02';
log_filename = sprintf('%s/%s_02/ScanLog.fits', meta_root, proj_id_9);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT19A_091_02.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT19A_091_02.bad_freqs = bad_freqs;

% Element mappings
%% Spring 2019
X = [1:7,20, 9:19];
Y = [21:39];
%X = [1:7, 35, 9:12, 14, 13, 15:19]; %[1:7,9:19]; %[1:7, 35, 9:12, 14, 13, 15:19];
%Y = [21, 20, 23:34, 36:38]; % [20:38]; %[21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT19A_091_02.X = X;
AGBT19A_091_02.Y = Y;
AGBT19A_091_02.goodX = goodX;
AGBT19A_091_02.goodY = goodY;

AGBT19A_091_02.fudge = 0;
AGBT19A_091_02.Xdims = [-0.23, 0.23];
AGBT19A_091_02.Ydims = [-0.23, 0.23];
                
AGBT19A_091_02.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT19A_091_02.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;

%% AGBT19A_091_03
% % Scan numbers and time stamps
AGBT19A_091_03.session_name = 'AGBT19A_091_03';
log_filename = sprintf('%s/%s_03/ScanLog.fits', meta_root, proj_id_9);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT19A_091_03.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT19A_091_03.bad_freqs = bad_freqs;

% Element mappings
%% Spring 2019
X = [1:7,20, 9:19];
Y = [21:39];
%X = [1:7, 35, 9:12, 14, 13, 15:19]; %[1:7,9:19]; %[1:7, 35, 9:12, 14, 13, 15:19];
%Y = [21, 20, 23:34, 36:38]; % [20:38]; %[21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT19A_091_03.X = X;
AGBT19A_091_03.Y = Y;
AGBT19A_091_03.goodX = goodX;
AGBT19A_091_03.goodY = goodY;

AGBT19A_091_03.fudge = 0;
AGBT19A_091_03.Xdims = [-0.23, 0.23];
AGBT19A_091_03.Ydims = [-0.23, 0.23];
                
AGBT19A_091_03.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT19A_091_03.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;

%% AGBT19A_091_04
% % Scan numbers and time stamps
AGBT19A_091_04.session_name = 'AGBT19A_091_04';
log_filename = sprintf('%s/%s_04/ScanLog.fits', meta_root, proj_id_9);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT19A_091_04.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT19A_091_04.bad_freqs = bad_freqs;

% Element mappings
%% Spring 2019
X = [1:7,20, 9:19];
Y = [21:39];
%X = [1:7, 35, 9:12, 14, 13, 15:19]; %[1:7,9:19]; %[1:7, 35, 9:12, 14, 13, 15:19];
%Y = [21, 20, 23:34, 36:38]; % [20:38]; %[21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT19A_091_04.X = X;
AGBT19A_091_04.Y = Y;
AGBT19A_091_04.goodX = goodX;
AGBT19A_091_04.goodY = goodY;

AGBT19A_091_04.fudge = 0;
AGBT19A_091_04.Xdims = [-0.23, 0.23];
AGBT19A_091_04.Ydims = [-0.23, 0.23];
                
AGBT19A_091_04.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT19A_091_04.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;

%% AGBT19A_091_05
% % Scan numbers and time stamps
AGBT19A_091_05.session_name = 'AGBT19A_091_05';
log_filename = sprintf('%s/%s_05/ScanLog.fits', meta_root, proj_id_9);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT19A_091_05.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT19A_091_05.bad_freqs = bad_freqs;

% Element mappings
%% Spring 2019
X = [1:7,20, 9:19];
Y = [21:39];
%X = [1:7, 35, 9:12, 14, 13, 15:19]; %[1:7,9:19]; %[1:7, 35, 9:12, 14, 13, 15:19];
%Y = [21, 20, 23:34, 36:38]; % [20:38]; %[21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT19A_091_05.X = X;
AGBT19A_091_05.Y = Y;
AGBT19A_091_05.goodX = goodX;
AGBT19A_091_05.goodY = goodY;

AGBT19A_091_05.fudge = 0;
AGBT19A_091_05.Xdims = [-0.23, 0.23];
AGBT19A_091_05.Ydims = [-0.23, 0.23];
                
AGBT19A_091_05.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT19A_091_05.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;

%% AGBT19A_091_06
% % Scan numbers and time stamps
AGBT19A_091_06.session_name = 'AGBT19A_091_06';
log_filename = sprintf('%s/%s_06/ScanLog.fits', meta_root, proj_id_9);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT19A_091_06.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT19A_091_06.bad_freqs = bad_freqs;

% Element mappings
%% Spring 2019
X = [1:7,20, 9:19];
Y = [21:39];
%X = [1:7, 35, 9:12, 14, 13, 15:19]; %[1:7,9:19]; %[1:7, 35, 9:12, 14, 13, 15:19];
%Y = [21, 20, 23:34, 36:38]; % [20:38]; %[21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT19A_091_06.X = X;
AGBT19A_091_06.Y = Y;
AGBT19A_091_06.goodX = goodX;
AGBT19A_091_06.goodY = goodY;

AGBT19A_091_06.fudge = 0;
AGBT19A_091_06.Xdims = [-0.23, 0.23];
AGBT19A_091_06.Ydims = [-0.23, 0.23];
                
AGBT19A_091_06.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT19A_091_06.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;

%% AGBT19A_365_01
% % Scan numbers and time stamps
AGBT19A_365_01.session_name = 'AGBT19A_365_01';
log_filename = sprintf('%s/%s_01/ScanLog.fits', meta_root, proj_id_10);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT19A_365_01.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT19A_365_01.bad_freqs = bad_freqs;

% Element mappings
%% Spring 2019
X = [1:7,20, 9:19];
Y = [21:39];
%X = [1:7, 35, 9:12, 14, 13, 15:19]; %[1:7,9:19]; %[1:7, 35, 9:12, 14, 13, 15:19];
%Y = [21, 20, 23:34, 36:38]; % [20:38]; %[21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT18B_365_01.X = X;
AGBT19A_365_01.Y = Y;
AGBT19A_365_01.goodX = goodX;
AGBT19A_365_01.goodY = goodY;

AGBT19A_365_01.fudge = 0;
AGBT19A_365_01.Xdims = [-0.23, 0.23];
AGBT19A_365_01.Ydims = [-0.23, 0.23];
                
AGBT19A_365_01.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT19A_365_01.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;

%% AGBT19A_365_02
% % Scan numbers and time stamps
AGBT19A_365_02.session_name = 'AGBT19A_365_02';
log_filename = sprintf('%s/%s_02/ScanLog.fits', meta_root, proj_id_10);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT19A_365_02.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT19A_365_02.bad_freqs = bad_freqs;

% Element mappings
%% Spring 2019
X = [1:7,20, 9:19];
Y = [21:39];
%X = [1:7, 35, 9:12, 14, 13, 15:19]; %[1:7,9:19]; %[1:7, 35, 9:12, 14, 13, 15:19];
%Y = [21, 20, 23:34, 36:38]; % [20:38]; %[21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT19B_365_02.X = X;
AGBT19A_365_02.Y = Y;
AGBT19A_365_02.goodX = goodX;
AGBT19A_365_02.goodY = goodY;

AGBT19A_365_02.fudge = 0;
AGBT19A_365_02.Xdims = [-0.23, 0.23];
AGBT19A_365_02.Ydims = [-0.23, 0.23];
                
AGBT19A_365_02.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT19A_365_02.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;

%% AGBT19A_365_03
% % Scan numbers and time stamps
AGBT19A_365_03.session_name = 'AGBT19A_365_03';
log_filename = sprintf('%s/%s_03/ScanLog.fits', meta_root, proj_id_10);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT19A_365_03.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT19A_365_03.bad_freqs = bad_freqs;

% Element mappings
%% Spring 2019
X = [1:7,20, 9:19];
Y = [21:39];
%X = [1:7, 35, 9:12, 14, 13, 15:19]; %[1:7,9:19]; %[1:7, 35, 9:12, 14, 13, 15:19];
%Y = [21, 20, 23:34, 36:38]; % [20:38]; %[21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT19B_365_03.X = X;
AGBT19A_365_03.Y = Y;
AGBT19A_365_03.goodX = goodX;
AGBT19A_365_03.goodY = goodY;

AGBT19A_365_03.fudge = 0;
AGBT19A_365_03.Xdims = [-0.23, 0.23];
AGBT19A_365_03.Ydims = [-0.23, 0.23];
                
AGBT19A_365_03.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT19A_365_03.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;

%% AGBT19A_365_06
% % Scan numbers and time stamps
AGBT19A_365_06.session_name = 'AGBT19A_365_06';
log_filename = sprintf('%s/%s_06/ScanLog.fits', meta_root, proj_id_10);
scan_data = fitsread(log_filename, 'bintable', 1);
time_stamps = unique(scan_data{1});

for i = 1:length(time_stamps)
    my_stamp = time_stamps{i};
    my_stamp = strrep(my_stamp, '-', '_');
    my_stamp = strrep(my_stamp, 'T', '_');
    AGBT19A_365_06.scans{i} = my_stamp;
end

% Frequency mask
bad_freqs = [];
AGBT19A_365_06.bad_freqs = bad_freqs;

% Element mappings
%% Spring 2019
X = [1:7,20, 9:19];
Y = [21:39];
%X = [1:7, 35, 9:12, 14, 13, 15:19]; %[1:7,9:19]; %[1:7, 35, 9:12, 14, 13, 15:19];
%Y = [21, 20, 23:34, 36:38]; % [20:38]; %[21, 20, 23:34, 36:38]; % [21, 20, 23:34, 8, 36:39];
goodX = X; % goodX(X < 9) = [];
goodY = Y;
% goodY(Y==33) = [];

AGBT19B_365_06.X = X;
AGBT19A_365_06.Y = Y;
AGBT19A_365_06.goodX = goodX;
AGBT19A_365_06.goodY = goodY;

AGBT19A_365_06.fudge = 0;
AGBT19A_365_06.Xdims = [-0.23, 0.23];
AGBT19A_365_06.Ydims = [-0.23, 0.23];
                
AGBT19A_365_06.beam_el = [ 3.94, 3.94,  0.0, 0.0, 0.0, -3.94, -3.94]*1/60;
AGBT19A_365_06.beam_az = [-2.275, 2.275, -4.55, 0.0, 4.55, -2.275,  2.275]*1/60;
