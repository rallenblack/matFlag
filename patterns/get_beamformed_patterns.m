% Aggregate weights and plot beam patterns
close all;
clearvars;

addpath ../kernel/
scan_table; % Found in kernel directory

tic;

pol = 'Y';

% % AGBT16B_400_01 Grid %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% session = AGBT16B_400_01;
% on_scans = [34, 35, 37, 38, 40, 41, 43, 44, 46, 47, 49, ...
%             50, 65:70, 72, 74:78, 80:85];
% off_scans = [33, 36, 39, 42, 45, 48, 51, 64, ... 
%              71, 79];
% GMST = session.GMST;
% GMST_on = GMST(on_scans);
% GMST_off = GMST(off_scans);

% AGBT16B_400_02 Grid %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
session = AGBT16B_400_02;
on_scans = [13:15, 17:19, 21:23, 25:27, 29:31,...
            33:35, 37:39, 41:43, 45:47, 49:51, 53:55];
off_scans = [16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56];
% GMST = session.GMST;
% GMST_on = GMST(on_scans);
% GMST_off = GMST(off_scans);

% % AGBT16B_400_03 Grid %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% session = AGBT16B_400_03;
% on_scans = [11:14, 16:18, 20:22, 24:26, 28:30, 32:34, 36:38, 40:42, 44:46, 48:50, 52:54];
% off_scans = [15, 19, 23, 27, 31, 35, 39, 43, 47, 51];

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
% GMST = session.GMST;
% GMST_on = GMST(on_scans);
% GMST_off = GMST(off_scans);

% % AGBT16B_400_05 Grid %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% session = AGBT16B_400_05;
% on_scans = 24;
% off_scans = [23, 25];

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
overwrite = 0;
k = 0;
kB = 1.38*1e-23;

rad = 50;
Ap = (rad^2)*pi;
deg_rad = pi/180;

LO_freq = 1450;
freqs = ((-249:250)*303.75e-3) + LO_freq;

ant_dir = sprintf('%s/%s/Antenna', meta_root, proj_str);

% Iterate over off pointings just to have them ready
% Iterate over on pointings and look for closest off pointing

% Iterate over off pointings
AZoff = zeros(length(off_tstamp), 1);
ELoff = zeros(length(off_tstamp), 1);
fprintf('Processing off pointings...\n');
for j = 1:length(off_tstamp)
    tmp_stmp = off_tstamp{j};
    fprintf('    Time stamp: %s - %d/%d\n', tmp_stmp, j, length(off_tstamp));
    
    % Generate filename
    filename = sprintf('%s/%s.mat', out_dir, tmp_stmp);
    
    % Extract data and save
    if ~exist(filename, 'file') || overwrite == 1
        [R, az, el, ~] = aggregate_banks(save_dir, ant_dir, tmp_stmp, -1);
        save(filename, 'R', 'az', 'el');
    else
        load(filename);
    end
% %     GMST_off = 18.697374558 + 24.06570982441908*D;
%     h_off = GMST_off(j) - obs_long - az;
%     az_tmp = atan2(sin(h_off*deg_rad),(cos(h_off*deg_rad)*sin(obs_lat*deg_rad) - tan(el*deg_rad)*cos(obs_lat*deg_rad)));
%     el_tmp = asin(sin(obs_lat*deg_rad)*sin(el*deg_rad) + cos(obs_lat*deg_rad)*cos(el*deg_rad)*cos(h_off*deg_rad));
    
    % Off pointings are dwell scans; need single R, az, and el
    azi = mean(az);
    ele = mean(el);
    
    % Create entry in position table
    AZoff(j) = azi;
    ELoff(j) = ele;
end
    
figure(1);
plot(AZoff, ELoff, 'x');

