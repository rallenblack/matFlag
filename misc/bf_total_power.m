% Look at BF total power in each beam
close all;
clearvars;

addpath ../kernel/
scan_table; % Found in kernel directory

% AGBT16B_400_11 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
session = AGBT16B_400_14;
% Calibrator
scan_nums = 78;

% Project directory
proj_str = session.session_name;
save_dir = sprintf('%s/%s/BF', data_root, proj_str);

for i = 1:length(scan_nums)
    tstamp = session.scans{scan_nums(i)};
    fits_filename = sprintf('%s/%sA.fits', save_dir, tstamp);
    
    [ B, dmjd, xid ] = extract_bf_output( fits_filename );
    
    for b = 1:7
        fprintf('Beam %d: %f\n', b, 10*log10(real(mean(mean(B(b,1,:,:),3),4))));
    end
    fprintf('\n');
end



