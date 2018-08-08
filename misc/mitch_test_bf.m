% Look at BF total power in each beam
close all;
clearvars;

addpath ../kernel/
scan_table; % Found in kernel directory

% Project directory
proj_str = 'TMP';
save_dir = sprintf('%s/%s/BF', data_root, proj_str);

scan_nums = 1;
for i = 1:length(scan_nums)
    tstamp = '2017_08_05_17:36:04';
    fits_filename = sprintf('%s/%sA.fits', save_dir, tstamp);
    
    [ B, dmjd, xid ] = extract_bf_output( fits_filename );
    
    for t = 1:size(B,4)
        fprintf('Time = %d\n', t);
        for b = 1:7
            fprintf('Beam %d: %f\n', b, real(mean(B(b,1,:,t),3)));
        end
        keyboard;
    end
    fprintf('\n');
end



