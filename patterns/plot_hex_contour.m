function map_fig = plot_hex(session, AZ, EL, patterns)
    % Plot patterns in hexagonal pattern

    % Interpolated map
    Npoints = 200;
    minX = session.Xdims(1); % min(AZ);
    maxX = session.Xdims(2); % max(AZ);
    minY = session.Ydims(1);
    maxY = session.Ydims(2);
    xval = linspace(minX, maxX, Npoints);
    yval = linspace(minY, maxY, Npoints);
    [X,Y] = meshgrid(linspace(minX,maxX,Npoints), linspace(minY,maxY,Npoints));
    
    % Create figure
    map_fig = figure();

    % Beam subplot coordinates
%     sub_pos = {[0.2+0.03+0.03,  0.65+0.00+0.0425, 0.20, 0.20],...
%                [0.5+0.00+0.03,  0.65+0.00+0.0425, 0.20, 0.20],...
%                [0.05+0.06+0.03, 0.35+0.02+0.0425, 0.20, 0.20],...
%                [0.35+0.03+0.03, 0.35+0.02+0.0425, 0.20, 0.20],...
%                [0.65+0.00+0.03, 0.35+0.02+0.0425, 0.20, 0.20],...
%                [0.2+0.03+0.03,  0.05+0.04+0.0425, 0.20, 0.20],...
%                [0.5+0.00+0.03,  0.05+0.04+0.0425, 0.20, 0.20]};

    % Get fudge factor to re-align map
    fudge = session.fudge;
    
    % Get a single bin
    b = 101;
    Nbeam = size(patterns, 1);
    for beam = 1:Nbeam
        % Create a subplot at a custom location
%         subplot('Position', sub_pos{beam});

        % Get the pattern using griddata
        norm_pattern = 10*log10(squeeze(patterns(beam,:,b)./max(patterns(beam,:,b))));
        Bq = griddata(AZ+fudge*EL, EL, norm_pattern, X, Y);

        % Plot the pattern
%         imagesc(xval, yval, Bq);
        contour(xval, yval, Bq);
        hold on;
        caxis([-10, 0]);
        colormap('jet');
        set(gca, 'ydir', 'normal');
        axis square;

        % Set the colorbar to be on the right-hand side of the figure
        colorbar('Position', [0.91, 0.05, 0.03, 0.875], 'Limits', [-40, 0]);

        % Write the beam title
        title(sprintf('Beam %d', beam), 'FontSize', 9);

        % Set the tick font size
        set(gca, 'FontSize', 8);

%         % Draw contours
%         hold on;
%         contour(xval,yval,Bq, [-10, -3], 'ShowText', 'on', 'LineColor', 'black');
%         hold off;
    end
    hold off;
end