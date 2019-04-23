close all;
clearvars;

addpath ../kernel/
cold_tstamp = '';
hot_tstamp = '2019_02_08_21:59:26'; %'2018_07_16_21:53:46'; % '2018_07_13_19:52:04'; % '2018_07_12_22:42:07'; % '2018_01_24_03:57:24';
Dir = '/lustre/flag/TMP/BF/';
weight_dir = '/home/groups/flag/weight_files/';


LO_freq = 1450;
freqs = ((-249:250)*303.24e-3)+LO_freq;

banks = {'A', 'B', 'C', 'D'};

% banks = {'A', 'B', 'C', 'D',...
%          'E', 'F', 'G', 'H',...
%          'I', 'J', 'K', 'L',...
%          'M', 'N', 'O', 'P',...
%          'Q', 'R', 'S', 'T'};

for idx = 1:length(banks)
    bank = banks{idx};
    fprintf('%s', bank);
%     cold_filename = sprintf('%s/%s%s.fits', Dir, cold_tstamp, bank);
    hot_filename  = sprintf('%s/%s%s.fits', Dir, hot_tstamp, bank);
    
%     w_file = sprintf('%s/w_13_%s.bin', weight_dir, bank);
% 
%     wei = fopen(w_file,'rb');
%     
%     w = fread(wei, 'single');
%     
%     wei_filename = sprintf('%s/weights%s.mat',weight_dir, bank);
%     save(wei_filename, 'w');


%     % Get COLD data
%     if exist(cold_filename)
%         [Rcold, ~, xid, ~] = extract_covariances(cold_filename);
%     else
%         continue;
%     end
    
    % Get HOT data
    if exist(hot_filename)
        [Rhot,  ~, xid, ~] = extract_covariances(hot_filename);
    else
        continue;
    end

    chans = [1:5, 101:105, 201:205, 301:305, 401:405] + 5*xid;
    
    R(:,:,chans) = squeeze(mean(Rhot,4));

end

% for nb = 1:size(R,3)
% % R3(nb) = mean(diag(R(:,:,nb)),1);
% R3(:,nb) = diag(R(:,:,nb));
% end
% 
% fr = (-249:250)*303.75e-3 +1450;
% 
% R3(:,250) = NaN;
% 
% figure(1);
% plot(10*log10(abs(R3(20,:))));
% grid on;
% title('Single element power (OTF tests)');
% xlabel('Frequency (MHz)');
% ylabel('dB Power (arb. units)');
% 
% figure(2);
% imagesc(squeeze(10*log10(abs(mean(R(:,:,:),3)))));
% title('Covariance matrix (Integrated across bins)');
% colorbar();