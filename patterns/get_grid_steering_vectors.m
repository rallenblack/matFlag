function [a, a_az, a_el, Tsys] = get_grid_steering_vectors(session, pol, note, beam_az, beam_el)

    % Load scan table
    scan_table;

    % Beam locations
    Nbeam = length(beam_el);

    % Load in weights
    out_dir = sprintf('%s/%s/BF/mat', data_root, session.session_name);
    a_filename = sprintf('%s/%s_aggregated_grid_%s_%s.mat', out_dir,...
        session.session_name, pol, note);
    if ~exist(a_filename, 'file')
        error(sprintf('The steering vectors file %s does not exist!\n',...
            a_filename));
    end
    load(a_filename);

    % Find closest AZ/EL for specified beam locations
    for beam = 1:Nbeam
        delta_el = (EL - beam_el(beam)).^2;
        delta_az = (AZ - beam_az(beam)).^2;
        d = sqrt(delta_el + delta_az);

        [~, beam_idx(beam)] = min(d);
    end

    a = a_agg(:,beam_idx,:);
%     w = w_banks(:,beam_idx,:);
    a_az = AZ(beam_idx);
    a_el = EL(beam_idx);
    
    % Get Tsys values
    tsys_filename = sprintf('%s/%s_%spol_tsys_%s.mat',...
        out_dir, session.session_name, pol, note);
    TSYS = load(tsys_filename);
    Tsys = TSYS.Tsys_eta(beam_idx,:);
end