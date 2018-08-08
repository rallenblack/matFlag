% Read scan table for session information
addpath ../kernel/
scan_table;

% session = AGBT17B_360_04;
% goodY = session.goodY;
% goodX = session.goodX;
% note = 'seven';
% tstamp = AGBT17B_221_01.scans{5};

session = AGBT17B_360_05;
goodY = session.goodY;
goodX = session.goodX;
note = '1st_seven';

for i = 3:9
    tstamp = session.scans{i};
    
    proj_str = session.session_name;
    save_dir = sprintf('%s/%s/BF', data_root, proj_str);
    out_dir = sprintf('%s/mat', save_dir);
    
    R_filename = sprintf('%s/%s.mat',out_dir, tstamp);
    
    load(R_filename);
    
    pol = 'X';
    % note = 'grid';
    % Load in weight vectors
    out_dir = sprintf('%s/%s/BF/mat', data_root, session.session_name);
    filename = sprintf('%s/%s_aggregated_weights_%s_%s.mat', out_dir,...
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
    Nbeam = size(w_agg, 2);
    
    patterns = zeros(Nbeam, size(R,3));
    for beam = 1:Nbeam
        fprintf('Processing beam %d\n', beam);
        w1 = squeeze(w_agg(:,beam,:));
        for b = 1:size(R,3)
            
            Rtmp = squeeze(R(goodX,goodX,b));
            % w1 = ones(length(goodY), 500);
            %w1 = zeros(length(goodY), 500);
            %w1(10,:) = 1;
            patterns(beam,b) = abs(w1(:,b)'*Rtmp*w1(:,b));
        end
    end
    
    figure(i);
    plot(10*log10(patterns.'));
%     plot(patterns.');
    title(['Session 2 (360\_05) Correct Beams - seven-pt grid (Beam ', num2str(i-2), ')']);
    xlabel('Frequency bins');
    ylabel('Power (dB)');
    legend('1','2','3','4','5','6','7');
    grid on;
end


