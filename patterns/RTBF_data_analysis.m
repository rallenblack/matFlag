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

% filename = sprintf('%s/%s%s.fits', save_dir, on_tstamp{2}, banks);
% filename = '/lustre/projects/flag/TMP/BF/2017_08_03_01:06:42A.fits';
% filename = '/lustre/projects/flag/AGBT16B_400_14/BF/2017_08_06_17:33:40G.fits';
% filename = '/lustre/projects/flag/TMP/BF/2017_09_12_19:06:33A.fits';
% filename = '/lustre/projects/flag/TMP/BF/2017_12_01_22:50:45B.fits';
% filename = '/lustre/projects/flag/AGBT17B_221_01/BF/2018_01_28_11:48:48A.fits';
filename = '/lustre/flag/TMP/BF/2018_08_07_17:15:41A.fits';

b_out = extract_bf_output(filename);

% % Reshape data in order expected from the output of real-time
% % beamformer
% b_out = reshape(b_tmp, Nblocks, Nbeam, Npol, Nbin, Nsti);

N_sti = size(b_out,4); % 100
N_bin = size(b_out,3); % 25
N_pol = size(b_out,2); % 4  % Order: XX*, YY*, real(XY*), and imag(XY*).
N_beam = size(b_out,1); % 7
N_block = 1; % size(b_out,1);
idx = 0;

% beam = zeros(N_beam ,N_pol, N_bin, N_block*N_sti);
% for nb = 1:N_block
%     beam(:,:,:,(N_sti*(nb-1)+1):(N_sti*nb)) = b_out(nb,:,:,:,:);
% end
beam = b_out;

% L = size(beam,4);
% Fs = 
figure(1);
for i = 1:N_bin
    for k = 1:1 % Order: XX*, YY*, real(XY*), and imag(XY*).
        for nbeam = 2:2 % N_beam
            Y1 = fft(fftshift(beam(nbeam,k,i,:)));
        end
        P1 = abs(Y1);
        L = size(P1,4);
%         fq = Fs*(0:(L/2))/L;
        fq = 0:(7.59e3)/(L-1):7.59e3;
        subplot(5,5,i);
        plot(fq,10*log10(squeeze(P1)).'); % Order: block, beam, pol, bin, and sti.
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

figure(2);
for i = 1:N_bin
    for k = 2:2 % Order: XX*, YY*, real(XY*), and imag(XY*).
        for nbeam = 1:1 % N_beam
            Y1 = fft(fftshift(beam(nbeam,k,i,:)));
        end
        P1 = abs(Y1(:,:,:,:));
        L = size(P1,4);
%         fq = Fs*(0:(L/2))/L;
        fq = 0:(7.59e3)/(L-1):7.59e3;
        subplot(5,5,i);
        plot(fq,10*log10(squeeze(P1)).'); % Order: block, beam, pol, bin, and sti.
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


figure(3);
for i = 1:1 % N_beam
    for k = 1:1 % Order: XX*, YY*, real(XY*), and imag(XY*).
        for ii = 1:N_bin
            subplot(5,5,ii)
            plot(10*log10(squeeze(beam(i,k,ii,:))).'); % Order: beam, pol, bin, and sti.
            grid on;
            if k == 1
                title(['X Frequency bin ' num2str(ii)]);
            elseif k == 2
                title(['Y Frequency bin ' num2str(ii)]);
            elseif k == 3
                title(['Real XY Frequency bin ' num2str(ii)]);
            elseif k == 4
                title(['Imaginary XY Frequency bin ' num2str(ii)]);
            end
            ylabel('Power');
            xlabel('STI Index');
        end
    end
end

figure(4); % pol x beam x sti x freq
for i = 1:1 % N_beam
    for k = 2:2 % Order: XX*, YY*, real(XY*), and imag(XY*).
        for ii = 1:N_bin
            subplot(5,5,ii)
            plot(10*log10(squeeze(beam(i,k,ii,:))).'); % Order: beam, pol, bin, and sti.
            grid on;
            if k == 1
                title(['X Frequency bin ' num2str(ii)]);
            elseif k == 2
                title(['Y Frequency bin ' num2str(ii)]);
            elseif k == 3
                title(['Real XY Frequency bin ' num2str(ii)]);
            elseif k == 4
                title(['Imaginary XY Frequency bin ' num2str(ii)]);
            end
            ylabel('Power');
            xlabel('STI Index');
        end
    end
end

% beam(:,:,[1:5,21:25],:) = NaN;
figure(5);
for i = 2:2 % N_beam
    for k = 1:1 % Order: XX*, YY*, real(XY*), and imag(XY*).
        imagesc(squeeze((abs(beam(i,k,:,1:100))))); % Order: beam, pol, bin, and sti.
        title(['Beam ' num2str(i)]);
        ylabel('Frequency Bin Index');
        xlabel('STI Index');
        colorbar;
    end
end


