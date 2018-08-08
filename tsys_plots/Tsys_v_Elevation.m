% Tsys/eta vs Elevation - Shows the relationship between Tsys/eta and
% elevation.

addpath ../kernel/
scan_table; % Found in kernel directory
source_table; % Found in kernel directory

sessions = {'AGBT16B_400_01','AGBT16B_400_02','AGBT16B_400_03','AGBT16B_400_04', ...
    'AGBT16B_400_12','AGBT16B_400_13','AGBT16B_400_14','AGBT17B_360_01', ...
    'AGBT17B_360_02','AGBT17B_360_03','AGBT17B_360_04','AGBT17B_360_05', ...
    'AGBT17B_360_06','AGBT17B_360_07','AGBT17B_455_01','AGBT18A_443_01'}; 

sess = length(sessions);

for i = 1:sess
    if i == 1 % sessions{i} ==  'AGBT16B_400_01'
        session = AGBT16B_400_01;
        proj_str = session.session_name;
        midscan =[34, 35, 37, 38, 40, 41, 43, 44, 46, 47, 49,50, 65:70, 72, 74:78, 80:85];
        on_scans = midscan(floor(length(midscan)/2));
        source = source3C295;
        ant_dir = sprintf('%s/%s/Antenna', meta_root1, proj_str);
    elseif i == 2 % sessions{i} ==  'AGBT16B_400_02'
        session = AGBT16B_400_02;
        proj_str = session.session_name;
        midscan = [13:15, 17:19, 21:23, 25:27, 29:31,...
            33:35, 37:39, 41:43, 45:47, 49:51, 53:55];
        on_scans = midscan(floor(length(midscan)/2));
        source = source3C295;
        ant_dir = sprintf('%s/%s/Antenna', meta_root1, proj_str);
    elseif i == 3 % sessions{i} ==  'AGBT16B_400_03'
        session = AGBT16B_400_03;
        proj_str = session.session_name;
        midscan = [12:14, 16:18, 20:22, 24:26, 28:30, 32:34, 36:38, 40:42, 44:46, 48:50, 52:54];
        on_scans = midscan(floor(length(midscan)/2));
        source = source3C295;
        ant_dir = sprintf('%s/%s/Antenna', meta_root1, proj_str);
    elseif i == 4 % sessions{i} ==  'AGBT16B_400_04'
        session = AGBT16B_400_04;
        proj_str = session.session_name;
        midscan = [13:19];
        on_scans = midscan(floor(length(midscan)/2));
        source = source3C295;
        ant_dir = sprintf('%s/%s/Antenna', meta_root1, proj_str);
    elseif i == 5 % sessions{i} ==  'AGBT16B_400_12'
        session = AGBT16B_400_12;
        proj_str = session.session_name;
        midscan = [32:36, 38:42, 44:48, 50:54, 56:60, 66:70, 72:85];
        on_scans = midscan(floor(length(midscan)/2));
        source = source3C295;
        ant_dir = sprintf('%s/%s/Antenna', meta_root1, proj_str);
    elseif i == 6 % sessions{i} ==  'AGBT16B_400_13'
        session = AGBT16B_400_13;
        proj_str = session.session_name;
        midscan = [19:23, 25:29, 31:35, 38:42, 44:48, 50:54, 56:59];
        on_scans = midscan(floor(length(midscan)/2));
        source = source3C123;
        ant_dir = sprintf('%s/%s/Antenna', meta_root1, proj_str);
    elseif i == 7 % sessions{i} ==  'AGBT16B_400_14'
        session = AGBT16B_400_14;
        proj_str = session.session_name;
        midscan = [25:29, 31:35, 44:48, 50:54, 56:60, 62:66, 68:71];
        on_scans = midscan(floor(length(midscan)/2));
        source = source3C147;
        ant_dir = sprintf('%s/%s/Antenna', meta_root1, proj_str);
    elseif i == 8 % sessions{i} ==  'AGBT17B_360_01'
        session = AGBT17B_360_01;
        proj_str = session.session_name;
        midscan = [19:23,25:29,31:35,37:41,43:47,49:53,55:58];
        on_scans = midscan(floor(length(midscan)/2));
        source = source3C295;
        ant_dir = sprintf('%s/%s/Antenna', meta_root, proj_str);
    elseif i == 9 % sessions{i} ==  'AGBT17B_360_02'
        session = AGBT17B_360_02;
        proj_str = session.session_name;
        midscan = [24:28,30:34,36:40,42:46,48:52,54:58,60:63];
        on_scans = midscan(floor(length(midscan)/2));
        source = source3C147;
        ant_dir = sprintf('%s/%s/Antenna', meta_root, proj_str);
    elseif i == 10 % sessions{i} ==  'AGBT17B_360_03'
        session = AGBT17B_360_03;
        proj_str = session.session_name;
        midscan = [14:18,20:24,26:30,32:36,38:42,44:45,47:48,50:53];
        on_scans = midscan(floor(length(midscan)/2));
        source = source3C295;
        ant_dir = sprintf('%s/%s/Antenna', meta_root, proj_str);
    elseif i == 11 % sessions{i} ==  'AGBT17B_360_04'
        session = AGBT17B_360_04;
        proj_str = session.session_name;
        midscan = [31:35,37:41,43:47,49:53,55:59,61:65,67:69];
        on_scans = midscan(floor(length(midscan)/2));
        source = source3C295;
        ant_dir = sprintf('%s/%s/Antenna', meta_root, proj_str);
    elseif i == 12 % sessions{i} ==  'AGBT17B_360_05'
        session = AGBT17B_360_05;
        proj_str = session.session_name;
        midscan = [3:9];
        on_scans = midscan(floor(length(midscan)/2));
        source = source3C295;
        ant_dir = sprintf('%s/%s/Antenna', meta_root, proj_str);
    elseif i == 13 % sessions{i} ==  'AGBT17B_360_06'
        session = AGBT17B_360_06;
        proj_str = session.session_name;
        midscan = [71:75,77:81,83:87,89:93,95:99,101:105,107:110];
        on_scans = midscan(floor(length(midscan)/2));
        source = source3C48;
        ant_dir = sprintf('%s/%s/Antenna', meta_root, proj_str);
    elseif i == 14 % sessions{i} ==  'AGBT17B_360_07'
        session = AGBT17B_360_07;
        proj_str = session.session_name;
        midscan = [5:9,11:15,17:21,23:27,29:33,35:39,41:44];
        on_scans = midscan(floor(length(midscan)/2));
        source = source3C295;
        ant_dir = sprintf('%s/%s/Antenna', meta_root, proj_str);
    elseif i == 15 % sessions{i} ==  'AGBT17B_455_01'
        session = AGBT17B_455_01;
        proj_str = session.session_name;
        midscan = [7:13];
        on_scans = midscan(floor(length(midscan)/2));
        source = source3C348;
        ant_dir = sprintf('%s/%s/Antenna', meta_root, proj_str);
    elseif i == 16 % sessions{i} ==  'AGBT18A_443_01'
        session = AGBT18A_443_01;
        proj_str = session.session_name;
        midscan = [6:12];
        on_scans = midscan(floor(length(midscan)/2));
        source = source3C295;
        ant_dir = sprintf('%s/%s/Antenna', meta_root, proj_str);
    end
    
    tmp_stamp = session.scans(on_scans);
    tstamp = tmp_stamp{1};
    fits_file = sprintf('%s/%s.fits', ant_dir, tstamp);
    
    info = fitsinfo(fits_file);
    p_header = info.PrimaryData.Keywords;
    % Observed (obsc) el at scan midpoint
    sobsc_el_idx = find(ismember(p_header(:,1), 'SOBSC_EL'));
    sobsc_el(i) = p_header{sobsc_el_idx,2}; % SOBSC_EL{index,value}
    
