% Aggregate weights and plot sensitvity map
close all;
clearvars;

%Nworkers = 4;
%tmp_p = gcp('nocreate');
%if isempty(tmp_p)
%    myCluster = parcluster('local');
%    myCluster.NumWorkers = Nworkers;
%    parpool(myCluster, Nworkers);
%end

addpath ../kernel/
scan_table; % Found in kernel directory
source_table; % Found in kernel directory

tic;

quick_map = 0;
overwrite = 1;
overwrite = overwrite | quick_map;

% AGBT17B_360_02 SNR experiments %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
session = AGBT17B_360_02;

% 0.01 Jy %%%%%%%%%%%%%%%%%
% on_scans = 64;
% off_scans = [29,35,41,47,53,59];
% Nint = 25; % 22
% note = '1st_0_01_Jy';
% flux_density = 0.01;

% on_scans = 88;
% off_scans = [79,87];
% Nint = 25; % 22;
% note = '2nd_0_01_Jy';
% flux_density = 0.01;

% % 0.05 Jy %%%%%%%%%%%%%%%%%
% on_scans = 65;
% off_scans = [29,35,41,47,53,59];
% Nint = 25; % 22;
% note = '0_05_Jy';
% flux_density = 0.05;

% % 0.1 Jy %%%%%%%%%%%%%%%%%%
% on_scans = 66;
% off_scans = [29,35,41,47,53,59];
% Nint = 25; % 22
% note = '0_1_Jy';
% flux_density = 0.1;

% % 10 Jy %%%%%%%%%%%%%%%%%%%%
on_scans = 67;
off_scans = [29,35,41,47,53,59];
Nint = 25; % 22
note = '10_Jy';
% flux_density = 10;


for p_idx = 1:1
    if p_idx == 1
        pol = 'X';
    else
        pol = 'Y';
    end

    on_tstamp = session.scans(on_scans);
    off_tstamp = session.scans(off_scans);
    if pol == 'X'
        good_idx = session.goodX;
    else
        good_idx = session.goodY;
    end
    bad_freqs = session.bad_freqs;

    % Quick hacks to get a quick map
    if quick_map == 1
        bad_freqs = 1:500;
        bad_freqs(101) = [];
    end
    
    % AGBT17B_360_02 bad freqs (64-67) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    bad_freqs = [(1:5)+10, (1:5)+(5*15), (101:105)+10, (101:105)+(5*15), (201:205)+10, 250, ...
        (201:205)+(5*15), (301:305)+10, (301:305)+(5*15), (401:405)+10, (401:405)+(5*15)];
    
    % AGBT17B_360_02 bad freqs (88) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     bad_freqs = [(1:5)+70, (1:5)+80, (1:5)+105, (1:5)+110, (101:105)+70, (101:105)+80, ...
%         (101:105)+105, (101:105)+110, (201:205)+70, 250, (201:205)+80, (201:205)+105, ...
%         (201:205)+110, (301:305)+70, (301:305)+80, (301:305)+105, (301:305)+110, ...
%         (401:405)+70, (401:405)+80];
    
    % Quick hack to get a faster result
    %bad_freqs = 1:500;
    %bad_freqs(101) = [];

    proj_str = session.session_name;
    save_dir = sprintf('%s/%s/BF', data_root, proj_str);
    out_dir = sprintf('%s/mat', save_dir);
    mkdir(save_dir, out_dir);

    % Constants
    k = 0;
    kB = 1.38*1e-23;

    rad = 50;
    Ap = (rad^2)*pi;

    LO_freq = 1450;
    freq = ((-249:250)*303.75e-3) + LO_freq;
%     a = source.a;
%     b = source.b;
%     c = source.c;
%     d = source.d;
%     e = source.e;
%     f = source.f;
%     x = a + b*log10(freq./1e3) + c*log10(freq./1e3).^2 + d*log10(freq./1e3).^3 + e*log10(freq./1e3).^4 + f*log10(freq./1e3).^5;
%     flux_density = 10.^x;

    ant_dir = sprintf('%s/%s/Antenna', meta_root, proj_str);

    % Iterate over off pointings just to have them ready
    % Iterate over on pointings and look for closest off pointing

