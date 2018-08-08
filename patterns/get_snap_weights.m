function [w, w_az, w_el] = get_snap_weights(session, pol, beam_az, beam_el, note)

    % Load scan table
    scan_table;

    % Load in weights
    out_dir = sprintf('%s/%s/BF/mat', data_root, session.session_name);
    w_filename = sprintf('%s/%s_aggregated_weights_%s_%s.mat', out_dir,...
        session.session_name, pol, note);
    if ~exist(w_filename, 'file')
        error(sprintf('The weight vectors file %s does not exist!\n',...
            w_filename));
    end
    load(w_filename);

    w = w_agg;
    w_az = AZ;
    w_el = EL;
end