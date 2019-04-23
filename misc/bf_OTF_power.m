% Look at BF time-frequency in each beam
close all;
clearvars;

addpath ../kernel/
scan_table; % Found in kernel directory

% AGBT16B_400_11 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% session = AGBT16B_400_14; %AGBT16B_400_04;
% Calibrator

% scan_nums = [25, 27, 28]; % Sources: B1929, B1933, B1937
% B1937+21 -> pulsar period is 0.00155780656108493 seconds
% scan_nums = 85; % 28; 

% Project directory
% proj_ID = 'TGBT16A_508_01';
% Dir = sprintf('/lustre/gbtdata/%s/TMP/BF',proj_ID);
Dir = '/lustre/flag/TMP/BF/';

% Bank strings
banks = {'A', 'B', 'C', 'D',...
         'E', 'F', 'G', 'H',...
         'I', 'J', 'K', 'L',...
         'M', 'N', 'O', 'P',...
         'Q', 'R', 'S', 'T'};

% banks = {'B'};

% for i = 1:length(scan_nums)
% tstamp = session.scans{scan_nums(i)};
tstamp = '2019_03_10_21:46:49'; % '2019_03_01_20:27:28';

for bank_idx = 1:length(banks)
    bank_str = banks{bank_idx};
    fprintf('%s\n', bank_str);
    fits_filename = sprintf('%s/%s%s.fits', Dir, tstamp, bank_str);
    if ~exist(fits_filename, 'file')
        fprintf('Does not exist!\n');
        continue;
    end
    fprintf('Extracting...\n');
    
    [ B, xid ] = extract_bf_output( fits_filename );
    fprintf('Finished extracting...\n');
    
    if bank_idx == 1
        tmp_samp = size(B,4);
    end
    
    chans = [1:5, 101:105, 201:205, 301:305, 401:405] + xid*5;
%     if size(B,4) ~= tmp_samp
%         B_bad = zeros(size(B,1),size(B,2),size(B,3),tmp_samp);
%         B_bad(:,:,:,1:size(B,4)) = B;
%         Bout(:,:,chans,:) = B_bad;
    if size(B,4) >= tmp_samp && bank_idx > 1
        B_bad = zeros(size(B,1),size(B,2),size(B,3),tmp_samp);
        B_bad(:,:,:,1:size(B,4)) = B;
        Bout(:,:,chans,:) = B_bad(:,:,:,1:size(Bout,4));
    elseif size(B,4) <= tmp_samp && bank_idx > 1
        B_bad = zeros(size(B,1),size(B,2),size(B,3),tmp_samp);
        B_bad(:,:,:,1:size(B,4)) = B;
        Bout(:,:,chans,1:size(B_bad,4)) = B_bad;
    else
        Bout(:,:,chans,:) = B;
    end
end

int_length = 100;
Nsti = floor(size(Bout,4)/int_length);
Bint = zeros(size(Bout,1), size(Bout,2), size(Bout,3), Nsti);
for s = 1:Nsti
    Bint(:,:,:,s) = mean(Bout(:,:,:,int_length*(s-1)+1:s*int_length),4);
end
%     Bint(:,:,[1:75, 90, 122, 138, 154, 170, 186, 202, 218, 234, 250, 425:500],:) = NaN;
Bint(:,:,250,:) = NaN;
LO_freq = 1450;
fr = ((-249:250)*303.75e-3) + LO_freq;
% figure(1);
for b = 1:7
    figure(b);
%     imagesc(squeeze(Bint(b,1,:,1:100)));
    imagesc(squeeze(10*log10(abs(Bint(b,1,:,1:100)))));
    colorbar;
    title(['Source, OTF tests, Beam ' num2str(b)]);
    xlabel('Integrated STI');
    ylabel('Frequency bins');
    %         figure(b+7);
    %         subplot(4,2,b);
    % %         plot(fr, squeeze(abs(mean(Bint(b,1,:,:),4))));
    %         plot(fr, squeeze(abs(Bint(b,1,:,1))));
    %         grid on;
    %         title(['Source, B0329+54, (4) Beam ' num2str(b)]);
    %         xlabel('Frequency (MHz)');
    %         ylabel('Power (arb. units)');
end
for b = 1:1
    figure(15);
    plot(fr, squeeze(10*log10(abs(mean(Bint(b,1,:,1:100),4)))));
%     plot(1:25, squeeze(10*log10(abs(mean(Bint(b,1,:,:),4)))));
%     plot(fr, squeeze(10*log10(abs(mean(Bint(b,1,:,:),4)))));
    %         plot(fr, squeeze(abs(Bint(b,1,:,1))));
    hold on;
    grid on;
    title('OTF test (Single beam & polarization)');
    xlabel('Frequency (MHz)');
    ylabel('Power (arb. units)');
end
hold off;
% end



