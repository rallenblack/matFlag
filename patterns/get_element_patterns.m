% Use grid maps to plot element patterns
close all;
clearvars;

addpath ../kernel/
scan_table; % Found in kernel directory

session = AGBT16B_400_01;
pol = 'X';

% Extract polarization indexing information
if pol == 'X'
    good_idx = session.goodX;
    ele = session.X;
else
    good_idx = session.goodY;
    ele = session.Y;
end

Nele = length(ele);

% Load in steering vectors
out_dir = sprintf('%s/%s/BF/mat', data_root, session.session_name);
filename = sprintf('%s/%s_aggregated_grid_%s.mat', out_dir, session.session_name, pol);

load(filename);

% Iterate over elements and steering vectors
patterns = zeros(size(a_agg,2), Nele, size(a_agg,3));
for e = 1:Nele
    fprintf('Processing element %d\n', e);
    w = zeros(Nele, 1);
    w(e) = 1;
    for i = 1:size(a_agg,2)
        for b = 1:size(a_agg,3)
            % Zero insert for bad elements
            a = zeros(40, 1);
            a(good_idx) = a_agg(:,i,b);
            a = a(ele);
            patterns(i,e,b) = abs(w'*a)^2;
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
minX = -0.275;
maxX =  0.275;
minY = -0.175;
maxY =  0.275;
xval = linspace(minX, maxX, Npoints);
yval = linspace(minY, maxY, Npoints);
[X,Y] = meshgrid(linspace(minX,maxX,Npoints), linspace(minY,maxY,Npoints));
map_fig = figure();
fudge = session.fudge;
for e = 1:Nele %Nele
    for b = 101:101 %Nbins
        subplot(4,5,e);
        fprintf('Bin %d/%d\n', b, 500);
        Sq = griddata(AZ+fudge*EL, EL, real(squeeze(10*log10(patterns(:,e,b)))), X, Y);
        imagesc(xval, yval, Sq);
        set(gca, 'ydir', 'normal');
        colormap('jet');
        xlabel('Cross-Elevation Offset (degrees)');
        ylabel('Elevation Offset (degrees)');
        title(sprintf('Element %d%s', e, pol));
    end
end


