% Aggregate weights and plot beam patterns
close all;
clearvars;

addpath ../kernel/
scan_table; % Found in kernel directory

tic;

% % AGBT16B_400_04 Grid %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
session = AGBT16B_400_04;
% Sources: B1929, B1933, B1937
on_scans = [25, 27, 28];

on_tstamp = session.scans(on_scans);
% bad_freqs = session.bad_freqs;

proj_str = session.session_name;
save_dir = sprintf('%s/%s/BF', data_root, proj_str);
out_dir = sprintf('%s/mat', save_dir);
% mkdir(save_dir, out_dir);

banks = 'A';

filename = sprintf('%s/%s%s.fits', save_dir, on_tstamp{2}, banks);

b = extract_bf_output(filename);

N_bin = size(b,3); % 25
N_pol = size(b,2); % 4  % Order: XX*, YY*, real(XY*), and imag(XY*).
idx = 0;
for i = 1:1 % N_bin
    for k = 1:1 % Order: XX*, YY*, real(XY*), and imag(XY*).
        idx = idx+1;
        figure(idx);
        imagesc(squeeze(10*log10(abs(b(:,k,i,:)))).'); % Order: beam, pol, bin, and sti.
        if k == 1
            title(['X Frequency bin ' num2str(i)]);
        elseif k == 2
            title(['Y Frequency bin ' num2str(i)]);
        elseif k == 3
            title(['Real XY Frequency bin ' num2str(i)]);
        elseif k == 4
            title(['Imaginary XY Frequency bin ' num2str(i)]);
        end
        xlabel('Beam Index');
        ylabel('STI Index');
    end
end


