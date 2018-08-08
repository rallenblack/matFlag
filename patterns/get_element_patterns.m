% Use grid maps to plot element patterns
close all;
clearvars;

addpath ../kernel/
scan_table; % Found in kernel directory

session = AGBT17B_360_03;
% pol = 'Y';
note = 'grid';

LO_freq = 1450;
freqs = ((-249:250)*303.75e-3) + LO_freq;

% Extract polarization indexing information
for p_idx = 1:2
    if p_idx == 1
        pol = 'X';
        good_idx = session.goodX;
        ele = session.X;
    else
        pol = 'Y';
        good_idx = session.goodY;
        ele = session.Y;
    end
    
    Nele = length(ele);
    
    % Load in steering vectors
    out_dir = sprintf('%s/%s/BF/mat', data_root, session.session_name);
    filename = sprintf('%s/%s_aggregated_grid_%s_%s.mat', out_dir, session.session_name, pol, note);
    
    load(filename);
    
    % Load in Tsys values
    tsys_filename = sprintf('%s/%s_%spol_tsys_%s.mat', out_dir,session.session_name, pol, note);
    TSYS = load(tsys_filename);
    
    % Iterate over elements and steering vectors
    patterns = zeros(size(a_agg,2), Nele, size(a_agg,3));
    for e = 1:Nele
        e_idx = ele(e);
        fprintf('Processing element %d\n', e);
        w = zeros(Nele, 1);
        w(e) = 1;
        for i = 1:size(a_agg,2)
            %for b = 1:size(a_agg,3)
            for b = 101:101
                if (TSYS.Tsys_eta(i,b) > 400)
                    % Force low-sensitivity areas to NaN
                    patterns(i,e,b) = NaN;
                else
                    % Zero insert for bad elements
                    a = zeros(40, 1);
                    a(good_idx) = a_agg(:,i,b);
                    a = a(ele);
                    patterns(i,e,b) = abs(w'*a)^2;
                end
            end
        end
    end
    
    
    
    % Normalize patterns to peak
    for e = 1:Nele
        for b= 1:size(a_agg,3)
            patterns(:,e,b) = patterns(:,e,b)./max(patterns(:,e,b));
        end
    end
    
    % Interpolated map
    Npoints = 80;
    minX = session.Xdims(1);
    maxX = session.Xdims(2);
    minY = session.Ydims(1);
    maxY = session.Ydims(2);
    xval = linspace(minX, maxX, Npoints);
    yval = linspace(minY, maxY, Npoints);
    [X,Y] = meshgrid(linspace(minX,maxX,Npoints), linspace(minY,maxY,Npoints));
    map_fig = figure('position', [0, 0, 640, 480]*1.2);
    fudge = session.fudge;
    for e = 1:Nele %Nele
        for b = 101:101 %Nbins
            subplot(4,5,e);
            fprintf('Bin %d/%d\n', b, 500);
            Sq = griddata(AZ+fudge*EL, EL, real(squeeze(10*log10(patterns(:,e,b)))), X, Y);
            imagesc(xval, yval, Sq);
            set(gca, 'ydir', 'normal');
            set(gca, 'clim', [-40, 0]);
            colormap('jet');
            title(sprintf('%d%s', e, pol), 'fontsize', 8);
            
            hold on;
            contour(xval,yval,Sq, [-3, -3], 'ShowText', 'on', 'LineColor', 'black');
            hold off;
            
            % Set the colorbar to be on the right-hand side of the figure
            colorbar('Position', [0.92, 0.05, 0.02, 0.875], 'Limits', [-40, 0]);
        end
    end
    ax1 = axes('Position', [0 0 1 1], 'Visible', 'off');
    my_title = sprintf('Element Patterns - %s-Polarization, %d MHz', pol, floor(freqs(b)));
    my_title = strrep(my_title, '_', '\_');
    text(0.5, 0.965, my_title, 'HorizontalAlignment', 'center', 'Units', 'normalized', 'FontSize', 12, 'FontWeight', 'bold');
    
    % Create x label
    my_xlabel = 'Cross-Elevation (degrees)'; % Right Ascension (degrees) for session 1 and 4
    text(0.5, 0.05, my_xlabel, 'HorizontalAlignment', 'center', 'Units', 'normalized', 'FontSize', 12, 'FontWeight', 'bold');
    
    % Create y label
    my_ylabel = 'Elevation (degrees)'; % Declination (degrees) for session 1 and 4
    text(0.05, 0.5, my_ylabel, 'HorizontalAlignment', 'center', 'Units', 'normalized', 'FontSize', 12, 'FontWeight', 'bold', 'Rotation', 90);
    
    % Save figure
    fig_filename = sprintf('pattern_plots/%s/%s_%spol_%s_elem_patterns',  session.session_name, session.session_name, pol, note);
    saveas(map_fig, sprintf('%s.png', fig_filename));
    saveas(map_fig, sprintf('%s.pdf', fig_filename));
    saveas(map_fig, sprintf('%s.eps', fig_filename));
    saveas(map_fig, sprintf('%s.fig', fig_filename), 'fig');
end