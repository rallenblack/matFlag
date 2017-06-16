function [AZ, EL, patterns] = get_beamformed_patterns(session, pol)

    % Read scan table for session information
    scan_table;

    on_scans = session.on_scans;
    off_scans = session.off_scans;

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
    patterns = [];
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
                    patterns(beam,t,b) = abs(w(:,beam,b)'*a_agg(:,t,b))^2;
                else
                    patterns(beam,t,b) = 0;
                end
            end
        end
    end
end
