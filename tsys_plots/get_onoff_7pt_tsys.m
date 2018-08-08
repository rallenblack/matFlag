function [Tsys_etaX, Tsys_etaY, freq, wX, wY, maxSens_idx] = get_onoff_7pt_tsys(session, on_scan, off_scan, source, LO_freq)
% On/Off Tsys

addpath ../kernel/
scan_table; % Found in kernel directory
source_table; % Found in kernel directory

quick_map = 0;
overwrite = 0;
overwrite = overwrite | quick_map;

tic;

for p_idx = 1:2
    if p_idx == 1
        pol = 'X';
    else
        pol = 'Y';
    end
    
    on_tstamp = session.scans(on_scan);
    off_tstamp = session.scans(off_scan);
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
    fprintf('Processing off pointings...\n');
    on_off = 1;
    for j = 1:length(off_tstamp)
        tmp_stmp = off_tstamp{j};
        fprintf('    Time stamp: %s - %d/%d\n', tmp_stmp, j, length(off_tstamp));
        
        % Generate filename
        filename = sprintf('%s/%s.mat', out_dir, tmp_stmp);
        
        % Extract data and save
        if ~exist(filename, 'file') || overwrite == 1
            if quick_map == 1
                [R, az_tmp, el_tmp, info] = aggregate_banks_rb_hack(save_dir, ant_dir, tmp_stmp, on_off, -1);
            else
                [R, az_tmp, el_tmp, info] = aggregate_banks_rb(save_dir, ant_dir, tmp_stmp, on_off, -1);
            end
            % Off pointings are dwell scans; need single R, az, and el
            azoff(j) = mean(az_tmp);
            eloff(j) = mean(el_tmp);
            %if quick_map == 0
            save(filename, 'R', 'azoff', 'eloff');
            %end
        else
            load(filename);
        end
        
        % Create entry in position table
        AZoff(j) = azoff(j);
        ELoff(j) = eloff(j);
    end
    
    traj_plot = figure();
    plot(AZoff*60, ELoff*60, 'x');
    title('Trajectory');
    xlabel('Cross-Elevation Offset (arcmin)');
    ylabel('Elevation Offset (arcmin)');
    
    % Iterate over on pointings
    fprintf('Processing on pointings...\n');
    Sens = [];
    AZ = [];
    EL = [];
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
                [R, az, el, info] = aggregate_banks_rb_hack(save_dir, ant_dir, tmp_stmp, on_off, -1);
            else
                [R, az, el, info] = aggregate_banks_rb(save_dir, ant_dir, tmp_stmp, on_off, -1);
            end
            %if quick_map ~= 0
            save(filename, 'R', 'az', 'el');
            %end
        else
            load(filename);
        end
        % Off pointings are dwell scans; need single R, az, and el
        hold on;
        figure(traj_plot);
        plot(az*60, el*60, '-bs'); % 'rx'
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
        
        % Compute mamean(dmjd); % x-SNR weights and compute sensitivity
        Senstmp = zeros(size(R,4),size(R,3));
        
        % Get steering vectors
        fprintf('     Obtaining steering vectors...\n');
        %a = get_steering_vectors(R, OFF.R, good_idx, bad_freqs, save_dir, tmp_stmp, pol, 1);
        a = get_steering_vectors(R, OFF.R, good_idx, bad_freqs, save_dir, tmp_stmp, pol, overwrite);
        
        if i == 1
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
    end
    
    % Get the angle of arrival for max sensitivity beam
    [~,maxSens_idx(p_idx)] = max(Sens(:,101));
    Tsys_eta = Ap./Sens;
    Tsys_eta(Tsys_eta > 300) = NaN;
    Tsys_eta(Tsys_eta < 0) = NaN;
    
    if pol == 'X'
        Tsys_etaX = Tsys_eta;
        wX = w;
    else
        Tsys_etaY = Tsys_eta;
        wY = w;
    end
end

