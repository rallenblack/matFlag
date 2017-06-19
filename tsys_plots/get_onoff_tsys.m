% On/Off Tsys
close all;
clearvars;

addpath ../kernel/
scan_table; % Found in kernel directory
source_table; % Found in kernel directory

tic;

pol = 'X';

% AGBT16B_400_01 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
session = AGBT16B_400_01;
on_scan = 9;  off_scan = 10;
source = source3C295;
LO_freq = 1450;

% AGBT16B_400_02 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% session = AGBT16B_400_02;
% on_scan = 11;  off_scan = 12;
% source = source3C295;
% LO_freq = 1450;

% AGBT16B_400_03 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% session = AGBT16B_400_03;
% on_scan = 7;  off_scan = 8;
% source = source3C295;
% LO_freq = 1450;

% AGBT16B_400_04 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% session = AGBT16B_400_04;
% on_scan = 10;  off_scan = 11;
% source = source3C295;
% LO_freq = 1450;

% AGBT16B_400_05 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% session = AGBT16B_400_05;
% on_scan = 2;  off_scan = 3;
% source = source3C48;
% LO_freq = 1350;

% session = AGBT16B_400_05;
% on_scan = 4;  off_scan = 5;
% source = source3C147;
% LO_freq = 1350;

% session = AGBT16B_400_05;
% on_scan = 6;  off_scan = 7;
% source = source3C147;
% LO_freq = 1075;

% session = AGBT16B_400_05;
% on_scan = 8;  off_scan = 9;
% source = source3C147;
% LO_freq = 1200;

% session = AGBT16B_400_05;
% on_scan = 10;  off_scan = 11;
% source = source3C147;
% LO_freq = 1325;

% session = AGBT16B_400_05;
% on_scan = 12;  off_scan = 13;
% source = source3C147;
% LO_freq = 1450;

% session = AGBT16B_400_05;
% on_scan = 14;  off_scan = 15;
% source = source3C147;
% LO_freq = 1575;

% session = AGBT16B_400_05;
% on_scan = 16;  off_scan = 17;
% source = source3C147;
% LO_freq = 1700;

% session = AGBT16B_400_05;
% on_scan = 19;  off_scan = 20;
% source = source3C147;
% LO_freq = 1450;

on_tstamp = session.scans(on_scan);
on_tstamp = on_tstamp{1};
off_tstamp = session.scans(off_scan);
off_tstamp = off_tstamp{1};
if pol == 'X'
    good_idx = session.goodX;
else
    good_idx = session.goodY;
end
bad_freqs = session.bad_freqs;

proj_str = session.session_name;
save_dir = sprintf('%s/%s/BF', data_root, proj_str);
out_dir = sprintf('%s/mat', save_dir);
mkdir(save_dir, out_dir);

% Constants
overwrite = 1;
kB = 1.38*1e-23;

rad = 50;
Ap = (rad^2)*pi;

freqs = ((-249:250)*303.75e-3) + LO_freq;
a = source.a;
b = source.b;
c = source.c;
d = source.d;
e = source.e;
f = source.f;
x = a + b*log10(freqs./1e3) + c*log10(freqs./1e3).^2 + d*log10(freqs./1e3).^3 + e*log10(freqs./1e3).^4 + f*log10(freqs./1e3).^5;
flux_density = 10.^x;

ant_dir = sprintf('%s/%s/Antenna', meta_root, proj_str);

% Iterate over off pointings just to have them ready
% Iterate over on pointings and look for closest off pointing

% Iterate over off pointings
fprintf('Processing off pointing...\n');
tmp_stmp = off_tstamp;
fprintf('    Time stamp: %s\n', tmp_stmp);

% Generate filename
filename = sprintf('%s/%s.mat', out_dir, tmp_stmp);

% Extract data and save
if ~exist(filename, 'file') || overwrite == 1
    [R, az_tmp, el_tmp, ~] = aggregate_banks(save_dir, ant_dir, tmp_stmp, -1);

    % Off pointings are dwell scans; need single R, az, and el
    az = mean(az_tmp);
    el = mean(el_tmp);
    save(filename, 'R', 'az', 'el');
end
OFF = load(filename);

% Create entry in position table
AZoff = OFF.az;
ELoff = OFF.el;

% Iterate over on pointings
fprintf('Processing on pointing...\n');

tmp_stmp = on_tstamp;
fprintf('    Time stamp: %s\n', tmp_stmp);

% Generate filename
filename = sprintf('%s/%s.mat', out_dir, tmp_stmp);

% Extract data and save
if ~exist(filename, 'file') || overwrite == 1
    [R, az, el, info] = aggregate_banks(save_dir, ant_dir, tmp_stmp, -1);
    save(filename, 'R', 'az', 'el');
else
    load(filename);
end

% Compute max-SNR weights and compute sensitivity
Sens = zeros(size(R,3), 1);

% Get steering vectors
fprintf('     Obtaining steering vectors...\n');
a = get_steering_vectors(R, OFF.R, good_idx, bad_freqs, save_dir, tmp_stmp, pol, 1);

fprintf('     Calculating weights and sensitivity...\n');
w = zeros(size(a));
for b = 1:size(R,3)
    if sum(bad_freqs == b) == 0
        w(:,b) = OFF.R(good_idx, good_idx, b)\a(:,b);
        w(:,b) = w(:,b)./(w(:,b)'*a(:,b));
        Pon = w(:,b)'*R(good_idx, good_idx, b)*w(:,b);
        Poff = w(:,b)'*OFF.R(good_idx, good_idx, b)*w(:,b);
        SNR = (Pon - Poff)/Poff;
        Sens(b) = 2*kB*SNR./(flux_density(b)*1e-26);
    else
        Sens(b) = 0;
        w(:,b) = zeros(size(a,1),1);
    end
end


% Plot map

% Get the angle of arrival for max sensitivity beam
Tsys_eta = Ap./Sens;

% Save the Tsys spectrum data
save('Tsys_eta', 'freqs');

tsys_fig = figure();
plot(freqs,real(Tsys_eta).');
title('T_s_y_s/\eta_a_p vs Frequency');
xlabel('Frequency (MHz)');
ylabel('T_s_y_s/\eta_a_p (K)');
grid on;

% Save figure
tsys_filename = sprintf('%s_scans%d_%d_%spol_tsys', session.session_name, on_scan, off_scan, pol);
saveas(tsys_fig, sprintf('%s.png', tsys_filename));
saveas(tsys_fig, sprintf('%s.pdf', tsys_filename));
saveas(tsys_fig, sprintf('%s.eps', tsys_filename));
saveas(tsys_fig, sprintf('%s.fig', tsys_filename), 'fig');

% Save the Tsys spectrum data
save(sprintf('%s.mat', tsys_filename), 'Tsys_eta', 'freqs');

% Save the weights
w_padded = zeros(size(w, 1), 7, size(w,3));
w_padded(:,1,:) = w;
w_padded(:,2,:) = w;
w_padded(:,3,:) = w;
w_padded(:,4,:) = w;
w_padded(:,5,:) = w;
w_padded(:,6,:) = w;
w_padded(:,7,:) = w;

az = zeros(7,1);
el = zeros(7,1);

create_weight_file(az, el, w_padded, w_padded,...
    sprintf('%s_scans%d_%d', session.session_name, on_scan, off_scan),...
    good_idx, good_idx,...
    sprintf('%s/w_%s_scans%d_%d.bfw', save_dir, session.session_name, on_scan, off_scan));

disp(min(real(Tsys_eta)));

toc;

