% Look at BF time-frequency in each beam
close all;
clearvars;

addpath ../kernel/
scan_table; % Found in kernel directory

% Project directory
% Dir = '/users/jnybo/Output';     % '/lustre/flag/TMP/BF/';
Dir = '/lustre/flag/TGBT16A_508_01/TMP/BF/';

% Bank strings
% banks = {'A', 'B', 'C', 'D',...
%          'E', 'F', 'G', 'H',...
%          'I', 'J', 'K', 'L',...
%          'M', 'N', 'O', 'P',...
%          'Q', 'R', 'S', 'T'};
banks = {'A', 'B', 'C', 'D'};

Npol = 4; % X self-polarized, Y self-polarized, XY polarized (real), XY polarized (imaginary)
Nbeam = 7;
Nbin = 25;
%     Nbin = 20; % packet_gen scalloping fix
Nsti = 100;
outSize = Nbeam*Npol*Nbin*Nsti;

beam_idx = 'beamformer_';
% Bout = zeros(7,4,100,1100); % The last dimension was chosen by looking at the size of the data.
Bout = [];
xid = 0;
B = [];

for bank_idx = 1:length(banks)
    bank_str = banks{bank_idx};
    fprintf('%s\n', bank_str);
    filename = sprintf('%s/%s%s_mcnt_0.out', Dir,  beam_idx, bank_str);

    FILE = fopen(filename, 'r');
    [B_binary, count] = fread(FILE, 'single');
    fclose(FILE);
    
    if ~exist(filename, 'file')
        fprintf('Does not exist!\n');
        continue;
    end
    fprintf('Extracting...\n');
    
%     [ B, xid ] = extract_bf_output( fits_filename );
    
    Nrows = size(B_binary, 1);
    
    for r = 1:1%Nrows
        B(:,:,:,Nsti*(r-1)+1:Nsti*r) = reshape(B_binary(1:outSize,r), Nbeam, Npol, Nbin, Nsti);
    end
    
    fprintf('Finished extracting...\n');
    
    if bank_idx == 1
        tmp_samp = size(B,4);
    end
    
    chans = 5*xid + [1:5, 101:105, 201:205, 301:305, 401:405];
%     chans = [1:25] + xid*25;
%     chans = 5*xid + [1:5, 101:105, 201:205, 301:305];  %  [1:20] + xid*20; % packet_gen scalloping fix
    
    if size(B,4) ~= tmp_samp
        B_bad = zeros(size(B,1),size(B,2),size(B,3),tmp_samp);
        B_bad(:,:,:,1:size(B,4)) = B;
        Bout(:,:,chans,:) = B_bad;
    else
        Bout(:,:,chans,:) = B;
    end
    
    xid = xid+1;
end

% int_length = 100;
int_length = 100; % packet_gen
Nsti = floor(size(Bout,4)/int_length);
Bint = zeros(size(Bout,1), size(Bout,2), size(Bout,3), Nsti);
for s = 1:Nsti
    Bint(:,:,:,s) = mean(Bout(:,:,:,int_length*(s-1)+1:s*int_length),4);
end
%     Bint(:,:,[1:75, 90, 122, 138, 154, 170, 186, 202, 218, 234, 250, 425:500],:) = NaN;
Bint(:,:,250,:) = NaN;
% Bint(:,:,200,:) = NaN; % packet_gen scalloping fix
LO_freq = 1450;
% LO_freq = 1300;
fr = ((-249:250)*303.75e-3) + LO_freq;
figure(1);
for b = 1:7
    figure(b);
%     imagesc(squeeze(Bint(b,1,:,:)));
     imagesc(squeeze((Bout(b,1,:,:))));
%    imagesc(squeeze((Bout(b,1,[11:15,111:115,211:215,311:315,411:415],:))));
    colorbar;
    title(['Simulated Source, Beam ' num2str(b)]);
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
% for b = 1:1
%     figure(15);
% %     plot(fr, squeeze(abs(mean(Bint(b,1,:,:),4))));
%     plot(squeeze((abs(mean(Bint(b,1,:,:),4)))));
%     %         plot(fr, squeeze(abs(Bint(b,1,:,1))));
%     hold on;
%     grid on;
%     title('Simulated Source');
%     xlabel('Frequency (MHz)');
%     ylabel('Power (arb. units)');
% end
hold off;
% end



