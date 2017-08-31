% Global parameters
data_root = '/lustre/projects/flag';
meta_root = '/home/gbtdata';
proj_id = 'AGBT16B_400';
obs_long = 38.419531;
obs_lat  = -79.831808;
G = 6.6; % Approximate for constant of the year used to calculate GST

%% AGBT16B_400_01
% Scan numbers and time stamps
AGBT16B_400_01.session_name = 'AGBT16B_400_01';
log_filename = sprintf('%s/%s_01/ScanLog.fits', meta_root, proj_id);
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
log_filename = sprintf('%s/%s_02/ScanLog.fits', meta_root, proj_id);
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
log_filename = sprintf('%s/%s_03/ScanLog.fits', meta_root, proj_id);
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
log_filename = sprintf('%s/%s_04/ScanLog.fits', meta_root, proj_id);
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
log_filename = sprintf('%s/%s_05/ScanLog.fits', meta_root, proj_id);
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
log_filename = sprintf('%s/%s_07/ScanLog.fits', meta_root, proj_id);
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
log_filename = sprintf('%s/%s_09/ScanLog.fits', meta_root, proj_id);
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
log_filename = sprintf('%s/%s_11/ScanLog.fits', meta_root, proj_id);
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
log_filename = sprintf('%s/%s_12/ScanLog.fits', meta_root, proj_id);
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
log_filename = sprintf('%s/%s_13/ScanLog.fits', meta_root, proj_id);
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
log_filename = sprintf('%s/%s_14/ScanLog.fits', meta_root, proj_id);
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