% Coherent Noise Word Lock
close all; clearvars;

% Add kernel codes to path
addpath ../kernel/

% setup file info
dir = '/lustre/projects/flag/';
sub_dir1 = '/TMP/BF/';
sub_dir2 = '/word_lock_cov/';

% scan time
tstamp = '2017_07_25_22:29:55';

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
    filename = sprintf('%s/%s/%s%s.fits', dir, sub_dir1, tstamp, banks{i});
    % Check to see that file exists
    if exist(filename, 'file') ~= 0
        [Rtmp, dmjd, xid, info] = extract_covariances(filename);
        Ravg = mean(Rtmp, 4);
        R(:,:,chan_idx + 5*xid) = Ravg(1:Nele, 1:Nele, :);
    end
end

% Mask out first bins, LO bins, and last bins
R(:,:,[1:10, 248:252, 490:499]) = 0;

for ref_ele = 1:40
    
    % compute magnitude for first row of correlation matrix
    mag = abs(squeeze(R(1,ref_ele,:)));
    
    figure(1);
    subplot(2,1,1);
    plot(freqs/1e6, 20*log10(mag));
    title(sprintf('Cross-Correlation Magnitude Squared Between Elements 1/%d', ref_ele))
    xlabel('Frequency (MHz)');
    ylabel('Power (dB, arb. units)');
    
    % compute phase for first row of correlation matrix
    phi = angle(squeeze(R(1,ref_ele,:)));
    phi(mag == 0) = NaN;

    subplot(2,1,2);
    plot(freqs/1e6, phi);
    title(sprintf('Relative Phase Between Elements 1/%d', ref_ele));
    xlabel('Frequency (MHz)');
    ylabel('Phase (rad)');

    % determine how much phase to add to unwrap
    first_diff = phi(1:end - 1) - phi(2:end);
    neg_idx = find(first_diff < -pi);
    pos_idx = find(first_diff > pi);
    unwraps = zeros(size(phi));
    for i = 1:length(neg_idx)
        unwraps(neg_idx(i)+1:end) = unwraps(neg_idx(i)+1:end) - 2*pi;
    end
    for i = 1:length(pos_idx)
        unwraps(pos_idx(i)+1:end) = unwraps(pos_idx(i)+1:end) + 2*pi;
    end
    
    % unwrap
    phi = phi + unwraps;
    
    % construct frequency vector to solve for ramps
    good_idx = find(~isnan(phi));
    F = [ones(length(good_idx),1), freqs(good_idx).'];
    phi1 = phi(good_idx);

    % solve for ramps and errors
    a_b = F\phi1;
    residual = norm(F*a_b - phi1).^2;
    
    % show phase ramps
    figure(2); hold on; plot(freqs/1e6, a_b(1) + a_b(2)*freqs);

    % compute delays from ramps
    delta_n(ref_ele) = a_b(2)/(2*pi)*fs;
end

% round delays to add to ROACH
delta_n_abs = round(delta_n - min(delta_n));
disp(delta_n(1:8));























