function [ dmjd_off, az_off, el_off, ra_off, dec_off ] = get_antenna_positions_test( off_fits_file, on_fits_file, use_radec )
%GET_ANTENNA_POSITIONS Summary of this function goes here
%   Detailed explanation goes here

    % Extract primary header info (observed and encoder az/el)
    info = fitsinfo(on_fits_file);
    p_header = info.PrimaryData.Keywords;
    % Observed (obsc) and encoder (mnt) az/el at scan midpoint
    sobsc_az = p_header{107,2}; % SOBSC_AZ{index,value} values are in the 2nd column, and names in the 1st.
    sobsc_el = p_header{108,2}; % SOBSC_EL{index,value}
    smntc_az = p_header{110,2}; % SMNTC_AZ{index,value}
    smntc_el = p_header{111,2}; % SMNTC_EL{index,value}
    
    % Extract the second binary table entry of the FITS file
    data_off = fitsread(off_fits_file, 'binarytable', 2);
    data_on  = fitsread(on_fits_file, 'binarytable', 2);
    
    dmjd_idx = 1;
    ra_idx = 2;
    dec_idx = 3;
    mnt_az_idx = 4;
    mnt_el_idx = 5;
    obsc_az_idx = 9;
    obsc_el_idx = 10;
    
    dmjd_off = vpa(data_off{dmjd_idx},10); % Increase precision
    
    % ra and dec
    ra_off = data_off{ra_idx};
    dec_off = data_off{dec_idx};
    
    if use_radec == 1
        az_off = ra_off;
        el_off = dec_off;
    elseif use_radec == -1
        % mnt entries correspond to encoder values
        el_off = data_off{mnt_el_idx};
        az_off = data_off{mnt_az_idx};
    else
        % mnt entries correspond to encoder values
        mnt_el_off = data_off{mnt_el_idx};
        mnt_el_on = data_on{mnt_el_idx};
        
        mnt_az_off = data_off{mnt_az_idx};
        mnt_az_on = data_on{mnt_az_idx};

        % obsc entries correspond to commanded position of on-sky beam
        obsc_el_on = data_on{obsc_el_idx};
        obsc_el_off = data_off{obsc_el_idx};
        
        obsc_az_on = data_on{obsc_az_idx};
        
        el_on = (mnt_el_on - obsc_el_on);
        az_on = ((mnt_az_on - obsc_az_on)).*cos(mnt_el_on*pi/180);
        
        el_off = (mnt_el_off - obsc_el_off) + el_on(length(el_on));
        az_off = (mnt_az_off - mnt_az_on(length(mnt_az_on))).*cos(mnt_el_off*pi/180) + az_on(length(az_on)); % - (smntc_az - sobsc_az)).*cos(mnt_el*pi/180);
    end
end

