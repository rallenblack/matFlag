function [ dmjd, az_off, el_off, ra, dec ] = get_antenna_positions( fits_file, on_off, use_radec )
%GET_ANTENNA_POSITIONS Summary of this function goes here
%   Detailed explanation goes here

    % Extract primary header info (observed and encoder az/el)
    info = fitsinfo(fits_file);
    p_header = info.PrimaryData.Keywords;
    % Observed (obsc) and encoder (mnt) az/el at scan midpoint
    sobsc_az_idx = find(ismember(p_header(:,1), 'SOBSC_AZ'));
    sobsc_el_idx = find(ismember(p_header(:,1), 'SOBSC_EL'));
    smntc_az_idx = find(ismember(p_header(:,1), 'SMNTC_AZ'));
    smntc_el_idx = find(ismember(p_header(:,1), 'SMNTC_EL'));
    sobsc_az = p_header{sobsc_az_idx,2}; % SOBSC_AZ{index,value} values are in the 2nd column, and names in the 1st.
    sobsc_el = p_header{sobsc_el_idx,2}; % SOBSC_EL{index,value}
    smntc_az = p_header{smntc_az_idx,2}; % SMNTC_AZ{index,value}
    smntc_el = p_header{smntc_el_idx,2}; % SMNTC_EL{index,value}
    
    % Extract the second binary table entry of the FITS file
    data = fitsread(fits_file, 'binarytable', 2);
    
    dmjd_idx = 1;
    ra_idx = 2;
    dec_idx = 3;
    mnt_az_idx = 4;
    mnt_el_idx = 5;
    obsc_az_idx = 9;
    obsc_el_idx = 10;

    
    dmjd = vpa(data{dmjd_idx},10); % Increase precision
    
    % ra and dec
    ra = data{ra_idx};
    dec = data{dec_idx};
    
    if use_radec == 1
        az_off = ra;
        el_off = dec;
    elseif use_radec == -1
        % mnt entries correspond to encoder values
        el_off = data{mnt_el_idx};
%         az_off = data{mnt_az_idx}.*cos(el_off*pi/180);
        az_off = data{mnt_az_idx};
    else
        % mnt entries correspond to encoder values
        mnt_el = (data{mnt_el_idx} - smntc_el);
        mnt_az = (data{mnt_az_idx} - smntc_az).*cos(data{mnt_el_idx}*pi/180);
        % mnt_az = data{mnt_az_idx};
        

        % obsc entries correspond to commanded position of on-sky beam
        obsc_el = (data{obsc_el_idx} - sobsc_el);
        obsc_az = (data{obsc_az_idx} - sobsc_az).*cos(data{mnt_el_idx}*pi/180);
        % obsc_az = data{obsc_az_idx};
         
        if on_off == 1
            el_off = (mnt_el - obsc_el);
            az_off = (mnt_az - obsc_az);
        else
%             el_off = (mnt_el - obsc_el) - (smntc_el - sobsc_el);
%             az_off = ((mnt_az - obsc_az) - (smntc_az - sobsc_az)).*cos(mnt_el*pi/180);
        end
    end
end

