function [ B, xid ] = extract_bf_output( fits_filename )
%EXTRACT_BEAMFORMER_OUTPUT Function that extracts the data from the RTBF and
%reconstructs it from the FITS format into a 3D matrix format
    import matlab.io.*
    % Open file
    fptr = fits.openFile(fits_filename);
    
    % Get xid
    [xid,~] = fits.readKeyDbl(fptr, 'XID');
    
    % Move the pointer to read binary table
    fits.movAbsHDU(fptr,2);
    
    % Get the number of rows
    totalRows = fits.getNumRows(fptr);
    
    % Read the 4th column which contains the data
    colidx = 4;
    stepSize = 1000; % 10000;
    if stepSize > totalRows
        stepSize = totalRows;
        fluxdata = fits.readCol(fptr,colidx,1,stepSize);
    else
        fluxdata = fits.readCol(fptr,colidx,7000,stepSize);
    end
    
    
%     % Get the size of a row
%     fluxdata = fits.readCol(bintbl,colidx,1,1);
%     repeat = size(fluxdata,2);
%     % Preallocate the array
%     fluxdata = zeros(totalRows, repeat, 'like', fluxdata);
%     % Read all row in a loop
%     for i = 1:stepSize:totalRows
%         display(['Row : ', i]);
%         if ((i+stepSize) > totalRows)
%             index = totalRows;
%             numRows = totalRows - i + 1;
%         else
%             index = i + stepSize - 1;
%             numRows = stepSize;
%         end
%         fluxdata(i:index,:) = fits.readCol(bintbl,colidx,i,numRows);
%     end

    % Close file
    fits.closeFile(fptr);

    Nrows = size(fluxdata, 1);   
    Npol = 4; % X self-polarized, Y self-polarized, XY polarized (real), XY polarized (imaginary)
    Nbeam = 7;
    Nbin = 25;
    Nsti = 100;
    
%     B = reshape(data, Nrows, Nbeam, Npol, Nbin, Nsti);
    B = zeros(Nbeam, Npol, Nbin, Nsti*Nrows);
    for r = 1:Nrows
        B(:,:,:,Nsti*(r-1)+1:Nsti*r) = reshape(fluxdata(r,:), Nbeam, Npol, Nbin, Nsti);
    end
end