%     % Iterate over off pointings
%     AZoff = zeros(length(off_tstamp), 1);
%     ELoff = zeros(length(off_tstamp), 1);
%     fprintf('Processing off pointings...\n');
%     on_off = 1;
%     for j = 1:length(off_tstamp)
%         tmp_stmp = off_tstamp{j};
%         fprintf('    Time stamp: %s - %d/%d\n', tmp_stmp, j, length(off_tstamp));
% 
%         % Generate filename
%         filename = sprintf('%s/%s.mat', out_dir, tmp_stmp);
% 
%         % Extract data and save
%         if ~exist(filename, 'file') || overwrite == 1
%             if quick_map == 1
%                 [R, az_tmp, el_tmp, info] = aggregate_banks_rb_hack(save_dir, ant_dir, tmp_stmp, on_off, -1);
%             else
%                 [R, az_tmp, el_tmp, info] = aggregate_banks_rb(save_dir, ant_dir, tmp_stmp, on_off, -1);
%             end
%             % Off pointings are dwell scans; need single R, az, and el
%             az = mean(az_tmp);
%             el = mean(el_tmp);
%             %if quick_map == 0
%                 save(filename, 'R', 'az', 'el');
%             %end
%         else
%             load(filename);
%         end
% 
%         % Create entry in position table
%         AZoff(j) = az;
%         ELoff(j) = el;
%     end
% 
%     traj_plot = figure();
%     plot(AZoff*60, ELoff*60, 'x');
%     title('Trajectory');
%     xlabel('Cross-Elevation Offset (arcmin)');
%     ylabel('Elevation Offset (arcmin)');

    % Iterate over on pointings
    fprintf('Processing on pointings...\n');
    Sens = [];
    AZon = [];
    ELon = [];
    cal = [];
    on_off = 1;
    for i = 1:length(on_tstamp)
        tmp_stmp = on_tstamp{i};
        fprintf('    Time stamp: %s - %d/%d\n', tmp_stmp, i, length(on_tstamp));

        % Generate filename
        filename = sprintf('%s/%s.mat', out_dir, tmp_stmp);

        % Extract data and save
        if ~exist(filename, 'file') || overwrite == 1
            if quick_map == 1
                [R, az, el, info] = aggregate_banks_rb_hack(save_dir, ant_dir, tmp_stmp, on_off, Nint);
            else
                [R, az, el, info] = aggregate_banks_rb(save_dir, ant_dir, tmp_stmp, on_off, Nint);
            end
            %if quick_map ~= 0
                save(filename, 'R', 'az', 'el');
            %end
        else
            load(filename);
        end
        % Off pointings are dwell scans; need single R, az, and el
%         hold on;
        traj_plot = figure();
        figure(traj_plot);
        plot(az*60, el*60, '-bs'); % 'rx'
%         hold off;
        drawnow;

%         % Find nearest off poinitng
%         for j = 1:length(AZoff)%length(off_tstamp)
%             az_dist = az - AZoff(j);
%             el_dist = el - ELoff(j);
% 
%             vector_distance(j) = mean(sqrt(az_dist.^2 + el_dist.^2));
%         end
% 
%         [~, idx] = min(vector_distance);
%         fprintf('     Using %s as the off pointing...\n', off_tstamp{idx});
%         OFF = load(sprintf('%s/%s', out_dir, off_tstamp{idx}));

        fprintf('     Loading weights...\n');

        % Load weights from calibration grid before source observation
        note_weight = 'grid';
        w_filename = sprintf('%s/%s_aggregated_weights_%s_%s.mat', out_dir,...
            session.session_name, pol, note_weight);
        if ~exist(w_filename, 'file')
            error(sprintf('The weight vectors file %s does not exist!\n',...
                w_filename));
        end
        load(w_filename);

        fprintf('     Calculating weights and sensitivity...\n');
        
        
%         Nbeam = 7;
%         for beam = 1:Nbeam
%             delta_el = (EL - session.beam_el(beam)).^2;
%             delta_az = (AZ - session.beam_az(beam)).^2;
%             d = sqrt(delta_el + delta_az);
%             
%             [~, beam_idx(beam)] = min(d);
%         end
%         w = w_agg(:,beam_idx,:);
        
        
        % Approximately center row of the grid %%%%%%%%%%%%%%%%
        row_pnts = 497:528;

%         % Different row of the grid %%%%%%%%%%%%%%%%%%%%%%%%%%%
%         row_pnts = 249:280; % 746:776; % % 807:838;

        w = w_agg(:,row_pnts,:);
        
        note2 = strrep(note, '_Jy', ' Jy');
        note2 = strrep(note2, '0_', '0.');
        note2 = strrep(note2, 't_', 't ');
        note2 = strrep(note2, 'd_', 'd ');

        az_offset = AZ(2)-AZ(1);
%         elaz_offset = sqrt((EL(2)-EL(1)).^2 + (AZ(2)-AZ(1)).^2);
%         elaz = sqrt(EL(beam_idx).^2 + AZ(beam_idx).^2);
        col_line = ['k-','b-','r-','y-','c-','g-','m-'];
        beam_fig = figure();
        SNR = zeros(size(w,2),size(w,3));
        snr_freq = 101;
        for t1 = 1:size(R,4)
            for t2 = 1:size(w,2)
                for b = 1:size(R,3)
                    if sum(bad_freqs == b) == 0
                        Pon = w(:,t2,b)'*R(good_idx, good_idx, b, t1)*w(:,t2,b);
                        Poff = w(:,t2,b)'*R(good_idx, good_idx, b,1)*w(:,t2,b);
                        SNR(t2,b) = (Pon - Poff)/Poff;
                        sig_power(t2,b) = (Pon - Poff)/10e-26; % /Poff;
                    end
                end
            end
            plot(AZ(row_pnts)+az_offset*(t1-round(size(R,4)/2)),abs(SNR(:,101)),col_line(t1));
%             plot(elaz+elaz_offset*(t1-round(size(R,4)/2)),abs(SNR(:,101)),col_line(t1));
%             % In dB %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             plot(AZ(row_pnts)+az_offset*(t1-round(size(R,4)/2)),10*log10(abs(SNR(:,101))),col_line(t1));
            drawnow;
            hold on;
        end
        grid on;
        xlabel('Cross-Elevation offset');
        ylabel('SNR');
        title(sprintf('%s source SNR vs. Cross-Elevation offset - %spol, %g MHz', note2, pol, freq(snr_freq)));
        legend('1st point','2nd point','3rd point','4th point','5th point','6th point','7th point');
        hold off;
    end
end


toc;