end

% 2 400_02 - 3c295
% 3 400_03 - 3c295
% 4 400_04 - 3c295
% 5 400_12 - 3c295
% 6 400_13 - 3c123
% 7 400_14 - 3c147
% 8 360_01 - 3c295
% 9 360_02 - 3c147
% 10 360_03 - 3c295
% 11 360_04 - 3c295
% 12 360_05 - 3c295
% 13 360_06 - 3c48
% 14 360_07 - 3c295
% 15 455_01 - 3c348
% 16 443_01 - 3c295

% Tsys_eta = [28.64,32.55,32.51,37,35,33, ... % 2,3,4,12,13,14
%     28, 36, 40, 25, 23, 23, 25, 27, 27.77]; % 1,2,3,4,5,6,7,455_1,443_1

% Tsys_eta_3c295 = [28.64,32.55,32.51,37, ... % 2,3,4,12
%     28, 40, 25, 23, 25, 27.77]; % 1,3,4,5,7,443_1
Tsys_eta_3c295 = [28.9,32.58,32.68,36.62, ... % 2,3,4,12
    30.33, 42.82, 24.98, 24, 26.51, 29.33]; % 1,3,4,5,7,443_1

Tsys_eta_anish = [33, 30.5, 27, 30, 26, 25.5, 25]; % Source is 3C295
ele_anish = [20, 32, 40, 60, 67, 73, 79.5];

