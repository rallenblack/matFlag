close all;
clearvars;

% Add kernel codes to path
addpath ../kernel/

dir = '/lustre/projects/flag/';
sub_dir1 = '/TMP/BF/';
sub_dir2 = '/word_lock_cov/';

file_array = {'2017_07_21_15:23:00A',...
              '2017_07_21_15:24:43G',...
              '2017_07_21_15:25:53B',...
              '2017_07_21_15:26:41B',...
              '2017_07_21_15:27:30E'};
% file_array = {'2017_07_21_15:55:29A',...
%               '2017_07_21_15:55:55G',...
%               '2017_07_21_15:56:22B',...
%               '2017_07_21_15:56:46B',...
%               '2017_07_21_15:57:11E'};
% file_array = {'2017_07_21_16:06:16A',...
%               '2017_07_21_16:06:57G',...
%               '2017_07_21_16:07:40B',...
%               '2017_07_21_16:08:10B',...
%               '2017_07_21_16:08:42E'};
% file_array = {'2017_07_21_16:14:35A',...
%               '2017_07_21_16:15:06G',...
%               '2017_07_21_16:15:32B',...
%               '2017_07_21_16:16:02B',...
%               '2017_07_21_16:16:26E'};
file_array = {'2017_07_21_16:34:57A',...
              '2017_07_21_16:35:29G',...
              '2017_07_21_16:36:05B',...
              '2017_07_21_16:38:02B',...
              '2017_07_21_16:38:28E'};
% file_array = {'2017_07_21_16:49:41A',...
%               '2017_07_21_16:50:17G',...
%               '2017_07_21_16:50:42B',...
%               '2017_07_21_16:51:06B',...
%               '2017_07_21_16:51:31E'};
% file_array = {'2017_07_21_15:29:33A',...
%               '2017_07_21_15:29:33G',...
%               '2017_07_21_15:29:33B',...
%               '2017_07_21_15:29:33B',...
%               '2017_07_21_15:29:33E'};



Ntone = length(file_array); % Number of tones

% Extract covariance
for i = 1:Ntone
    filename = sprintf('%s/%s/%s.fits', dir, sub_dir1, file_array{i});
    mat_file = sprintf('%s/%s/%s.mat', dir, sub_dir2, file_array{i});
    [Rtmp, dmjd, xid, info] = extract_covariances(filename);
    R(:,:,:,:,i) = Rtmp; % ele x ele x bin x time x tone
    save(mat_file, 'Rtmp');
end

Nele = size(R,1); % Number of elements
Nbin = size(R,3); % Number of frequency bins

r_tones = zeros(Ntone,Nele); % Array of 1st row of covariance matrix used with 3 tones
phi = zeros(Ntone,Nele); % Phase associated with r_tones
LO = 1450e6; % LO frequency
fs = 155.52e6; % Sample frequency
tone_freq = [1405.96, 1415.07, 1436.63, 1467.01, 1472.17]*1e6 - LO; % Test tone frequencies
F = [];
for nt = 1:Ntone
    F = [F; [1 tone_freq(nt)]];
end
tone_idx = [10,10,11,16,18];
for jj = 1:Ntone
    for ii = 1:Nele
        r_tones(jj,ii) = R(1,ii,tone_idx(jj),1,jj); % freq should be a frequency index corresponding to relative LO frequency
        if ii ~= 1
            phi(jj,ii) = angle(r_tones(jj,ii));
        end
    end
end

figure();
plot(10*log10(abs(squeeze(R(11,11,:,1,1))))); hold on;
plot(10*log10(abs(squeeze(R(11,11,:,1,2)))));
plot(10*log10(abs(squeeze(R(11,11,:,1,3)))));
plot(10*log10(abs(squeeze(R(11,11,:,1,4)))));
plot(10*log10(abs(squeeze(R(11,11,:,1,5))))); hold off;

% shifts = [0 0 0; 0 0 2*pi; 0 2*pi 2*pi; 0 2*pi 4*pi; ...
%     0 0 -2*pi; 0 -2*pi -2*pi; 0 -2*pi -4*pi; 0 -4*pi -4*pi; ...
%     0 -4*pi -6*pi; 0 4*pi 4*pi; 0 4*pi 6*pi];

shifts = [];
for i = 0:12
    for j = 0:i
        for k = 0:j
            for l = 0:k
                shifts = [shifts; [0,  l*2*pi,  k*2*pi,  j*2*pi,  i*2*pi]];
                shifts = [shifts; [0, -l*2*pi, -k*2*pi, -j*2*pi, -i*2*pi]];
            end
        end
    end
end

Nshift = size(shifts,1);
phi_tmp = zeros(Ntone,Nele,Nshift);
residual = zeros(Nele,Nshift);
a_b = zeros(2,Nele,Nshift);
for k = 1:Nele
    for i = 1:Nshift
        phi_tmp(:,k,i) = phi(:,k) + shifts(i,:).';
        a_b(:,k,i) = pinv(F)*phi_tmp(:,k,i);
        residual(k,i) = norm(F*a_b(:,k,i) - phi_tmp(:,k,i)).^2;
    end
end
[min_res,idx] = min(residual,[],2);
figure();
plot(min_res);

figure();
for k = 1:Nele
    tmp = phi(:,k)+shifts(idx(k),:).';
    plot(tone_freq, tmp);
    title(sprintf('Phase Ramp 0/%d', k));
end

for k = 1:Nele
    a(k) = a_b(1,k,idx(k)); % Should be a multiple of 2*pi
    b(k) = a_b(2,k,idx(k)); % Phase ramp slope
end