% Iterate over on pointings
fprintf('Processing on pointings...\n');
Sens = [];
AZ = [];
EL = [];
a_agg = []; % Aggregated steering vectors
w_agg = []; % Aggregated steering vectors
pattern = [];
beamPattern = [];
w = [];
for i = 1:length(on_tstamp)
    tmp_stmp = on_tstamp{i};
    fprintf('    Time stamp: %s - %d/%d\n', tmp_stmp, i, length(on_tstamp));
    
    % Generate filename
    filename = sprintf('%s/%s.mat', out_dir, tmp_stmp);
    
    % Extract data and save
    if ~exist(filename, 'file') || overwrite == 1
        [R, az, el, ~] = aggregate_banks(save_dir, ant_dir, tmp_stmp, 10);
        save(filename, 'R', 'az', 'el');
    else
        load(filename);
    end
% %     GMST_on = 18.697374558 + 24.06570982441908*D;
%     h_on = GMST_on(i) - obs_long - az;
%     azi = atan2((sin(h_on*deg_rad)), (cos(h_on*deg_rad)*sin(obs_lat*deg_rad) - tan(el*deg_rad)*cos(obs_lat*deg_rad)));
%     ele = asin(sin(obs_lat*deg_rad)*sin(el*deg_rad) + cos(obs_lat*deg_rad)*cos(el*deg_rad).*cos(h_on*deg_rad));
    
    azi = az;
    ele = el;
    
    % Off pointings are dwell scans; need single R, az, and el
    hold on;
    plot(azi, ele, '-b');
    hold off;
    drawnow;
    
    % Find nearest off poinitng
    for j = 1:length(off_tstamp)
        az_dist = azi - AZoff(j);
        el_dist = ele - ELoff(j);
        
        vector_distance(j) = mean(sqrt(az_dist.^2 + el_dist.^2));
    end
    
    [~, idx] = min(vector_distance);
    fprintf('     Using %s as the off pointing...\n', off_tstamp{idx});
    OFF = load(sprintf('%s/%s', out_dir, off_tstamp{idx}));
    
    % Get steering vectors
    fprintf('     Obtaining steering vectors...\n');
    a = get_steering_vectors(R, OFF.R, good_idx, bad_freqs, save_dir, tmp_stmp, pol, 0);
    
    if i == 1
        a_agg = a;
    else
        % Append to aggregated steering vector matrix
        a_agg = cat(2, a_agg, a);
    end
    
    fprintf('     Calculating weights...\n');
    
    if i == 13  % 14 for Session 3
        fprintf('i = %d\n', i);
        bm_idx = [1,30];
        for b = 1:size(R,3)
            w(:,1,b) = OFF.R(good_idx, good_idx, b)\a(:,bm_idx(1),b);
            w(:,2,b) = OFF.R(good_idx, good_idx, b)\a(:,bm_idx(2),b);
        end
    elseif i == 18 % 16 for Session 3
        fprintf('i = %d\n', i);
        bm_idx = 30;
        for b = 1:size(R,3)
            w(:,3,b) = OFF.R(good_idx, good_idx, b)\a(:,bm_idx,b);
        end
    elseif i == 19 % 17 for Session 3
        fprintf('i = %d\n', i);
        bm_idx = 17;
        for b = 1:size(R,3)
            w(:,4,b) = OFF.R(good_idx, good_idx, b)\a(:,bm_idx,b);
        end
    elseif i == 20 % 18 for Session 3
        fprintf('i = %d\n', i);
        bm_idx = 1;
        for b = 1:size(R,3)
            w(:,5,b) = OFF.R(good_idx, good_idx, b)\a(:,bm_idx,b);
        end
    elseif i == 25 % 23 for Session 3
        fprintf('i = %d\n', i);
        bm_idx = [1,30];
        for b = 1:size(R,3)
            w(:,6,b) = OFF.R(good_idx, good_idx, b)\a(:,bm_idx(1),b);
            w(:,7,b) = OFF.R(good_idx, good_idx, b)\a(:,bm_idx(2),b);
        end
    end
 
    AZ = [AZ; azi];
    EL = [EL; ele];
end

