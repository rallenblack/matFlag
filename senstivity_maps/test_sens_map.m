% Aggregate weights and plot sensitvity map
close all;
clearvars;

addpath ../kernel/
scan_table; % Found in kernel directory
source_table; % Found in kernel directory

tic;

pol = 'X';

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
session = AGBT16B_400_09;
% % ON/OFF
% on_scans = 5;
% off_scans = 12;
% Calibrator
on_scans = [7:11, 13:17, 19:23, 25:29, 34:38, 40:44, 46:47]; % 5; % 16& 17 bad blocks(B,C,D), 29 & 31 Bank L did not start
off_scans = [12, 18, 24, 30, 39, 45]; % 12; % 30 Bank L stalled
source = source3C48;
Nint = 2;

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

on_tstamp = session.scans(on_scans);
off_tstamp = session.scans(off_scans);
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
k = 0;
kB = 1.38*1e-23;

rad = 50;
Ap = (rad^2)*pi;

LO_freq = 1450;
freq = ((-249:250)*303.75e-3) + LO_freq;
a = source.a;
b = source.b;
c = source.c;
d = source.d;
e = source.e;
f = source.f;
x = a + b*log10(freq./1e3) + c*log10(freq./1e3).^2 + d*log10(freq./1e3).^3 + e*log10(freq./1e3).^4 + f*log10(freq./1e3).^5;
flux_density = 10.^x;

ant_dir = sprintf('%s/%s/Antenna', meta_root, proj_str);

% Iterate over off pointings just to have them ready
% Iterate over on pointings and look for closest off pointing

% Iterate over off pointings
AZoff = zeros(length(off_tstamp), 1);
ELoff = zeros(length(off_tstamp), 1);

Sens = [];
AZ = [];
EL = [];
cal = [];
on_off = 1;
row = 5;
off_count = 0;
figure(1);
for i = 1:length(on_tstamp)
    tmp_stmp = on_tstamp{i};
    if mod(i,row) == 0
        off_count = off_count + 1;
%         for ii = 0:0
            off_tmp = off_tstamp{off_count};
            fprintf('    Time stamp: %s - %d/%d\n', off_tmp, off_count, length(off_tstamp));
                
            % Generate filename
            filename = sprintf('%s/%s.mat', out_dir, off_tmp);
            
            if exist(filename, 'file') == 2     
                % Extract data and save
                if ~exist(filename, 'file') || overwrite == 1
                    [R, az_tmp, el_tmp, ~] = aggregate_banks_test(save_dir, ant_dir, off_tmp, tmp_stmp, -1);
                    
                    % Off pointings are dwell scans; need single R, az, and el
                    az_off = mean(az_tmp);
                    el_off = mean(el_tmp);
                    save(filename, 'R', 'az_off', 'el_off');
                else
                    load(filename);
                end
                
                % Create entry in position table
                AZoff(off_count) = az_off;
                ELoff(off_count) = el_off;
                
                plot(AZoff(off_count), ELoff(off_count), 'bx');
                
                for k = ((i-row)+1):i
                    on_tmp = on_tstamp{k};
                    fprintf('    Time stamp: %s - %d/%d\n', on_tmp, k, length(on_tstamp));
                    
                    % Generate filename
                    filename = sprintf('%s/%s.mat', out_dir, on_tmp);
                    
                    % Extract data and save
                    if ~exist(filename, 'file') || overwrite == 1
                        [R, az, el, info] = aggregate_banks(save_dir, ant_dir, on_tmp, on_off, Nint);
                        save(filename, 'R', 'az', 'el');
                    else
                        load(filename);
                    end
                    
                    hold on;
                    plot(az, el, '-b'); % 'rx'
