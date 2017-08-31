% LCMV Beamformer with 3dB contour constrained

close all;
clearvars;

% Add kernel codes to path
addpath ../kernel/

% Load scan table
scan_table; % Found in kernel directory

% Desired session
session = AGBT16B_400_12;
note = 'grid';

% Element mapping
X_idx = session.goodX;
Y_idx = session.goodY;

% Get an OFF pointing
off_scan_num = 36;
off_tstamp = session.scans(off_scan_num);
proj_str = session.session_name;
save_dir = sprintf('%s/%s/BF', data_root, proj_str);
out_dir = sprintf('%s/mat', save_dir);
OFF = load(sprintf('%s/%s', out_dir, off_tstamp{1}));

% Specify marker colors
marker_colors = get(groot, 'defaultAxesColorOrder');

% Iterate over polarization
for pol_idx = 1:2
    if pol_idx == 1
        pol = 'X';
    else
        pol = 'Y';
    end
    fprintf('Processing Pol %s\n', pol);
    
    if pol == 'X'
        good_idx = X_idx;
    else
        good_idx = Y_idx;
    end

    % Get steering vectors for beam centers
    beam_az = session.beam_az;
    beam_el = session.beam_el;
    [a, a_az, a_el] = get_grid_steering_vectors(session, pol, note, beam_az, beam_el);
    
    constraint_fig = figure();
    % Get half-power constraint points for each beam
    beamwidth = 15/60; % 9.25 arcminutes
    w = zeros(size(a));
    for beam = 1:length(beam_az)
        constraint_az = beam_az(beam) + beamwidth*cos(0:0.1:2*pi).';
        constraint_el = beam_el(beam) + beamwidth*sin(0:0.1:2*pi).';
        figure(1);
        [c, c_az, c_el, Tsys] = get_grid_steering_vectors(session, pol, note, constraint_az, constraint_el);
        
        % Remove constraint points that were not sampled well
        bad_az_idx = abs(c_az - constraint_az) > 0.1*9.25/60;
        bad_el_idx = abs(c_el - constraint_el) > 0.1*9.25/60;
        
        % Remove points that had low sensitivity
        bad_tsys_idx = (Tsys(:,101) > 400);
        
        % Do the removal
        bad_idx = bad_az_idx | bad_el_idx | bad_tsys_idx;
        c_az(bad_idx) = [];
        c_el(bad_idx) = [];
        
        figure(constraint_fig);
        h1 = plot(beam_az(beam), beam_el(beam), 'x');
        hold on;
        h2 = plot(constraint_az, constraint_el, '--');
        h3 = plot(a_az(beam), a_el(beam), 'o');
        h4 = plot(c_az,       c_el,       's');
        
        % Change colors
        set(h1, 'Color', marker_colors(beam,:));
        set(h2, 'Color', marker_colors(beam,:));
        set(h3, 'Color', marker_colors(beam,:));
        set(h4, 'Color', marker_colors(beam,:));
        
        set(h1, 'MarkerEdgeColor', marker_colors(beam,:));
        set(h2, 'MarkerEdgeColor', marker_colors(beam,:));
        set(h3, 'MarkerEdgeColor', marker_colors(beam,:));
        set(h4, 'MarkerEdgeColor', marker_colors(beam,:));
        
        % Get new weights
        for bin = 101:101
            CH = c(:,:,bin)';
            if sum(isnan(CH)) > 0
                continue;
            end
            %f = 1/sqrt(2)*ones(size(c,2),1);
            f = zeros(size(c,2),1);
            
            % Get reduced-rank approximation
            [U,S,V] = svd(CH);
            
            C1 = S*V';
            C2 = C1(1:15,:);
            f1 = U'*f;
            f2 = f1(1:15,:);
            
            % Incorporate main-beam constraint
            C3 = [a(:,beam,bin)'; C2];
            f3 = [1; f2];
            
            %C3 = [a(:,beam,bin)'; CH(1:10:end,:)];
            %f3 = [1; f(1:10:end)];
            
            Roff = OFF.R(good_idx, good_idx, bin);
            w(:,beam,bin) = Roff\C3'*inv(C3*inv(Roff)*C3')*f3;
            w(:,beam,bin) = w(:,beam,bin)./(w(:,beam,bin)'*a(:,beam,bin));
        end
    end
    
    if pol == 'X'
        wX = w;
    else
        wY = w;
    end
    
    % Adjust constraint point plot
    figure(constraint_fig);
    xlabel('Cross-Elevation Offset (degrees)');
    ylabel('Elevation Offset (degrees)');
    title('Beam Constraint Points');
    h(1) = plot(0,0,'ok', 'visible', 'off'); % Beam centers
    h(2) = plot(0,0,'--k','visible', 'off'); % Constraint circle
    h(3) = plot(0,0,'xk', 'visible', 'off'); % Actual beam center
    h(4) = plot(0,0,'sk', 'visible', 'off'); % Actual constraint points
    legend(h, 'Desired Beam Center', 'Desired Constraint Locations',...
              'Actual Beam Center',  'Actual Constraint Locations');
    
    % Generate patterns
    [AZ, EL, patterns] = get_beamformed_patterns(session, pol, note, w);
    
    beam_plot_idx = [15, 13, 11, 9, 7, 5, 3];

    if 1
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
        my_xlabel = 'Cross-Elevation (degrees)'; % Right Ascension (degrees) for session 1 and 4
        text(0.5, 0.05, my_xlabel, 'HorizontalAlignment', 'center', 'Units', 'normalized', 'FontSize', 10, 'FontWeight', 'bold');

        % Create y label
        my_ylabel = 'Elevation (degrees)'; % Declination (degrees) for session 1 and 4
        text(0.05, 0.5, my_ylabel, 'HorizontalAlignment', 'center', 'Units', 'normalized', 'FontSize', 10, 'FontWeight', 'bold', 'Rotation', 90);
        
        % Add circles to indicate constraint circle
        children = get(gcf, 'Children');
        for beam = 1:7
            beam_axis = children(beam_plot_idx(beam));
            hold(beam_axis, 'on');
            plot(beam_axis, beamwidth*cos(0:0.1:2.1*pi) + a_az(beam),...
                            beamwidth*sin(0:0.1:2.1*pi) + a_el(beam), '--w');
        end
        

        % Save figure
        fig_filename = sprintf('pattern_plots/Grid%s/%s_%spol_formed_beams', session.session_name(14), session.session_name, pol);
        %saveas(map_fig, sprintf('%s.png', fig_filename));
        %saveas(map_fig, sprintf('%s.pdf', fig_filename));
        %saveas(map_fig, sprintf('%s.eps', fig_filename));
        %saveas(map_fig, sprintf('%s.fig', fig_filename), 'fig');
    end
    keyboard;
end

% Save weights to file
rtbf_filename = sprintf('%s/%s/BF/w_13_lcmv.bin', data_root,...
    session.session_name);
create_weight_file(a_az, a_el, wX, wY, session.session_name, X_idx, Y_idx, rtbf_filename);
fprintf('Saved weights to %s\n', rtbf_filename);
