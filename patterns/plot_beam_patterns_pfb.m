% Plots formed beam patterns

close all;
clearvars;

% Add kernel codes to path
addpath ../kernel/

% Load scan table
scan_table; % Found in kernel directory

% Desired session
session = AGBT16B_400_07;

% Element mapping
X_idx = session.goodX;
Y_idx = session.goodY;

% Iterate over polarization
for pol_idx = 1:2
    if pol_idx == 1
        pol = 'X';
    else
        pol = 'Y';
    end
    fprintf('Processing Pol %s\n', pol);
    
    % Get beam weights
    beam_az = session.beam_az;
    beam_el = session.beam_el;
    [w, w_az, w_el] = get_grid_weights(session, pol, beam_az, beam_el);
    if pol == 'X'
        wX = w;
    else
        wY = w;
    end
    
    % Generate patterns
    [AZ, EL, patterns] = get_beamformed_patterns(session, pol, w);
    
    % Plot patterns
%     map_fig = plot_hex(session, AZ, EL, patterns);
    
    % Get on-sky frequencies
    %     LO_freq = 1450;
    %     freqs = ((-249:250)*303.75e-3) + LO_freq;
    chansel = 1;
    LO = 1450e6;
    f_start = LO - 249.5*303.75e3 + 303.75e3*100*chansel;
    df = 303.75e3/32;
    numchannels = 3200;
    faxis = (0:numchannels-1)*df + f_start;
    b = 101;
    
%     % Create title
%     figure(map_fig);
%     ax1 = axes('Position', [0 0 1 1], 'Visible', 'off');
%     my_title = sprintf('%s - %s-Polarization, %d MHz', session.session_name, pol, floor(faxis(b)));
%     my_title = strrep(my_title, '_', '\_');
%     text(0.5, 0.965, my_title, 'HorizontalAlignment', 'center', 'Units', 'normalized', 'FontSize', 12, 'FontWeight', 'bold');
%     
%     % Create x label
%     my_xlabel = 'Cross-Elevation (degrees)'; % Right Ascension (degrees) for session 1 and 4
%     text(0.5, 0.05, my_xlabel, 'HorizontalAlignment', 'center', 'Units', 'normalized', 'FontSize', 10, 'FontWeight', 'bold');
%     
%     % Create y label
%     my_ylabel = 'Elevation (degrees)'; % Declination (degrees) for session 1 and 4
%     text(0.05, 0.5, my_ylabel, 'HorizontalAlignment', 'center', 'Units', 'normalized', 'FontSize', 10, 'FontWeight', 'bold', 'Rotation', 90);
%     
%     % Save figure
%     fig_filename = sprintf('pattern_plots/Grid%s/%s_%spol_formed_beams', session.session_name(14), session.session_name, pol);
%     saveas(map_fig, sprintf('%s.png', fig_filename));
%     saveas(map_fig, sprintf('%s.pdf', fig_filename));
%     saveas(map_fig, sprintf('%s.eps', fig_filename));
%     saveas(map_fig, sprintf('%s.fig', fig_filename), 'fig');
end

% Save weights to file
rtbf_filename = sprintf('%s/%s/BF/weights_%s.bin', data_root,...
    session.session_name, session.session_name);
create_weight_file_pfb(w_az, w_el, wX, wY, session.session_name, X_idx, Y_idx, rtbf_filename);
