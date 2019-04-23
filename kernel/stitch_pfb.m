clearvars;

idx = 1:160;
idx1 = reshape(idx, [5,32]);
idx2 = idx1';
stitch_idx=reshape(idx2,[160,1]);

for k = 1:5
    stitch_idx((k-1)*32+1:k*32) = flip(fftshift(stitch_idx((k-1)*32+1:k*32)));
end

Rtot = [];

el = 1;
%tstamp = '2017_08_04_15:09:11';
tstamp = '2019_03_14_11:14:22';
%dir = '/lustre/projects/flag/AGBT16B_400_13/BF/'; %/TMP/BF/
dir = '/users/mburnett/tmp/';
fname = [dir,tstamp];

int_idx_start = 1;

%%
disp('A');
[R, ~, xid, info_table] = extract_pfb_covariances([fname, 'A.fits']);
Rtmp = squeeze(mean(R(el,el,stitch_idx,int_idx_start:end),4))';
Rtot = [Rtot,Rtmp];
disp('B');
[R, ~, xid, info_table] = extract_pfb_covariances([fname, 'B.fits']);
Rtmp = squeeze(mean(R(el,el,stitch_idx,int_idx_start:end),4))';
Rtot = [Rtot,Rtmp];
disp('C');
[R, ~, xid, info_table] = extract_pfb_covariances([fname, 'C.fits']);
Rtmp = squeeze(mean(R(el,el,stitch_idx,int_idx_start:end),4))';
Rtot = [Rtot,Rtmp];
disp('D');
[R, ~, xid, info_table] = extract_pfb_covariances([fname, 'D.fits']);
Rtmp = squeeze(mean(R(el,el,stitch_idx,int_idx_start:end),4))';
Rtot = [Rtot,Rtmp];
disp('E');
[R, ~, xid, info_table] = extract_pfb_covariances([fname, 'E.fits']);
Rtmp = squeeze(mean(R(el,el,stitch_idx,int_idx_start:end),4))';
Rtot = [Rtot,Rtmp];
disp('F');
[R, ~, xid, info_table] = extract_pfb_covariances([fname, 'F.fits']);
Rtmp = squeeze(mean(R(el,el,stitch_idx,int_idx_start:end),4))';
Rtot = [Rtot,Rtmp];
disp('G');
[R, ~, xid, info_table] = extract_pfb_covariances([fname, 'G.fits']);
Rtmp = squeeze(mean(R(el,el,stitch_idx,int_idx_start:end),4))';
Rtot = [Rtot,Rtmp];
disp('H');
[R, ~, xid, info_table] = extract_pfb_covariances([fname, 'H.fits']);
Rtmp = squeeze(mean(R(el,el,stitch_idx,int_idx_start:end),4))';
Rtot = [Rtot,Rtmp];
disp('I');
[R, ~, xid, info_table] = extract_pfb_covariances([fname, 'I.fits']);
Rtmp = squeeze(mean(R(el,el,stitch_idx,int_idx_start:end),4))';
Rtot = [Rtot,Rtmp];
disp('J');
[R, ~, xid, info_table] = extract_pfb_covariances([fname, 'J.fits']);
Rtmp = squeeze(mean(R(el,el,stitch_idx,int_idx_start:end),4))';
Rtot = [Rtot,Rtmp];
disp('K');
[R, ~, xid, info_table] = extract_pfb_covariances([fname, 'K.fits']);
Rtmp = squeeze(mean(R(el,el,stitch_idx,int_idx_start:end),4))';
Rtot = [Rtot,Rtmp];
%%
disp('L');
[R, ~, xid, info_table] = extract_pfb_covariances([fname, 'L.fits']);
Rtmp = squeeze(mean(R(el,el,stitch_idx,int_idx_start:end),4))';
Rtot = [Rtot, Rtmp];
disp('M');
[R, ~, xid, info_table] = extract_pfb_covariances([fname, 'M.fits']);
Rtmp = squeeze(mean(R(el,el,stitch_idx,int_idx_start:end),4))';
Rtot = [Rtot, Rtmp];
disp('N');
[R, ~, xid, info_table] = extract_pfb_covariances([fname, 'N.fits']);
Rtmp = squeeze(mean(R(el,el,stitch_idx,int_idx_start:end),4))';
Rtot = [Rtot, Rtmp];
disp('O');
[R, ~, xid, info_table] = extract_pfb_covariances([fname, 'O.fits']);
Rtmp = squeeze(mean(R(el,el,stitch_idx,int_idx_start:end),4))';
Rtot = [Rtot, Rtmp];
disp('P');
[R, ~, xid, info_table] = extract_pfb_covariances([fname, 'P.fits']);
Rtmp = squeeze(mean(R(el,el,stitch_idx,int_idx_start:end),4))';
Rtot = [Rtot, Rtmp];
disp('Q');
[R, ~, xid, info_table] = extract_pfb_covariances([fname, 'Q.fits']);
Rtmp = squeeze(mean(R(el,el,stitch_idx,int_idx_start:end),4))';
Rtot = [Rtot, Rtmp];
disp('R');
[R, ~, xid, info_table] = extract_pfb_covariances([fname, 'R.fits']);
Rtmp = squeeze(mean(R(el,el,stitch_idx,int_idx_start:end),4))';
Rtot = [Rtot, Rtmp];
disp('S');
[R, ~, xid, info_table] = extract_pfb_covariances([fname, 'S.fits']);
Rtmp = squeeze(mean(R(el,el,stitch_idx,int_idx_start:end),4))';
Rtot = [Rtot, Rtmp];
disp('T');
[R, ~, xid, info_table] = extract_pfb_covariances([fname, 'T.fits']);
Rtmp = squeeze(mean(R(el,el,stitch_idx,int_idx_start:end),4))';
Rtot = [Rtot, Rtmp];
%

%figure(15); plot(0:length(Rtot)-1, 10*log10(abs(Rtot))); grid on; hold on;
%%
chansel = 1;
LO = 1450e6;
f_start = LO - 249.5*303.75e3 + 303.75e3*100*chansel;
df = 303.75e3/32;
numchannels = length(Rtot);
faxis = (0:numchannels-1)*df + f_start;

figure(25); plot(faxis/1e6, 10*log10(abs(Rtot))); grid on; hold on;
% figure(23); plot(0:numchannels-1, 10*log10(abs(Rtot))); grid on; hold on;
xlabel('Frequency (MHz)');
ylabel('Power (dB, arb. units');
title('HI Mode Power Spectrum');

% f_end = 1450e6-coarse_BW*(255-160);
% numXID = 8;
% 
% faxis = f_start:fine_BW:f_end-fine_BW;
% 
% figure(6);
% plot(faxis/1e6, 10*log10(abs(Rtot))); grid on;
% xlim([min(faxis), max(faxis)]/1e6);
% grid minor;
% ylabel('Magnitude (dB)');
% xlabel('Frequency (MHz)');