%                     hold off;
                    drawnow;
                    
                    OFF = load(sprintf('%s/%s', out_dir, off_tmp));
                    % Compute mamean(dmjd); % x-SNR weights and compute sensitivity
                    Senstmp = zeros(size(R,4),size(R,3));
                    
                    % Get steering vectors
                    fprintf('     Obtaining steering vectors...\n');
                    a = get_steering_vectors(R, OFF.R, good_idx, bad_freqs, save_dir, on_tmp, pol, 0);
                    
                    if k == 1
                        a_agg = a;
                    else
                        % Append to aggregated steering vector matrix
                        a_agg = cat(2, a_agg, a);
                    end
                    
                    fprintf('     Calculating weights and sensitivity...\n');
                    w = zeros(size(a));
                    for t = 1:size(R,4)
                        for b = 1:size(R,3)
                            if sum(bad_freqs == b) == 0
                                w(:,t,b) = OFF.R(good_idx, good_idx, b)\a(:,t,b);
                                w(:,t,b) = w(:,t,b)./(w(:,t,b)'*a(:,t,b));
                                Pon = w(:,t,b)'*R(good_idx, good_idx, b, t)*w(:,t,b);
                                Poff = w(:,t,b)'*OFF.R(good_idx, good_idx, b)*w(:,t,b);
                                SNR(t,b) = (Pon - Poff)/Poff;
                                Senstmp(t,b) = 2*kB*SNR(t,b)./(flux_density(b)*1e-26);
                            else
                                Senstmp(t,b) = 0;
                                w(:,t,b) = zeros(size(a,1),1);
                            end
                        end
                        AZ = [AZ; az(t)];
                        EL = [EL; el(t)];
                    end
                    Sens = [Sens; Senstmp];
                    
                    if k == 1
                        w_agg = w;
                    else
                        % Append to aggregated weight vector matrix
                        w_agg = cat(2, w_agg, w);
                    end
                end
            end
%         end
%         break;
    elseif i == length(on_tstamp) && mod(i,row) ~= 0
        off_count = off_count+1;
        for jj = 1:2
            off_tmp = off_tstamp{off_count - jj};
            fprintf('    Time stamp: %s - %d/%d\n', off_tmp, off_count, length(off_tstamp));
            
            % Generate filename
            filename = sprintf('%s/%s.mat', out_dir, off_tmp);
            if exist(filename, 'file') == 2
                
                % Extract data and save
                if ~exist(filename, 'file') || overwrite == 1
                    [R, az_tmp, el_tmp, ~] = aggregate_banks_test(save_dir, ant_dir, off_tmp, tmp_stmp, -1);
                    
                    % Off pointings are dwell scans; need single R, az, and el
                    az_off = mean(az_tmp);
                    el_off = mean(el_tmp);
                    save(filename, 'R', 'az_off', 'el_off');
                else
                    load(filename);
                end
                
                % Create entry in position table
                AZoff(off_count) = az_off;
                ELoff(off_count) = el_off;
                
                for k = ((i-(length(on_tstamp)-mod(i,row)))+1):i
                    on_tmp = on_tstamp{k};
                    fprintf('    Time stamp: %s - %d/%d\n', on_tmp, k, length(on_tstamp));
                    
                    % Generate filename
                    filename = sprintf('%s/%s.mat', out_dir, on_tmp);
                    
                    % Extract data and save
                    if ~exist(filename, 'file') || overwrite == 1
                        [R, az, el, info] = aggregate_banks(save_dir, ant_dir, on_tmp, on_off, Nint);
                        save(filename, 'R', 'az', 'el');
                    else
                        load(filename);
                    end
                    
                    hold on;
                    plot(az, el, '-b'); % 'rx'
%                     hold off;
                    drawnow;
                    
                    OFF = load(sprintf('%s/%s', out_dir, off_tmp));
                    % Compute mamean(dmjd); % x-SNR weights and compute sensitivity
                    Senstmp = zeros(size(R,4),size(R,3));
                    
                    % Get steering vectors
                    fprintf('     Obtaining steering vectors...\n');
                    a = get_steering_vectors(R, OFF.R, good_idx, bad_freqs, save_dir, on_tmp, pol, 0);
                    
                    if k == 1
                        a_agg = a;
                    else
                        % Append to aggregated steering vector matrix
                        a_agg = cat(2, a_agg, a);
                    end
                    
                    fprintf('     Calculating weights and sensitivity...\n');
                    w = zeros(size(a));
                    for t = 1:size(R,4)
                        for b = 1:size(R,3)
                            if sum(bad_freqs == b) == 0
                                w(:,t,b) = OFF.R(good_idx, good_idx, b)\a(:,t,b);
                                w(:,t,b) = w(:,t,b)./(w(:,t,b)'*a(:,t,b));
                                Pon = w(:,t,b)'*R(good_idx, good_idx, b, t)*w(:,t,b);
                                Poff = w(:,t,b)'*OFF.R(good_idx, good_idx, b)*w(:,t,b);
                                SNR(t,b) = (Pon - Poff)/Poff;
                                Senstmp(t,b) = 2*kB*SNR(t,b)./(flux_density(b)*1e-26);
                            else
                                Senstmp(t,b) = 0;
                                w(:,t,b) = zeros(size(a,1),1);
                            end
                        end
                        AZ = [AZ; az(t)];
                        EL = [EL; el(t)];
                    end
                    Sens = [Sens; Senstmp];
                    
                    if k == 1
                        w_agg = w;
                    else
                        % Append to aggregated weight vector matrix
                        w_agg = cat(2, w_agg, w);
                    end
                end
            end
        end
%         break;
    end
end

a_filename = sprintf('%s/%s_aggregated_grid_%s.mat', out_dir, session.session_name, pol);
fprintf('Saving aggregated steering vectors to %s\n', a_filename);
save(a_filename, 'AZ', 'EL', 'a_agg');

w_filename = sprintf('%s/%s_aggregated_weights_%s.mat', out_dir, session.session_name, pol);
fprintf('Saving aggregated weight vectors to %s\n', w_filename);
save(w_filename, 'AZ', 'EL', 'w_agg');

% Plot map

% Interpolated map
Npoints = 100;
% minX = 0.242 % -0.3;
% maxX = -0.27; % 0.24;
% minY = 0.242; % -0.2;
% maxY = -0.26; %0.32;
minX = session.Xdims(1);
maxX = session.Xdims(2);
minY = session.Ydims(1);
maxY = session.Ydims(2);
xval = linspace(minX, maxX, Npoints);
yval = linspace(minY, maxY, Npoints);
[X,Y] = meshgrid(linspace(minX,maxX,Npoints), linspace(minY,maxY,Npoints));
map_fig = figure();
fudge = session.fudge;
for b = 101:101 %Nbins
    fprintf('Bin %d/%d\n', b, 500);
    Sq = griddata(AZ + fudge*EL, EL, real(squeeze(Sens(:,b))), X, Y);
    imagesc(xval, yval, Sq);
    colorbar;
    set(gca, 'ydir', 'normal');
    colormap('jet');
    xlabel('Cross-Elevation Offset (degrees)');
    ylabel('Elevation Offset (degrees)');
    title(sprintf('Formed Beam Sensitivity Map - %spol', pol));
end

% % Save figure
% fig_filename = sprintf('%s_%spol_map', session.session_name, pol);
% saveas(map_fig, sprintf('%s.png', fig_filename));
% saveas(map_fig, sprintf('%s.pdf', fig_filename));
% saveas(map_fig, sprintf('%s.eps', fig_filename));
% saveas(map_fig, sprintf('%s.fig', fig_filename), 'fig');

% Get the angle of arrival for max sensitivity beam
[s_max,max_idx] = max(Sens(:,101));
% Tsys_eta = Ap./(Sens(max_idx,:)*22.4./flux_density); % Remember to change when running again.
Tsys_eta = Ap./(Sens(max_idx,:));
Tsys_eta(Tsys_eta > 200) = NaN;

tsys_fig = figure();
plot(freq,real(Tsys_eta).');
title('T_s_y_s/\eta_a_p vs Frequency');
xlabel('Frequency (MHz)');
ylabel('T_s_y_s/\eta_a_p (K)');
grid on;

% % Save figure
% tsys_filename = sprintf('%s_%spol_tsys', session.session_name, pol);
% saveas(tsys_fig, sprintf('%s.png', tsys_filename));
% saveas(tsys_fig, sprintf('%s.pdf', tsys_filename));
% saveas(tsys_fig, sprintf('%s.eps', tsys_filename));
% saveas(tsys_fig, sprintf('%s.fig', tsys_filename), 'fig');

toc;