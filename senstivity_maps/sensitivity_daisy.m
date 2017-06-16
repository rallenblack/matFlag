% Daisy - Aggregate weights and plot sensitvity map
close all;
clearvars;

addpath ../kernel/
scan_table; % Found in kernel directory
source_table; % Found in kernel directory

tic;

pol = 'Y';

% % AGBT16B_400_04 Daisy %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% session = AGBT16B_400_04;
% on_scans = 22;
% off_scans = [21, 23];
% source = source3C295;

% % AGBT16B_400_05 Daisy %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
session = AGBT16B_400_05;
on_scans = 22;
off_scans = [21, 23];
source = source3C147;

on_tstamp = session.scans(on_scans);
off_tstamp = session.scans(off_scans);
if pol == 'X'
    good_idx = session.goodX;
else
    good_idx = session.goodY;
end
bad_freqs = session.bad_freqs;

proj_str = session.session_name;
save_dir = sprintf('%s/%s/BF', data_root, proj_str);
out_dir = sprintf('%s/mat', save_dir);
mkdir(save_dir, out_dir);

% Constants
overwrite = 0;
k = 0;
kB = 1.38*1e-23;

rad = 50;
Ap = (rad^2)*pi;

LO_freq = 1450;
freqs = ((-249:250)*303.75e-3) + LO_freq;
a = source.a;
b = source.b;
c = source.c;
d = source.d;
e = source.e;
f = source.f;
x = a + b*log10(freqs./1e3) + c*log10(freqs./1e3).^2 + d*log10(freqs./1e3).^3 + e*log10(freqs./1e3).^4 + f*log10(freqs./1e3).^5;
flux_density = 10.^x;

ant_dir = sprintf('%s/%s/Antenna', meta_root, proj_str);

% Iterate over off pointings just to have them ready
% Iterate over on pointings and look for closest off pointing

banks = {'A', 'B', 'C', 'D',...
        'E', 'F', 'G', 'H',...
        'I', 'J', 'K', 'L',...
        'M', 'N', 'O', 'P',...
        'Q', 'R', 'S', 'T'};

% Iterate over off pointings
AZoff = zeros(length(off_tstamp), 1);
ELoff = zeros(length(off_tstamp), 1);
fprintf('Processing off pointings...\n');
for j = 1:length(off_tstamp)
    tmp_stmp = off_tstamp{j};
    fprintf('    Time stamp: %s - %d/%d\n', tmp_stmp, j, length(off_tstamp));
    for b = 1:length(banks)
        
        fprintf('Processing bank %s\n', banks{b});

        % Generate filename
        filename = sprintf('%s/%s_%s.mat', out_dir, tmp_stmp, banks{b});

        % Extract data and save
        if ~exist(filename, 'file') || overwrite == 1
            [R, az_tmp, el_tmp, ~, ~] = aggregate_single_bank(save_dir, ant_dir, tmp_stmp, banks{b}, -1);

            % Off pointings are dwell scans; need single R, az, and el
            az = mean(az_tmp);
            el = mean(el_tmp);
            save(filename, 'R', 'az', 'el');
        else
            load(filename);
        end
    end
    % Create entry in position table
    AZoff(j) = az;
    ELoff(j) = el;
end
    
figure(1);
plot(AZoff, ELoff, 'x');

