% Coherent Noise Word Lock
close all; clearvars;

% Add kernel codes to path
addpath ../kernel/

% Saved residuals
res_file = 'residuals1.mat';

% setup file info
dir = '/lustre/projects/flag/';
proj_id = '/TMP';
session = '/BF/';

% scan time
tstamp = '2018_02_07_13:01:36'; % '2017_07_27_21:43:51';

% system parameters
Nele = 40;                             % Antenna Elements
Nchan = 500;                           % Frequency bins
LO = 1450e6;                           % LO frequency
fs = 155.52e6;                         % Sample frequency
freqs = ((0:1:499) - 249)*fs/512 + LO; % Frequency bin centers

banks = {'A', 'B', 'C', 'D',...
    'E', 'F', 'G', 'H',...
    'I', 'J', 'K', 'L',...
    'M', 'N', 'O', 'P',...
    'Q', 'R', 'S', 'T'};
chan_idx = [1:5, 101:105, 201:205, 301:305, 401:405];

% Check to see if residual file is there
% If not, run this and save the residual file for subsequent locks
if exist(res_file, 'file')
    RES = load(res_file);
    %factors = RES.factors;
    factors = zeros(Nele, 1).';
else
    factors = zeros(Nele, 1).';
end

% Extract data from FITS files
R = zeros(Nele,Nele,Nchan);
for i = 1:length(banks)
    filename = sprintf('%s/%s/%s%s%s.fits', dir, proj_id, session, tstamp, banks{i});
    disp(filename);
    % Check to see that file exists
    if exist(filename, 'file') ~= 0
        [Rtmp, dmjd, xid, info] = extract_covariances(filename);
        Ravg = mean(Rtmp, 4);
        R(:,:,chan_idx + 5*xid) = Ravg(1:Nele, 1:Nele, :);
    end
end

% Force conjugate symmetry
%for b = 1:Nchan
%    R(:,:,b) = (R(:,:,b) + R(:,:,b)')/2;
%end

% Mask out first bins, LO bins, and last bins
R(:,:,[1:10, 248:252, 490:499]) = 0;

% compute delays relative to first element to determine max delay
ref_el = 1;
[tmp_delta_n, residual1] = compute_delay(R, freqs, fs, ref_el);

% determine max delay
[min_delay, ref_el] = min(tmp_delta_n);

% recompute with new reference
[delta_n, residual2] = compute_delay(R, freqs, fs, ref_el);

% round delays to pass to ROACH
%delta_n_abs = round(delta_n - min(delta_n));
delta_n_abs = round(delta_n);
%factors = (delta_n - factors) - delta_n_abs;
disp(delta_n_abs);
fprintf('Ref Element = %d\n', ref_el);

% Save factors if not already saved
if ~exist(res_file, 'file')
    save(res_file, 'factors');
end


% write delays to file
outdir = '/home/groups/flag/scripts/matFlag/word_lock/output';
ext = '.dat';
filename = [outdir, '/offset_',tstamp, ext];

fid = fopen(filename, 'wb');
fwrite(fid, delta_n_abs, 'uint8');
fclose(fid);
