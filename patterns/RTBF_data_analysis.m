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

banks = 'A'; % F is a small enough bank since it stalled during observation

filename = sprintf('%s/%s%s.fits', save_dir, on_tstamp{1}, banks);

b = extract_bf_output(filename);

N_sti = size(b,5); % 100
N_bin = size(b,4); % 25
N_pol = size(b,3); % 4  % Order: XX*, YY*, real(XY*), and imag(XY*).
N_beam = size(b,2); % 7
N_block = size(b,1);
idx = 0;

beam = zeros(N_beam ,N_pol, N_bin, N_block*N_sti);
for nb = 1:N_block
    beam(:,:,:,(N_sti*(nb-1)+1):(N_sti*nb)) = b(nb,:,:,:,:);
end

% L = size(beam,4);
% Fs = 
for i = 11:11 % N_bin
    for k = 1:1 % Order: XX*, YY*, real(XY*), and imag(XY*).
        for nbeam = 1:N_beam
            Y1 = fft(fftshift(beam(nbeam,k,i,:)));
        end
        P1 = abs(Y1(:,:,:,:));
        L = size(P1,4);
%         fq = Fs*(0:(L/2))/L;
        fq = 0:(7.59e3)/(L-1):7.59e3;
        idx = idx+1;
        figure(idx);
        plot(fq,squeeze(P1).'); % Order: block, beam, pol, bin, and sti.
        grid on;
        if k == 1
            title(['X Frequency bin ' num2str(i)]);
        elseif k == 2
            title(['Y Frequency bin ' num2str(i)]);
        elseif k == 3
            title(['Real XY Frequency bin ' num2str(i)]);
        elseif k == 4
            title(['Imaginary XY Frequency bin ' num2str(i)]);
        end
        ylabel('Power');
        xlabel('Frequncy (Hz)');
    end
end

for i = 1:1 % N_beam
    for k = 1:1 % Order: XX*, YY*, real(XY*), and imag(XY*).
        idx = idx+1;
        figure(idx);
        plot(squeeze(abs(beam(i,k,:,:))).'); % Order: beam, pol, bin, and sti.
        grid on;
        title(['Beam ' num2str(i)]);
        ylabel('Power');
        xlabel('STI Index');
    end
end

for i = 1:1 % N_beam
    for k = 1:1 % Order: XX*, YY*, real(XY*), and imag(XY*).
        idx = idx+1;
        figure(idx);
        imagesc(squeeze(10*log10(abs(beam(i,k,:,:))))); % Order: beam, pol, bin, and sti.
        title(['Beam ' num2str(i)]);
        ylabel('Frequency Bin Index');
        xlabel('STI Index');
    end
end