% Iterate over on pointings
fprintf('Processing on pointings...\n');
AZ = [];
EL = [];
cal = [];
for bank = 1:length(banks)
    fprintf('Processing bank %s\n', banks{bank});
    for i = 1:length(on_tstamp)
        
        tmp_stmp = on_tstamp{i};
        fprintf('    Time stamp: %s - %d/%d\n', tmp_stmp, i, length(on_tstamp));
    
        % Generate filename
        filename = sprintf('%s/%s_%s.mat', out_dir, tmp_stmp, banks{bank});

        % Extract data and save
        if ~exist(filename, 'file') || overwrite == 1
            [R, az, el, xid, info] = aggregate_single_bank(save_dir, ant_dir, tmp_stmp, banks{bank}, 4);
            if isempty(R) && isempty(az) && isempty(el) && isempty(info)
                fprintf('Skipping\n');
                continue;
            end
            save(filename, 'R', 'az', 'el', 'xid');
        else
            load(filename);
            if isempty(R) && isempty(az) && isempty(el)
                fprintf('Skipping\n');
                continue;
            end
        end
        
        % Compute max-SNR weights and compute sensitivity
        if bank == 1
            fprintf('FIRST BANK\n');
            Sens = zeros(size(R,4), 500);
        end
        
        % Get absolute channel indices from xid
        chans = [1:5, 101:105, 201:205, 301:305, 401:405] + 5*xid;
        disp(chans);
        
        % Off pointings are dwell scans; need single R, az, and el
        hold on;
        plot(az, el, '-b');
        hold off;
        drawnow;

        % Find nearest off poinitng
        for j = 1:length(off_tstamp)
            az_dist = az - AZoff(j);
            el_dist = el - ELoff(j);

            vector_distance(j) = mean(sqrt(az_dist.^2 + el_dist.^2));
        end

        [~, idx] = min(vector_distance);
        fprintf('     Using %s as the off pointing...\n', off_tstamp{idx});
        OFF = load(sprintf('%s/%s_%s', out_dir, off_tstamp{idx}, banks{bank}));
        if isempty(OFF.R)
            fprintf('No OFF - skipping\n');
            continue;
        end

        % Get steering vectors
        fprintf('     Obtaining steering vectors...\n');
        a = get_steering_vectors_single_bank(R, OFF.R, good_idx, xid, bad_freqs, save_dir, tmp_stmp, pol, 0);

        a_agg = a;
        w = zeros(size(a,1), size(a,2), 500);

        fprintf('     Calculating weights and sensitivity...\n');
        for t = 1:size(R,4)
            bidx = 1;
            for b = chans
                if sum(bad_freqs == b) == 0
                    w(:,t,b) = OFF.R(good_idx, good_idx, bidx)\a(:,t,bidx);
                    w(:,t,b) = w(:,t,b)./(w(:,t,b)'*a(:,t,bidx));
                    Pon = w(:,t,b)'*R(good_idx, good_idx, bidx, t)*w(:,t,b);
                    Poff = w(:,t,b)'*OFF.R(good_idx, good_idx, bidx)*w(:,t,b);
                    SNR = (Pon - Poff)/Poff;
                    Sens(t,b) = 2*kB*SNR./(flux_density(b)*1e-26);
                else
                    Sens(t,b) = 0;
                    w(:,t,b) = zeros(size(a,1),1);
                end
                bidx = bidx + 1;
            end
        end
        AZ = az;
        EL = el;

        if i == 1
            w_agg = w;
        else
            % Append to aggregated steering vector matrix
            w_agg = cat(2, w_agg, w);
        end
    end
    a_filename = sprintf('%s/%s_aggregated_grid_%s_%s.mat', out_dir, session.session_name, pol, banks{bank});
    fprintf('Saving aggregated steering vectors to %s\n', a_filename);
    save(a_filename, 'AZ', 'EL', 'a_agg');

    w_filename = sprintf('%s/%s_aggregated_weights_%s_%s.mat', out_dir, session.session_name, pol, banks{bank});
    fprintf('Saving aggregated weight vectors to %s\n', w_filename);
    save(w_filename, 'AZ', 'EL', 'w_agg');
end

% Plot map

% Interpolated map
Npoints = 200;
% minX = -0.8;
% maxX =  0.8;
% minY = -0.3;
% maxY =  0.3;
minX = session.Xdims(1);
maxX = session.Xdims(2);
minY = session.Ydims(1);
maxY = session.Ydims(2);
xval = linspace(minX, maxX, Npoints);
yval = linspace(minY, maxY, Npoints);
[X,Y] = meshgrid(linspace(minX,maxX,Npoints), linspace(minY,maxY,Npoints));
map_fig = figure();
fudge = session.fudge;
for b = 101:101 %Nbins
    fprintf('Bin %d/%d\n', b, 500);
    Sq = griddata(AZ + fudge*EL, EL, real(squeeze(Sens(:,b))), X, Y);
    imagesc(xval, yval, Sq);
    colorbar;
    set(gca, 'ydir', 'normal');
    colormap('jet');
    xlabel('Cross-Elevation Offset (degrees)');
    ylabel('Elevation Offset (degrees)');
    title(sprintf('Formed Beam Sensitivity Map - %spol - %d', pol, b));
    drawnow;
end

% Save figure
fig_filename = sprintf('%s_%spol_map', session.session_name, pol);
saveas(map_fig, sprintf('%s.png', fig_filename));
saveas(map_fig, sprintf('%s.pdf', fig_filename));
saveas(map_fig, sprintf('%s.eps', fig_filename));
saveas(map_fig, sprintf('%s.fig', fig_filename), 'fig');

% Get the angle of arrival for max sensitivity beam
[s_max,max_idx] = max(Sens(:,1));
Tsys_eta = Ap./(Sens(max_idx,:));

tsys_fig = figure();
plot(freqs,real(Tsys_eta).');
title('T_s_y_s/\eta_a_p vs Frequency');
xlabel('Frequency (MHz)');
ylabel('T_s_y_s/\eta_a_p (K)');
grid on;

% Save figure
tsys_filename = sprintf('%s_%spol_tsys', session.session_name, pol);
saveas(tsys_fig, sprintf('%s.png', tsys_filename));
saveas(tsys_fig, sprintf('%s.pdf', tsys_filename));
saveas(tsys_fig, sprintf('%s.eps', tsys_filename));
saveas(tsys_fig, sprintf('%s.fig', tsys_filename), 'fig');

toc;

