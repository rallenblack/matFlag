function [Tsys_etaX, Tsys_etaY, freqs, wX, wY] = get_onoff_tsys(session, on_scan, off_scan, source, LO_freq)
    % On/Off Tsys

    addpath ../kernel/
    scan_table; % Found in kernel directory
    source_table; % Found in kernel directory

    tic;

    for i = 1:2
        if i == 1
            pol = 'X';
        else
            pol = 'Y';
        end

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
        [~, ~, ~] = mkdir(save_dir, out_dir);

        % Constants
        overwrite = 0;
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

        ant_dir = sprintf('%s/%s/Antenna', meta_root1, proj_str);

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
            [R, az_tmp, el_tmp, ~] = aggregate_banks(save_dir, ant_dir, tmp_stmp, 1, -1);

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
            [R, az, el, info] = aggregate_banks(save_dir, ant_dir, tmp_stmp, 1, -1);
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

        % Get the angle of arrival for max sensitivity beam
        Tsys_eta = Ap./Sens;
        
        if pol == 'X'
            Tsys_etaX = Tsys_eta;
            wX = w;
        else
            Tsys_etaY = Tsys_eta;
            wY = w;
        end
    end
end

