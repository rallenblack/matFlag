% Aggreg

clearvars;
close all;

scan_table;

session = AGBT16B_400_13;
scans = {[112, 113],...
         [118, 119],...
         [120, 121],...
         [122, 123],...
         [124, 125],...
         [128, 129],...
         [130, 131],...
         [132, 133],...
         [134, 135]};
pol = 'Y';

raw_fig = figure();
pruned_fig = figure();

FREQS = [];
TSYS = [];
for scan = 1:length(scans)
    filename = sprintf('figures/%s_scans%d_%d_%spol_tsys.mat',...
        session.session_name, scans{scan}(1), scans{scan}(2), pol);
    
    load(filename);
    
    % Prune bandpass edges
    Tsys_eta(1:90) = NaN;
    Tsys_eta(end:-1:end-89) = NaN;
    
    % Plot initial bandpass
    figure(raw_fig);
    hold on;
    plot(freqs,real(Tsys_eta).', '-b');
    title('T_s_y_s/\eta_a_p vs Frequency');
    xlabel('Frequency (MHz)');
    ylabel('T_s_y_s/\eta_a_p (K)');
    grid on;
    hold off;
    
    % Prune some more
    Tsys_eta(Tsys_eta == Inf) = NaN;
    Tsys_eta(Tsys_eta < 25) = NaN;
    Nsamp_window = 20;
    Nwindows = floor(length(Tsys_eta)/Nsamp_window);
    for w = 1:Nwindows
        Tsys_eta_window = real(Tsys_eta((w-1)*Nsamp_window+1:w*Nsamp_window));
        mu = mean(Tsys_eta_window, 'omitnan');
        sigma = std(Tsys_eta_window - mu, 'omitnan');
        Tsys_eta_window(abs(Tsys_eta_window - mu) > 1.0*sigma) = NaN;
        Tsys_eta((w-1)*Nsamp_window+1:w*Nsamp_window) = Tsys_eta_window;
    end
    
    % Plot pruned data
    figure(pruned_fig);
    hold on;
    plot(freqs,real(Tsys_eta).', '-b');
    title('T_s_y_s/\eta_a_p vs Frequency');
    xlabel('Frequency (MHz)');
    ylabel('T_s_y_s/\eta_a_p (K)');
    grid on;
    hold off;
        
    % Save pruned data for fitting
    FREQS = [FREQS, freqs];
    TSYS = [TSYS, Tsys_eta.'];
end

% Plot pruned Tsys/eta
figure(raw_fig);
xlim([1000, 1725]);
ylim([0, 200]);
grid minor;
figure(pruned_fig);
xlim([1000, 1725]);
ylim([0, 200]);
grid minor;

% Low-order polynomial fit
FREQS = FREQS(~isnan(TSYS))./2e3;
TSYS = TSYS(~isnan(TSYS));
P = 10;
A = ones(length(FREQS),1);
for i = 1:P
    A = [A, (FREQS.').^i];
end
b = real(TSYS.');
x = A\b;

freqs_model = linspace(min(FREQS), max(FREQS), 1000);
Tsys_model = zeros(size(freqs_model));
for i = 1:P+1
    Tsys_model = Tsys_model + x(i)*freqs_model.^(i-1);
end
figure(pruned_fig);
hold on;
plot(freqs_model*2e3, Tsys_model, '--r'); hold off;
grid on;
grid minor;
xlim([1000, 1725]);
ylim([0, 200]);
hold off;

% Create custom legend
hold on;
h = zeros(2,1);
h(1) = plot(0, 0, '-b',  'visible', 'off');
h(2) = plot(0, 0, '--r', 'visible', 'off');
legend(h, 'Measured Tsys/eta', '10th Order Polynomial Fit');
hold off;

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