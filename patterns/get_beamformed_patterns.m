function [AZ, EL, patterns] = get_beamformed_patterns(session, pol, note, w)

    % Read scan table for session information
    scan_table;
    
    % Load in steering vectors
    out_dir = sprintf('%s/%s/BF/mat', data_root, session.session_name);
    filename = sprintf('%s/%s_aggregated_grid_%s_%s.mat', out_dir,...
        session.session_name, pol, note);

    if ~exist(filename, 'file')
        error(sprintf('The steering vectors file %s does not exist!\n',...
            filename));
    end
    load(filename);
    
    % Load in Tsys values
    tsys_filename = sprintf('%s/%s_%spol_tsys_%s.mat', out_dir,session.session_name, pol, note);
    TSYS = load(tsys_filename);
    
    % Iterate over elements and steering vectors
    Nbeam = size(w, 2);
%     patterns = zeros(Nbeam, size(a_banks,2), size(a_banks,3));
%     for beam = 1:Nbeam
%         fprintf('Processing beam %d\n', beam);
%         w1 = squeeze(w(:,beam,:));
%         for i = 1:size(a_banks,2)
%             for b = 1:size(a_banks,3)
%                 % Zero insert for bad elements
%                 a = a_banks(:,i,b);
%                 patterns(beam,i,b) = abs(w1(:,b)'*a)^2;
%             end
%         end
%     end
% 
%     % Normalize patterns to peak
%     for beam = 1:Nbeam
%         for b= 1:size(a_banks,3)
%             patterns(:,beam,b) = patterns(:,beam,b)./max(patterns(:,beam,b));
%         end
%     end
    
    patterns = zeros(Nbeam, size(a_agg,2), size(a_agg,3));
    for beam = 1:Nbeam
        fprintf('Processing beam %d\n', beam);
        w1 = squeeze(w(:,beam,:));
        for i = 1:size(a_agg,2)
            for b = 1:size(a_agg,3)
                % Mask out low sensitivity areas
                if (TSYS.Tsys_eta(i,b) > 300)
                    % Force low-sensitivity areas to NaN
                    patterns(beam,i,b) = NaN;
                else
                    % Zero insert for bad elements
                    a = a_agg(:,i,b);
                    patterns(beam,i,b) = abs(w1(:,b)'*a)^2;
                end
            end
        end
    end

    % Normalize patterns to peak
    for beam = 1:Nbeam
        for b= 1:size(a_agg,3)
            patterns(beam,:,b) = patterns(beam,:,b)./max(patterns(beam,:,b));
        end
    end
end
