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
% Nint = 1; % 22
% note = '1st_0_01_Jy';
% flux_density = 0.01;

% on_scans = 88;
% off_scans = [79,87];
% Nint = 1; % 22;
% note = '2nd_0_01_Jy';
% flux_density = 0.01;

% % 0.05 Jy %%%%%%%%%%%%%%%%%
% on_scans = 65;
% off_scans = [29,35,41,47,53,59];
% Nint = 1; % 22;
% note = '0_05_Jy';
% flux_density = 0.05;

% % 0.1 Jy %%%%%%%%%%%%%%%%%%
on_scans = 66;
off_scans = [29,35,41,47,53,59];
Nint = 1; % 22
note = '0_1_Jy';
% flux_density = 0.1;

% % 10 Jy %%%%%%%%%%%%%%%%%%%%
% on_scans = 67;
% off_scans = [29,35,41,47,53,59];
% Nint = 1; % 22
% note = '10_Jy';
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

    ant_dir = sprintf('%s/%s/Antenna', meta_root, proj_str);

    % Iterate over off pointings just to have them ready
    % Iterate over on pointings and look for closest off pointing

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
        hold off;
        drawnow;

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
        % Find closest AZ/EL for specified beam locations
        Nbeam = length(az);
        for beam = 1:Nbeam
            delta_el = (EL - el(beam)).^2;
            delta_az = (AZ - az(beam)).^2;
            d = sqrt(delta_el + delta_az);
            
            [~, beam_idx(beam)] = min(d);
        end
        w = w_agg(:,beam_idx,:);
        
        center_beam = round(size(R,4)/2);
        arr_el = 1; % Center element is element 1
%         w_cel = zeros(size(w));
%         w_cel(1,:,:) = ones(size(w,2), size(w,3));
        for t = 1:size(R,4)
            for b = 1:size(R,3)
                if sum(bad_freqs == b) == 0
                    
                    w_cb = w(:,center_beam,b);
                    Pon = w_cb'*R(good_idx, good_idx, b, t)*w_cb;
                    Poff = w_cb'*R(good_idx, good_idx, b,1)*w_cb;
                    
                    Pon_el = R(arr_el, arr_el, b, t); % w_cel(:,t,b)'*R(good_idx, good_idx, b, t)*w_cel(:,t,b);
                    Poff_el = R(arr_el, arr_el, b, 1); %  w_cel(:,t,b)'*R(good_idx, good_idx, b, 1)*w_cel(:,t,b);
                    
                    SNR_el(t,b) = (Pon_el - Poff_el)/Poff_el;
                    SNR(t,b) = (Pon - Poff)/Poff;
                    sig_power(t,b) = (Pon - Poff);
                    sig_power_el(t,b) = (Pon_el - Poff_el);
%                     Sens(t,b) = 2*kB*SNR(t,b)./(flux_density*1e-26);
                else
%                     Senstmp(t,b) = 0;
%                     w(:,t,b) = zeros(size(w,1),1);
                end
            end
        end
    end

    % Plot SNR %%%%%%%%%%%%%%%%%%%%%%%%%%%%
    note2 = strrep(note, '_Jy', ' Jy');
    note2 = strrep(note2, '0_', '0.');
    note2 = strrep(note2, 't_', 't ');
    note2 = strrep(note2, 'd_', 'd ');

    % Necessary for 1st 0.01 Jy %%%%%%%%%%%%%%%%%%%%%%%%%%%
%     SNR(:,[1:15,20:24,152,153,bad_freqs]) = NaN;
%     SNR(abs(SNR) > 0.01) = NaN;
%     SNR_freq = 148;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Necessary for 2nd 0.01 Jy %%%%%%%%%%%%%%%%%%%%%%%%%%%
%     SNR(:,[1:15,20:24,152,153,bad_freqs]) = NaN;
%     SNR(abs(SNR) > 0.02) = NaN;
%     SNR_freq = 148;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Necessary for 0.1 Jy & 0.05 Jy %%%%%%%%%%%%%%%%%%%
    SNR(:,[1:15,20:24,152,153,bad_freqs]) = NaN;
    SNR(abs(SNR) > 0.02) = NaN;
    SNR_freq = 148;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % Necessary for 10 Jy %%%%%%%%%%%%%%%%%%%%%%%%%%%