Nbeam = 7;
for beam = 1:Nbeam
    for t = 1:size(a_agg,2)
        for b = 1:size(a_agg,3)
            if sum(bad_freqs == b) == 0
                pattern(beam,t,b) = abs(w(:,beam,b)'*a_agg(:,t,b))^2;
            else
                pattern(beam,t,b) = 0;
            end
        end
    end
end

%%
% Plot map

% Interpolated map
Npoints = 200;
minX = session.Xdims(1); % min(AZ);
maxX = session.Xdims(2); % max(AZ);
minY = min(EL);
maxY = max(EL);
xval = linspace(minX, maxX, Npoints);
yval = linspace(minY, maxY, Npoints);
[X,Y] = meshgrid(linspace(minX,maxX,Npoints), linspace(minY,maxY,Npoints));
map_fig = figure();

% Beam subplot coordinates
sub_pos = {[0.2+0.03+0.03,  0.65+0.00+0.0425, 0.20, 0.20],...
           [0.5+0.00+0.03,  0.65+0.00+0.0425, 0.20, 0.20],...
           [0.05+0.06+0.03, 0.35+0.02+0.0425, 0.20, 0.20],...
           [0.35+0.03+0.03, 0.35+0.02+0.0425, 0.20, 0.20],...
           [0.65+0.00+0.03, 0.35+0.02+0.0425, 0.20, 0.20],...
           [0.2+0.03+0.03,  0.05+0.04+0.0425, 0.20, 0.20],...
           [0.5+0.00+0.03,  0.05+0.04+0.0425, 0.20, 0.20]};

fudge = session.fudge;
for b = 101:101 %Nbins
    fprintf('Bin %d/%d\n', b, 500);
    for beam = 1:Nbeam
        % Create a subplot at a custom location
        subplot('Position', sub_pos{beam});
        
        % Get the pattern using griddata
        norm_pattern = 10*log10(squeeze(pattern(beam,:,b)./max(pattern(beam,:,b))));
        Bq = griddata(AZ+fudge*EL, EL, norm_pattern, X, Y);
        
        % Plot the pattern
        imagesc(xval, yval, Bq);
        caxis([-40, 0]);
        colormap('jet');
        set(gca, 'ydir', 'normal');
        
        % Set the colorbar to be on the right-hand side of the figure
        colorbar('Position', [0.91, 0.05, 0.03, 0.875], 'Limits', [-40, 0]);
        
        % Write the beam title
        title(sprintf('Beam %d', beam), 'FontSize', 9);
        
        % Set the tick font size
        set(gca, 'FontSize', 8);
        
        % Draw contours
        hold on;
        contour(xval,yval,Bq, [-10, -3], 'ShowText', 'on', 'LineColor', 'black');
        hold off;
    end
end

% Create title
ax1 = axes('Position', [0 0 1 1], 'Visible', 'off');
my_title = sprintf('%s - %s-Polarization, %d MHz', session.session_name, pol, floor(freqs(b)));
my_xlabel = 'Right Acesnsion (degrees)';
my_ylabel = 'Declination (degrees)';
text(0.5, 0.965, my_title, 'HorizontalAlignment', 'center', 'Units', 'normalized', 'FontSize', 12, 'FontWeight', 'bold');
text(0.5, 0.05, my_xlabel, 'HorizontalAlignment', 'center', 'Units', 'normalized', 'FontSize', 10, 'FontWeight', 'bold');
text(0.05, 0.5, my_ylabel, 'HorizontalAlignment', 'center', 'Units', 'normalized', 'FontSize', 10, 'FontWeight', 'bold', 'Rotation', 90);

fig_filename = sprintf('pattern_plots/%s_%spol_formed_beams', session.session_name, pol);
saveas(map_fig, sprintf('%s.png', fig_filename));
saveas(map_fig, sprintf('%s.pdf', fig_filename));
saveas(map_fig, sprintf('%s.eps', fig_filename));
saveas(map_fig, sprintf('%s.fig', fig_filename), 'fig');


toc;


