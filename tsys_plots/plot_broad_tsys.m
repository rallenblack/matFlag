% Aggreg

clearvars;
close all;

scan_table;

session = AGBT16B_400_05;
scans = {[6,7],...
         [8,9],...
         [10,11],...
         [12,13],...
         [14,15],...
         [16,17]};
pol = 'Y';

raw_fig = figure();
pruned_fig = figure();

for scan = 1:length(scans)
    filename = sprintf('figures/%s_scans%d_%d_%spol_tsys.mat',...
        session.session_name, scans{scan}(1), scans{scan}(2), pol);
    
    load(filename);
    
    % Prune bandpass edges
    Tsys_eta(1:50) = NaN;
    Tsys_eta(end:-1:end-49) = NaN;
    
    % Plot initial bandpass
    figure(raw_fig);
    hold on;
    plot(freqs,real(Tsys_eta).');
    title('T_s_y_s/\eta_a_p vs Frequency');
    xlabel('Frequency (MHz)');
    ylabel('T_s_y_s/\eta_a_p (K)');
    grid on;
    hold off;
    
    % Prune some more
    Tsys_eta(Tsys_eta == Inf) = NaN;
    mu = mean(real(Tsys_eta), 'omitnan');
    sigma = std(real(Tsys_eta) - mu, 'omitnan');
    Tsys_eta(abs(Tsys_eta - mu) > 2*sigma) = NaN;
    
    % Plot pruned data
    figure(pruned_fig);
    hold on;
    plot(freqs,real(Tsys_eta).');
    title('T_s_y_s/\eta_a_p vs Frequency');
    xlabel('Frequency (MHz)');
    ylabel('T_s_y_s/\eta_a_p (K)');
    grid on;
    hold off;
end

figure(raw_fig);
xlim([1000, 1725]);
ylim([25, 100]);
grid minor;
figure(pruned_fig);
xlim([1000, 1725]);
ylim([25, 100]);
grid minor;

fig_filename = sprintf('figures/%s_broadband_%spol_tsys',...
        session.session_name, pol);
saveas(raw_fig, sprintf('%s.png', fig_filename));
saveas(raw_fig, sprintf('%s.pdf', fig_filename));
saveas(raw_fig, sprintf('%s.eps', fig_filename));
saveas(raw_fig, sprintf('%s.fig', fig_filename), 'fig');

fig_filename = sprintf('figures/%s_broadband_pruned_%spol_tsys',...
        session.session_name, pol);
saveas(pruned_fig, sprintf('%s.png', fig_filename));
saveas(pruned_fig, sprintf('%s.pdf', fig_filename));
saveas(pruned_fig, sprintf('%s.eps', fig_filename));
saveas(pruned_fig, sprintf('%s.fig', fig_filename), 'fig');