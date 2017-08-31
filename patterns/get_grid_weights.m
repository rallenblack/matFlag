function [w, w_az, w_el] = get_grid_weights(session, pol, beam_az, beam_el, note)

    % Load scan table
    scan_table;

    % Beam locations
    Nbeam = length(beam_el);

    % Load in weights
    out_dir = sprintf('%s/%s/BF/mat', data_root, session.session_name);
    w_filename = sprintf('%s/%s_aggregated_weights_%s_%s.mat', out_dir,...
        session.session_name, pol, note);
    if ~exist(w_filename, 'file')
        error(sprintf('The weight vectors file %s does not exist!\n',...
            w_filename));
    end
    load(w_filename);

    % Find closest AZ/EL for specified beam locations
    for beam = 1:Nbeam
        delta_el = (EL - beam_el(beam)).^2;
        delta_az = (AZ - beam_az(beam)).^2;
        d = sqrt(delta_el + delta_az);

        [~, beam_idx(beam)] = min(d);
    end

    w = w_agg(:,beam_idx,:);
%     w = w_banks(:,beam_idx,:);
    w_az = AZ(beam_idx);
    w_el = EL(beam_idx);
end