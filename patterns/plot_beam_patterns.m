% Plots formed beam patterns

close all;
clearvars;

% Add kernel codes to path
addpath ../kernel/

% Load scan table
scan_table; % Found in kernel directory

% Desired session
session = AGBT16B_400_02;
pol = 'Y';

% Beam locations
beam_el = [52.23,  52.32, 52.1,  52.19, 52.28, 52.07, 52.19];
beam_az = [212.7,  212.9, 212.7, 212.9, 213.1, 212.9, 213.1];
Nbeam = length(beam_el);

% Get beam weights
% Load in weights
out_dir = sprintf('%s/%s/BF/mat', data_root, session.session_name);
w_filename = sprintf('%s/%s_aggregated_weights_%s.mat', out_dir,...
    session.session_name, pol);
if ~exist(w_filename, 'file')
    error(sprintf('The weight vectors file %s does not exist!\n',...
        w_filename));
end
load(w_filename);

% Find closest AZ/EL for specified beam locations
for beam = 1:Nbeam
    delta_el = (EL - beam_el(beam)).^2;
    delta_az = (AZ - beam_az(beam)).^2;
    d = sqrt(delta_el + delta_az);

    [~, beam_idx(beam)] = min(d);
end

w = w_agg(:,beam_idx,:);

% Generate patterns
[AZ, EL, patterns] = get_beamformed_patterns(session, pol, w);

% Plot patterns
map_fig = plot_hex(session, AZ, EL, patterns);

% Get on-sky frequencies
LO_freq = 1450;
freqs = ((-249:250)*303.75e-3) + LO_freq;
b = 101;

% Create title
figure(map_fig);
ax1 = axes('Position', [0 0 1 1], 'Visible', 'off');
my_title = sprintf('%s - %s-Polarization, %d MHz', session.session_name, pol, floor(freqs(b)));
my_title = strrep(my_title, '_', '\_');
text(0.5, 0.965, my_title, 'HorizontalAlignment', 'center', 'Units', 'normalized', 'FontSize', 12, 'FontWeight', 'bold');

% Create x label
my_xlabel = 'Right Acesnsion (degrees)';
text(0.5, 0.05, my_xlabel, 'HorizontalAlignment', 'center', 'Units', 'normalized', 'FontSize', 10, 'FontWeight', 'bold');

% Create y label
my_ylabel = 'Declination (degrees)';
text(0.05, 0.5, my_ylabel, 'HorizontalAlignment', 'center', 'Units', 'normalized', 'FontSize', 10, 'FontWeight', 'bold', 'Rotation', 90);

% Save figure
fig_filename = sprintf('pattern_plots/%s_%spol_formed_beams', session.session_name, pol);
saveas(map_fig, sprintf('%s.png', fig_filename));
saveas(map_fig, sprintf('%s.pdf', fig_filename));
saveas(map_fig, sprintf('%s.eps', fig_filename));
saveas(map_fig, sprintf('%s.fig', fig_filename), 'fig');

