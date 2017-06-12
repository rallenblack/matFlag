function [ B, dmjd, xid ] = extract_bf_output( fits_filename )
%EXTRACT_BEAMFORMER_OUTPUT Function that extracts the data from the RTBF and
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
    
    Npol = 4; % X self-polarized, Y self-polarized, XY polarized (real), XY polarized (imaginary)
    Nbeam = 7;
    Nbin = 25;
    Nsti = 100;

    B = reshape(data, Nbeam, Npol, Nbin, Nsti);
    
end


