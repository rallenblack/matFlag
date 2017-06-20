clearvars;
close all;

addpath ../kernel/
scan_table; % Found in kernel directory
source_table; % Found in kernel directory
onoff_table; % Found in local directory

for i = 1:size(onoffs, 1)
    session  = onoffs{i,1};
    on_scan  = onoffs{i,2};
    off_scan = onoffs{i,3};
    source   = onoffs{i,4};
    LO_freq  = onoffs{i,5};
    
    fprintf('Processing %s - scans %d-%d\n', session.session_name,...
                                             on_scan, off_scan);
                                         
    proj_str = session.session_name;
    save_dir = sprintf('%s/%s/BF', data_root, proj_str);
    
    
    [Tsys_eta_X, Tsys_eta_Y, freqs, wX, wY] = get_onoff_tsys(session,...
                                                             on_scan,...
                                                             off_scan,...
                                                             source,...
                                                             LO_freq);                                      
    
    % Create figures
    tsysX_fig = figure();
    plot(freqs,real(Tsys_eta_X).');
    title('T_s_y_s/\eta_a_p vs Frequency');
    xlabel('Frequency (MHz)');
    ylabel('T_s_y_s/\eta_a_p (K)');
    grid on;
    
    tsysY_fig = figure();
    plot(freqs,real(Tsys_eta_Y).');
    title('T_s_y_s/\eta_a_p vs Frequency');
    xlabel('Frequency (MHz)');
    ylabel('T_s_y_s/\eta_a_p (K)');
    grid on;

    % Save figure
    [~] = mkdir('figures');
    tsys_filename = sprintf('figures/%s_scans%d_%d_Xpol_tsys',...
        session.session_name, on_scan, off_scan);
    saveas(tsysX_fig, sprintf('%s.png', tsys_filename));
    saveas(tsysX_fig, sprintf('%s.pdf', tsys_filename));
    saveas(tsysX_fig, sprintf('%s.eps', tsys_filename));
    saveas(tsysX_fig, sprintf('%s.fig', tsys_filename), 'fig');
    
    % Save the Tsys spectrum data
    Tsys_eta = Tsys_eta_X;
    save(sprintf('%s.mat', tsys_filename), 'Tsys_eta', 'freqs');
    
    tsys_filename = sprintf('figures/%s_scans%d_%d_Ypol_tsys',...
        session.session_name, on_scan, off_scan);
    saveas(tsysY_fig, sprintf('%s.png', tsys_filename));
    saveas(tsysY_fig, sprintf('%s.pdf', tsys_filename));
    saveas(tsysY_fig, sprintf('%s.eps', tsys_filename));
    saveas(tsysY_fig, sprintf('%s.fig', tsys_filename), 'fig');
    
    % Save the Tsys spectrum data
    Tsys_eta = Tsys_eta_X;
    save(sprintf('%s.mat', tsys_filename), 'Tsys_eta', 'freqs');

    % Create weight file
    wX_padded = zeros(size(wX, 1), 7, size(wX,3));
    wX_padded(:,1,:) = wX;
    wX_padded(:,2,:) = wX;
    wX_padded(:,3,:) = wX;
    wX_padded(:,4,:) = wX;
    wX_padded(:,5,:) = wX;
    wX_padded(:,6,:) = wX;
    wX_padded(:,7,:) = wX;
    
    wY_padded = zeros(size(wY, 1), 7, size(wY,3));
    wY_padded(:,1,:) = wY;
    wY_padded(:,2,:) = wY;
    wY_padded(:,3,:) = wY;
    wY_padded(:,4,:) = wY;
    wY_padded(:,5,:) = wY;
    wY_padded(:,6,:) = wY;
    wY_padded(:,7,:) = wY;

    az = zeros(7,1);
    el = zeros(7,1);

    create_weight_file(az, el, wX_padded, wY_padded,...
        sprintf('%s_scans%d_%d', session.session_name, on_scan, off_scan),...
        session.goodX, session.goodY,...
        sprintf('%s/w_%s_scans%d_%d.bfw', save_dir,...
                session.session_name, on_scan, off_scan));
end