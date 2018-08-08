function [ B, xid ] = extract_bf_output2( fits_filename )
%EXTRACT_BEAMFORMER_OUTPUT 2 Function that extracts the data from the RTBF and
%reconstructs it from the FITS format into a 3D matrix format

    info   = fitsinfo(fits_filename);
    bintbl = fitsread(fits_filename, 'binarytable', 1);
    dmjd = bintbl{1};
    mcnt = bintbl{2};
    if length(bintbl) == 3
        data = bintbl{3};
    else
        good_data = bintbl{3};
        data = bintbl{4};
    end

    keywords = info.PrimaryData.Keywords;
    xid = -1;
    for i = 1:size(keywords, 1)
        if strcmp(keywords{i,1}, 'XID')
            xid = str2double(keywords{i,2});
            break;
        end
    end
    Nrows = size(data, 1);
    
    
    Npol = 4; % X self-polarized, Y self-polarized, XY polarized (real), XY polarized (imaginary)
    Nbeam = 7;
    Nbin = 25;
    Nsti = 100;
%     Nblocks = 1;
    
%     B = reshape(data, Nblocks, Nbeam, Npol, Nbin, Nsti);
    B = zeros(Nbeam, Npol, Nbin, Nsti*Nrows);
    for r = 1:Nrows
        B(:,:,:,Nsti*(r-1)+1:Nsti*r) = reshape(data(r,:), Nbeam, Npol, Nbin, Nsti);
    end
    
end


