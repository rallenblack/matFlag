% Aggregate weights and plot sensitvity map
close all;
clearvars;

addpath ../kernel/
scan_table; % Found in kernel directory

% % AGBT16B_400_01 Grid %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% session = AGBT16B_400_01;
% on_scans = [34, 35, 37, 38, 40, 41, 43, 44, 46, 47, 49, ...
%             50, 65:70, 72, 74:78, 80:85];
% off_scans = [33, 36, 39, 42, 45, 48, 51, 64, ...
%              71, 79];

% AGBT16B_400_02 Grid %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
session = AGBT16B_400_02;
on_scans = [13:15, 17:19, 21:23, 25:27, 29:31,...
    33:35, 37:39, 41:43, 45:47, 49:51, 53:55];
off_scans = [16, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56];

% % AGBT16B_400_03 Grid %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% session = AGBT16B_400_03;
% on_scans = [12:14, 16:18, 20:22, 24:26, 28:30, 32:34, 36:38, 40:42, 44:46, 48:50, 52:54];
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

% % AGBT16B_400_05 Grid %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% session = AGBT16B_400_05;
% on_scans = 24;
% off_scans = [23, 25];

tic;

% Iterate over polarization
for pol_idx = 1:2
    if pol_idx == 1
        pol = 'X';
        good_idx = session.goodX;
    else
        pol = 'Y';
        good_idx = session.goodY;
    end
    
    on_tstamp = session.scans(on_scans);
    off_tstamp = session.scans(off_scans);

    bad_freqs = session.bad_freqs;
    
    proj_str = session.session_name;
    save_dir = sprintf('%s/%s/BF', data_root, proj_str);
    out_dir = sprintf('%s/mat', save_dir);
    mkdir(save_dir, out_dir);
    
    % Constants
    overwrite = 0;
    k = 0;
    
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
            [R, az_tmp, el_tmp, ~] = aggregate_banks(save_dir, ant_dir, tmp_stmp, -1);
            
            % Off pointings are dwell scans; need single R, az, and el
            az = mean(az_tmp);
            el = mean(el_tmp);
            save(filename, 'R', 'az', 'el');
        else
            load(filename);
        end
        
        % Create entry in position table
        AZoff(j) = az;
        ELoff(j) = el;
    end
    
    figure(pol_idx);
    plot(AZoff, ELoff, 'x');
    
    % Iterate over on pointings
    fprintf('Processing on pointings...\n');
    AZ = [];
    EL = [];
    for i = 1:length(on_tstamp)
        tmp_stmp = on_tstamp{i};
        fprintf('    Time stamp: %s - %d/%d\n', tmp_stmp, i, length(on_tstamp));
        
        % Generate filename
        filename = sprintf('%s/%s.mat', out_dir, tmp_stmp);
        
        % Extract data and save
        if ~exist(filename, 'file') || overwrite == 1
            [R, az, el, info] = aggregate_banks(save_dir, ant_dir, tmp_stmp, 10);
            save(filename, 'R', 'az', 'el');
        else
            load(filename);
        end
        % Off pointings are dwell scans; need single R, az, and el
        hold on;
        plot(az, el, '-b');
        hold off;
        drawnow;
        
        % Find nearest off poinitng
        for j = 1:length(AZoff)%length(off_tstamp)
            az_dist = az - AZoff(j);
            el_dist = el - ELoff(j);
            
            vector_distance(j) = mean(sqrt(az_dist.^2 + el_dist.^2));
        end
        
        [~, idx] = min(vector_distance);
        fprintf('     Using %s as the off pointing...\n', off_tstamp{idx});
        OFF = load(sprintf('%s/%s', out_dir, off_tstamp{idx}));
        
        % Get steering vectors
        fprintf('     Obtaining steering vectors...\n');
        a = get_steering_vectors(R, OFF.R, good_idx, bad_freqs, save_dir, tmp_stmp, pol, 1);
        
        if i == 1
            a_agg = a;
        else
            % Append to aggregated steering vector matrix
            a_agg = cat(2, a_agg, a);
        end
        
        fprintf('     Calculating weights...\n');
        w = zeros(size(a));
        for t = 1:size(R,4)
            for b = 1:size(R,3)
                if sum(bad_freqs == b) == 0
                    w(:,t,b) = OFF.R(good_idx, good_idx, b)\a(:,t,b);
                    w(:,t,b) = w(:,t,b)./(w(:,t,b)'*a(:,t,b));
                else
                    w(:,t,b) = zeros(size(a,1),1);
                end
            end
            AZ = [AZ; az(t)];
            EL = [EL; el(t)];
        end
        
        if i == 1
            w_agg = w;
        else
            % Append to aggregated steering vector matrix
            w_agg = cat(2, w_agg, w);
        end
    end
    
    a_filename = sprintf('%s/%s_aggregated_grid_%s.mat', out_dir, session.session_name, pol);
    fprintf('Saving aggregated steering vectors to %s\n', a_filename);
    save(a_filename, 'AZ', 'EL', 'a_agg');
    
    w_filename = sprintf('%s/%s_aggregated_weights_%s.mat', out_dir, session.session_name, pol);
    fprintf('Saving aggregated weight vectors to %s\n', w_filename);
    save(w_filename, 'AZ', 'EL', 'w_agg');
    
    % Element mapping
    X_idx = session.goodX;
    Y_idx = session.goodY;
    
    fprintf('Processing Pol %s\n', pol);
    
    % Get beam weights
    beam_az = session.beam_az;
    beam_el = session.beam_el;
    [w, w_az, w_el] = get_grid_weights(session, pol, beam_az, beam_el);
    if pol == 'X'
        wX = w;
    else
        wY = w;
    end
end

% Save weights to file
rtbf_filename = sprintf('%s/%s/BF/weights_%s.bin', data_root,...
    session.session_name, session.session_name);
create_weight_file(w_az, w_el, wX, wY, session.session_name, X_idx, Y_idx, rtbf_filename);

toc;

