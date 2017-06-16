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
X = [1:19];
Y = [21, 20, 23:39];
goodX = X;
goodY = Y; goodY(Y==34) = [];

AGBT16B_400_03.X = X;
AGBT16B_400_03.Y = Y;
AGBT16B_400_03.goodX = goodX;
AGBT16B_400_03.goodY = goodY;

AGBT16B_400_03.fudge = -45/62;
AGBT16B_400_03.Xdims = [-0.25, 0.25];
AGBT16B_400_03.Ydims = [-0.15, 0.225];

AGBT16B_400_03.on_scans = [11:14, 16:18, 20:22, 24:26, 28:30, 32:34, ...
                           36:38, 40:42, 44:46, 48:50, 52:54];
AGBT16B_400_03.off_scans = [15, 19, 23, 27, 31, 35, 39, 43, 47, 51];

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
