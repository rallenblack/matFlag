% Coherent Noise Word Lock
close all; clearvars;

% Add kernel codes to path
addpath ../kernel/

% setup file info
dir = '/lustre/projects/flag/';
proj_id = '/TMP';
session = '/BF/';

% scan time
tstamp = '2017_07_27_21:45:59';

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

% Extract data from FITS files
R = zeros(Nele,Nele,Nchan);
for i = 1:length(banks)
    filename = sprintf('%s/%s/%s%s%s.fits', dir, proj_id, session, tstamp, banks{i});
    % Check to see that file exists
    if exist(filename, 'file') ~= 0
        [Rtmp, dmjd, xid, info] = extract_covariances(filename);
        Ravg = mean(Rtmp, 4);
        R(:,:,chan_idx + 5*xid) = Ravg(1:Nele, 1:Nele, :);
    end
end

% Mask out first bins, LO bins, and last bins
R(:,:,[1:10, 248:252, 490:499]) = 0;

% compute delays relative to first element to determine max delay
ref_el = 24;
tmp_delta_n = compute_delay(R, freqs, fs, ref_el);
round(tmp_delta_n)