%     SNR(:,[1:15,152,153,bad_freqs]) = NaN;
%     SNR_el(:,[1:15,152,153,bad_freqs]) = NaN;
%     SNR_freq = 101;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % SNR vs position %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    SNRel_fig = figure();
    plot(az, abs(SNR_el(:,SNR_freq)).');
%     plot(az, abs(sig_power_el(:,SNR_freq)).');
    xlabel('Cross-elevation offset');
    ylabel('SNR');
    title(sprintf('%s pol SNR (Center element) of %s source at %d MHz', pol, note2, round(freq(SNR_freq))));
    grid on;
    
    SNRp_dB_fig = figure();
    plot(az, 10*log10(abs(SNR(:,SNR_freq)).'));
%     plot(1:size(sig_power,1), 10*log10(abs(sig_power(:,SNR_freq)).'));
    xlabel('Cross-elevation offset');
    ylabel('SNR (dB)');
    title(sprintf('%s pol SNR (dB) of %s source at %d MHz', pol, note2, round(freq(SNR_freq))));
    grid on;
    
%     snrp_dB_filename = sprintf('%s/SNR_experiment/%s_%s_pol_SNRpos_dB_%s', session.session_name, session.session_name, pol, note);
%     saveas(SNRp_dB_fig, sprintf('%s.png', snrp_dB_filename));
%     saveas(SNRp_dB_fig, sprintf('%s.pdf', snrp_dB_filename));
%     saveas(SNRp_dB_fig, sprintf('%s.eps', snrp_dB_filename));
%     saveas(SNRp_dB_fig, sprintf('%s.fig', snrp_dB_filename), 'fig');
    
    SNRp_fig = figure();
    plot(az, abs(SNR(:,SNR_freq)).');
%     plot(1:size(sig_power,1), abs(sig_power(:,SNR_freq)).');
    
    xlabel('Cross-elevation offset');
    ylabel('SNR');
    title(sprintf('%s pol SNR of %s source at %d MHz', pol, note2, round(freq(SNR_freq))));
    grid on;
    
%     snrp_filename = sprintf('%s/SNR_experiment/%s_%s_pol_SNRpos_%s', session.session_name, session.session_name, pol, note);
%     saveas(SNRp_fig, sprintf('%s.png', snrp_filename));
%     saveas(SNRp_fig, sprintf('%s.pdf', snrp_filename));
%     saveas(SNRp_fig, sprintf('%s.eps', snrp_filename));
%     saveas(SNRp_fig, sprintf('%s.fig', snrp_filename), 'fig');
    
    % SNR intensity plot (Spatial sample vs. Freq bins) %%%%%%%%%%%%%%%%%%%
    
    SNRi_dB_fig = figure();
    imagesc(az, freq, 10*log10(abs(SNR.')));
%     imagesc(10*log10(abs(sig_power)));
    
    xlabel('Cross-Elevation offset');
    ylabel('Frequency channels (MHz)');
    title(sprintf('%s pol SNR (dB) of %s source', pol, note2));
    colorbar;
    
%     snri_dB_filename = sprintf('%s/SNR_experiment/%s_%s_pol_SNRint_dB_%s', session.session_name, session.session_name, pol, note);
%     saveas(SNRi_dB_fig, sprintf('%s.png', snri_dB_filename));
%     saveas(SNRi_dB_fig, sprintf('%s.pdf', snri_dB_filename));
%     saveas(SNRi_dB_fig, sprintf('%s.eps', snri_dB_filename));
%     saveas(SNRi_dB_fig, sprintf('%s.fig', snri_dB_filename), 'fig');
    
    SNRi_fig = figure();
    imagesc(az, freq, abs(SNR.'));
%     imagesc(abs(sig_power));
    
    xlabel('Cross-Elevation offset');
    ylabel('Frequency channels (MHz)');
    title(sprintf('%s pol SNR of %s source', pol, note2));
    colorbar;
    
%     snri_filename = sprintf('%s/SNR_experiment/%s_%s_pol_SNRint_%s', session.session_name, session.session_name, pol, note);
%     saveas(SNRi_fig, sprintf('%s.png', snri_filename));
%     saveas(SNRi_fig, sprintf('%s.pdf', snri_filename));
%     saveas(SNRi_fig, sprintf('%s.eps', snri_filename));
%     saveas(SNRi_fig, sprintf('%s.fig', snri_filename), 'fig');
 
    keyboard;
end


toc;