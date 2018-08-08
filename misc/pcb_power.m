% Post-correlation beamformed power
close all;
clearvars;

addpath ../kernel/
addpath ../patterns/
scan_table; % Found in kernel directory

% AGBT16B_400_11 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
session = AGBT16B_400_12;
% Calibrator
scan_nums = 25:31;

% Project directory
proj_str = session.session_name;
save_dir = sprintf('%s/%s/BF', data_root, proj_str);

% Antenna directory
ant_dir = sprintf('%s/%s/Antenna', meta_root, proj_str);

% Get beam locations
beam_az = session.beam_az;
beam_el = session.beam_el;

% Element mapping
X_idx = session.goodX;
Y_idx = session.goodY;

for i = 1:length(scan_nums)
    scan_num = scan_nums(i);
    
    % Get timestamp
    tstamp = session.scans{scan_num};
    fprintf('    Time stamp: %s\n', tstamp);

    % Generate filename
    filename = sprintf('%s/%sA.fits', save_dir, tstamp);
    
    % Get correlation matrix
    [R, az, el, ~] = aggregate_banks_rb_hack(save_dir, ant_dir, tstamp, 1, -1);
    chans = [1:5, 101:105, 201:205, 301:305, 401:405];
    Rbank = R(:,:,chans);
    
    % Get weights
    [wX, w_az, w_el] = get_grid_weights(session, 'X', beam_az, beam_el);
    [wY, ~   , ~   ] = get_grid_weights(session, 'Y', beam_az, beam_el);
    
    % Apply weights
    Px = zeros(size(wX,2), length(chans));
    Py = zeros(size(wX,2), length(chans));
    for w_idx = 1:size(wX,2)
        for b = 1:length(chans)
            Px(w_idx,b) = real(wX(:,w_idx,chans(b))'*Rbank(X_idx,X_idx,b)*wX(:,w_idx,chans(b)));
            Py(w_idx,b) = real(wY(:,w_idx,chans(b))'*Rbank(Y_idx,Y_idx,b)*wY(:,w_idx,chans(b)));
        end
    end
    keyboard;
    
end


