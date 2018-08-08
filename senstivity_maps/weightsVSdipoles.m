% Weights vs. dipole for comparison with Anish's data

addpath ../kernel/
scan_table; % Found in kernel directory
source_table; % Found in kernel directory

% sessions = {'AGBT16B_400_02','AGBT16B_400_03','AGBT16B_400_04', ...
sessions_arr = {'AGBT16B_400_02','AGBT16B_400_03', ...
    'AGBT16B_400_12','AGBT16B_400_13','AGBT16B_400_14', ...
    'AGBT17B_360_01','AGBT17B_360_02','AGBT17B_360_03',...
    'AGBT17B_360_04','AGBT17B_360_06','AGBT17B_360_07'}; 

sources_arr = {'3C295', '3C295', '3C295', '3C123', '3C147', ...
    '3C295', '3C147', '3C295', '3C295', '3C48', '3C295'};

sess = length(sessions_arr);
weight_dir = {};
weight_file = {};
Nele = 19;
Nbins = 500;
Nbeams = 1900;
Npol = 2;
w_sessions = zeros(sess, Npol, Nele, Nbeams, Nbins);
for i = 1:sess
    weight_dir{i} = sprintf('%s/%s/BF/mat/',data_root,sessions_arr{i});
    for p_idx = 1:Npol
        if p_idx == 1
            pol = 'X';
        else
            pol = 'Y';
        end
        weight_file{p_idx, i} = sprintf('%s%s_aggregated_weights_%s_grid.mat', weight_dir{i}, sessions_arr{i}, pol);
        load(weight_file{p_idx, i});
        w_sessions(i,p_idx,1:size(w_agg,1),1:size(w_agg,2),1:size(w_agg,3)) = w_agg;
    end
end

% Get the max normalized amplitude for each session for each dipole at bin 101
max_weights = zeros(sess, Npol, size(w_sessions,3),200);
for i = 1:sess
    session = strrep(sessions_arr{i}, '_', '\_');
    source = sources_arr{i};
    figure(i);
    for p_idx = 1:Npol
        for b = 1:200
            for h = 1:size(w_sessions,3)
                % max_weights(i,p_idx,h) = max(abs(w_sessions(i,p_idx,h,:,101)));
                max_weights(i,p_idx,h,b) = max(abs(w_sessions(i,p_idx,h,:,b).^2));
            end
            if p_idx == 1
                plot(squeeze(max_weights(i,p_idx,:,b))./max(squeeze(max_weights(i,p_idx,:,b))), 'bo');
            else
                plot(squeeze(max_weights(i,p_idx,:,b))./max(squeeze(max_weights(i,p_idx,:,b))), 'ro');
            end
            hold on;
        end
    end
    hold off;
    grid on;
    title(sprintf('Normalized weight amplitude vs. dipole number (Proj ID: %s, Source: %s)', session, source));
    xlabel('Dipole number');
    ylabel('Normalized amplitude');
    ylim([0, 1.05]);
%     legend('X-polarization','Y-polarization');
end