load('TsysVele.mat');

figure(1);
% plot(cosd(90-sobsc_el([2:5, 8, 10:12, 14, 16])), Tsys_eta_3c295 , 'r*');
% plot(sobsc_el([2:5, 8, 10:12, 14, 16]), Tsys_eta_3c295, 'r*');
plot(sobsc_el([2:5, 8, 11:12, 14, 16]), Tsys_eta_3c295([1:5,7:end]), 'r*');
hold on;
plot(ele_anish, Tsys_eta_anish, 'bo');
plot(ele_deg, Tsys_etaX)
hold off;
grid on;
title('3C295 X-polarization T_s_y_s/\eta (K)');
xlim([0,95]);
xlabel('Elevation');
ylabel('T_s_y_s/\eta (K)');
legend('FLAG data', 'Anish data', 'GBT model');

Tsys_eta_3c123 = 35; % 13
Tsys_eta_3c147 = [33, 36]; % 14, 2
Tsys_eta_3c48 = 23; % 6
Tsys_eta_3c348 = 27; % 455_1

figure(2);
% plot(cosd(90-sobsc_el(6)), Tsys_eta_3c123 , 'r*');
plot(sobsc_el(6), Tsys_eta_3c123 , 'r*');
grid on;
title('3C147 X-polarization T_s_y_s/\eta (K)');
xlabel('Elevation');
ylabel('T_s_y_s/\eta (K)');

figure(2);
% plot(cosd(90-sobsc_el([7, 9])), Tsys_eta_3c147 , 'r*');
plot(sobsc_el([7, 9]), Tsys_eta_3c147 , 'r*');
grid on;
title('3C147 X-polarization T_s_y_s/\eta (K)');
xlabel('Elevation');
ylabel('T_s_y_s/\eta (K)');

figure(3);
% plot(cosd(90-sobsc_el(13)), Tsys_eta_3c48 , 'r*');
plot(sobsc_el(13), Tsys_eta_3c48 , 'r*');
grid on;
title('3C48 X-polarization T_s_y_s/\eta (K)');
xlabel('Elevation');
ylabel('T_s_y_s/\eta (K)');

figure(4);
% plot(cosd(90-sobsc_el(15)), Tsys_eta_3c348 , 'r*');
plot(sobsc_el(15), Tsys_eta_3c348 , 'r*');
grid on;
title('3C48 X-polarization T_s_y_s/\eta (K)');
xlabel('Elevation');
ylabel('T_s_y_s/\eta (K)');


figure(5);
% plot(cosd(90-sobsc_el([2:5, 8, 10:12, 14, 16])), Tsys_eta_3c295 , 'r*');
plot(sobsc_el([2:5, 8, 10:12, 14, 16]), Tsys_eta_3c295 , 'r*');
hold on;
% plot(cosd(90-sobsc_el(6)), Tsys_eta_3c123 , 'm*');
plot(sobsc_el(6), Tsys_eta_3c123 , 'm*');
% plot(cosd(90-sobsc_el([7, 9])), Tsys_eta_3c147 , 'b*');
plot(sobsc_el([7, 9]), Tsys_eta_3c147 , 'b*');
% plot(cosd(90-sobsc_el(13)), Tsys_eta_3c48 , 'g*');
plot(sobsc_el(13), Tsys_eta_3c48 , 'g*');
% plot(cosd(90-sobsc_el(15)), Tsys_eta_3c348 , 'k*');
plot(sobsc_el(15), Tsys_eta_3c348 , 'k*');
hold off;
grid on;
title('X-polarization T_s_y_s/\eta (K)');
xlabel('Elevation');
ylabel('T_s_y_s/\eta (K)');
legend('3C295','3C123','3C147','3C48','3C348');

