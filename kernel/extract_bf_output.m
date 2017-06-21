function [ B, dmjd, xid ] = extract_bf_output( fits_filename )
%EXTRACT_BEAMFORMER_OUTPUT Function that extracts the data from the RTBF and
%reconstructs it from the FITS format into a 3D matrix format

    info   = fitsinfo(fits_filename);
%     Nrows = info.BinaryTable.Rows;
    Nrows = 14000;
    if info.FileSize < 4e9
        bintbl = fitsread(fits_filename, 'binarytable', 1);
    else
        for idx = 1:4
            tmpBintbl = fitsread(fits_filename, 'binarytable', ...
                'Info', info, ...
                'TableRows', [Nrows*(idx-1)+1:Nrows*idx]);
            bintbl{1}(Nrows*(idx-1)+1:Nrows*idx, 1) = tmpBintbl{1};
            bintbl{2}(Nrows*(idx-1)+1:Nrows*idx, 1) = tmpBintbl{2};
            if length(tmpBintbl) == 3
                bintbl{3}(Nrows*(idx-1)+1:Nrows*idx, :) = tmpBintbl{3};
            else
                bintbl{3}(Nrows*(idx-1)+1:Nrows*idx, 1) = tmpBintbl{3};
                bintbl{4}(Nrows*(idx-1)+1:Nrows*idx, :) = tmpBintbl{4};
            end
        end
    end
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
    Nblocks = size(data,1);
    Nsti = 100;

    B = reshape(data, Nblocks, Nbeam, Npol, Nbin, Nsti);
    
end


