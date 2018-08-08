% Simple script that extracts the covariance matrices for the entire band
tic;

% close all;
clearvars;

% Get scan information and set path
addpath ../kernel/
scan_table; % Found in kernel directory
source_table; % Found in kernel directory

% Specify session information
session = AGBT16B_400_13;
on_scan = 102;
off_scan = 101;

% Get element mappings
good_idx_X = session.goodX;
good_idx_Y = session.goodY;

% Get frequency masks
bad_freqs = session.bad_freqs;

% Project directory
proj_str = session.session_name;
save_dir = sprintf('%s/%s/BF', data_root, proj_str);

% Antenna directory
ant_dir = sprintf('%s/%s/Antenna', meta_root, proj_str);

% constants
Nbins = 500;

%% ON %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Get timestamps
on_tstamp = session.scans{on_scan};
fprintf('    ON:  Time stamp: %s\n', on_tstamp);

% Get correlation matrix
[Ron, az, el, ~] = aggregate_banks_rb(save_dir, ant_dir, on_tstamp, 1, -1);

%% OFF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
off_tstamp = session.scans{off_scan};
fprintf('    OFF: Time stamp: %s\n', off_tstamp);

% Get correlation matrix
[Roff, ~, ~, ~] = aggregate_banks_rb(save_dir, ant_dir, off_tstamp, 1, -1);

% Compute weights
wX = single_beam(Ron, Roff, Nbins, good_idx_X, bad_freqs);
wY = single_beam(Ron, Roff, Nbins, good_idx_Y, bad_freqs);


%% Format weights into RTBF file
N_beam = 7;
N_ele = 64;
N_bin_tot = 500;
N_bin = 25;
N_pol = 2;
weights = zeros(N_ele, N_bin_tot, N_beam, N_pol);
for i = 5:5
    weights(:,:,i,1) = wX;
    weights(:,:,i,2) = wY;
    %weights(:,:,5,1) = 1;
end

banks = {'A', 'B', 'C', 'D',...
    'E', 'F', 'G', 'H',...
    'I', 'J', 'K', 'L',...
    'M', 'N', 'O', 'P',...
    'Q', 'R', 'S', 'T'};

interleaved_w = zeros(2*N_ele*N_bin*N_beam*N_pol,1);
weight_dir = sprintf('%s/%s/BF', data_root, proj_str);
chan_idx = [1:5, 101:105, 201:205, 301:305, 401:405];

for b = 1:length(banks)
    % Get bank name
    bank_name = banks{b};

    % Extract channels for bank
    w1 = weights(:,chan_idx+5*(b-1),:,:);
    
    % Reshape for file format
    w2 = reshape(w1, N_ele*N_bin, N_beam*N_pol);
    w_real = real(w2(:));
    w_imag = imag(w2(:));
    interleaved_w(1:2:end) = w_real(:);
    interleaved_w(2:2:end) = w_imag(:);
    
    % Get filename
    weight_file = sprintf('%s/w_13_%s.bin', weight_dir, bank_name);
    weight_file = strrep(weight_file, ':', '_');
    
    % Create metadata for weight file
    offsets_el = el;
    offsets_az = az;
    offsets = [offsets_el; offsets_az; offsets_el; offsets_az; offsets_el; offsets_az; offsets_el; offsets_az; offsets_el; offsets_az; offsets_el; offsets_az; offsets_el; offsets_az];
    offsets = offsets(:);
    cal_filename = sprintf('%s%s.fits',on_tstamp, banks{b});
    to_skip1 = 64 - length(cal_filename);
    algorithm_name = 'Max Signal-to-Noise Ratio';
    to_skip2 = 64 - length(algorithm_name);
    xid = b-1;
    
    % Write to binary file
    WID = fopen(weight_file,'wb');
    if WID == -1
        error('Author:Function:OpenFile', 'Cannot open file: %s', weight_file);
    end
    
    % Write payload
    fwrite(WID, single(interleaved_w), 'single');
    
    % Write metadata
    fwrite(WID,single(offsets),'float');
    fwrite(WID,cal_filename, 'char*1');
    if to_skip1 > 0
        fwrite(WID, char(zeros(1,to_skip1)));
    end
    fwrite(WID,algorithm_name, 'char*1');
    if to_skip2 > 0
        fwrite(WID, char(zeros(1,to_skip2)));
    end
    fwrite(WID, uint64(xid), 'uint64');
    fclose(WID);
    
    fprintf('Saved to %s\n', weight_file);
end

toc;

