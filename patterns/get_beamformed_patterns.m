function [AZ, EL, patterns] = get_beamformed_patterns(session, pol, beam_az, beam_el)

    % Read scan table for session information
    scan_table;
    
    % Load in steering vectors
    out_dir = sprintf('%s/%s/BF/mat', data_root, session.session_name);
    filename = sprintf('%s/%s_aggregated_grid_%s.mat', out_dir,...
        session.session_name, pol);

    if ~exist(filename, 'file')
        error(sprintf('The steering vectors file %s does not exist!\n',...
            filename));
    end
    load(filename);
    
    % Load in weights
    w_filename = sprintf('%s/%s_aggregated_weights_%s.mat', out_dir,...
        session.session_name, pol);
    if ~exist(w_filename, 'file')
        error(sprintf('The weight vectors file %s does not exist!\n',...
            w_filename));
    end
    load(w_filename);
    
    % Beam locations
    % To be moved to input argument
    beam_el = [52.23,  52.32, 52.1,  52.19, 52.28, 52.07, 52.19];
    beam_az = [212.7,  212.9, 212.7, 212.9, 213.1, 212.9, 213.1];
    Nbeam = length(beam_el);
    
    % Get beam weights
    % Find closest AZ/EL for specified beam locations
    for beam = 1:Nbeam
        delta_el = (EL - beam_el(beam)).^2;
        delta_az = (AZ - beam_az(beam)).^2;
        d = sqrt(delta_el + delta_az);
        
        [~, beam_idx(beam)] = min(d);
    end
    
    plot(AZ, EL);
    hold on;
    plot(AZ(beam_idx), EL(beam_idx), 'rx');
    hold off;
    
    % Iterate over elements and steering vectors
    patterns = zeros(Nbeam, size(a_agg,2), size(a_agg,3));
    for beam = 1:Nbeam
        fprintf('Processing beam %d\n', beam);
        w = squeeze(w_agg(:,beam_idx(beam),:));
        for i = 1:size(a_agg,2)
            for b = 1:size(a_agg,3)
                % Zero insert for bad elements
                a = a_agg(:,i,b);
                patterns(beam,i,b) = abs(w(:,b)'*a)^2;
            end
        end
    end

    % Normalize patterns to peak
    for beam = 1:Nbeam
        for b= 1:size(a_agg,3)
            patterns(:,beam,b) = patterns(:,beam,b)./max(patterns(:,beam,b));
        end
    end
end
