% Quick Peak Analysis
clearvars;
close all;

% Get scan information and set path
addpath ../kernel/
scan_table; % Found in kernel directory
source_table; % Found in kernel directory

% Specify session information
session = AGBT16B_400_14;
on_scan = 4;
source = source3C295;
Nint = 1;

% Parameters
pol = 'X';
ele = 1;

% Project directory
proj_str = session.session_name;
save_dir = sprintf('%s/%s/BF', data_root, proj_str);

% Antenna directory
ant_dir = sprintf('%s/%s/Antenna', meta_root, proj_str);

% Get timestamp
on_tstamp = session.scans{on_scan};
fprintf('    Time stamp: %s\n', on_tstamp);

% Generate filename
filename = sprintf('%s/%sA.fits', save_dir, on_tstamp);
[R, az, el, ~] = aggregate_banks_rb_hack(save_dir, ant_dir, on_tstamp, 1, 1);

% Plot power over time
plot(az*60, real(squeeze(R(ele, ele, 101,:))), '-b',...
     el*60, real(squeeze(R(ele, ele, 101,:))), '-r');
xlabel('Position (arcmin)');
ylabel('Power');
legend('Az', 'El');
