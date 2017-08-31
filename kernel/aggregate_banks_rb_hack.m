function [ R, my_az, my_el, info ] = aggregate_banks_rb_hack( save_dir, ant_dir, tstamp, on_off, Nint )
%AGGREGATE_BANKS Collects all the BANK data into a single covariance matrix
%variable
%   Takes the data from dir/tstamp and finds banks A-T. Opens them,
%   reconstructs the covariance matrices and aggregates them into a
%   40x40x500 matrix.

    % Constants
     banks = {'A'};

    
    chan_idx = [1:5, 101:105, 201:205, 301:305, 401:405];

    Nele = 40;
    Nchan = 500;
    fprintf('     ');
    Rtmp = cell(length(banks), 1);
    xid = zeros(length(banks), 1);
    for i = 1:length(banks)
        filename = sprintf('%s/%s%s.fits', save_dir, tstamp, banks{i});
        fprintf('%c', banks{i});
        % Check to see that file exists
        if exist(filename, 'file') ~= 0
            [Rtmp{i}, dmjd, xid(i), info] = extract_covariances(filename);
            if size(Rtmp{i},4) == 0
                fprintf('!');
            end
        end
    end
    fprintf('\n');
    fprintf('      Allocating full covariance matrix\n');
    Rtmp1 = zeros(Nele, Nele, Nchan, size(Rtmp{1},4));
    for i = 1:length(banks)
        Rtmp1(:,:,chan_idx + 5*xid(i),:) = Rtmp{i};
    end

    fprintf('      Integrating covariances\n');
    N_time = size(dmjd,1); % size(Rtmp1,4) The dmjd length was sometimes less than Rtmp1 so Nint exceeded it's length. 
    if (Nint == -1)
        Nint = N_time;
    end
    if length(dmjd) > 1
        int_length = dmjd(2) - dmjd(1);
    else
        int_length = 1;
    end
    R = zeros(size(Rtmp1,1), size(Rtmp1,2), size(Rtmp1,3), floor(N_time/Nint));
    dec_dmjd = zeros(floor(N_time/Nint), 1);
    for j = 1:floor(N_time/Nint)
        R(:,:,:,j) = sum(Rtmp1(:,:,:,Nint*(j-1)+1:Nint*j),4)/Nint;
        %dec_dmjd(j) = sum(vpa(dmjd(Nint*(j-1)+1:Nint*j),10))/Nint;
        dec_dmjd(j) = sum(dmjd(Nint*(j-1)+1:Nint*j))/Nint + int_length/2;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Extract antenna positions for scan
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    disp('      Extracting antenna positions and computing offsets');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Extract offsets
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %ant_dir = '/home/gbtdata/AGBT16B_400_09/Antenna';
    use_radec = 0;
    ant_fits_file = sprintf('%s/%s.fits', ant_dir, tstamp);
    [ant_dmjd, az_off, el_off] = get_antenna_positions(ant_fits_file, on_off, use_radec);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Associate offsets with correlation matrices
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    disp('      Associating pointing offsets with correlation matrices');
    Ntime = size(R, 4);
    
    % Do a least-squares linear fit
    ant_dmjd = double(ant_dmjd);
    tmp = floor(ant_dmjd(1));
    A = [ones(length(ant_dmjd), 1), (ant_dmjd - tmp)*3600*24];
    b_el = el_off;
    b_az = az_off;
    x_el = A\b_el;
    x_az = A\b_az;
    
    % Get interpolated values
    B = [ones(Ntime, 1), (dec_dmjd - tmp)*3600*24];
    my_el = B*x_el;
    my_az = B*x_az;
    
end

