% Aggreg

clearvars;
close all;

addpath ../kernel/
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
     
pol = ['X', 'Y'];

% raw_fig = figure();
line_col = ['b', 'c','k','g', 'r', 'm']; %['b', 'r', 'k', 'g','m','c'];
Tsys_eta_pol = zeros(2,500);
Nsamp_window = 20;
overlay_plot = figure();
hold on;
for pol_idx = 1:length(pol)
    Tsys_broad = [];
    freqs_broad = [];
    for scan = 1:length(scans)
        filename = sprintf('figures/%s_scans%d_%d_%spol_tsys.mat',...
            session.session_name, scans{scan}(1), scans{scan}(2), pol(pol_idx));
        
        load(filename);
        fr = freqs;
        % Prune bandpass edges
        Tsys_eta(1:90) = NaN;
%         Tsys_eta(end:-1:end-89) = NaN;
        Tsys_eta(end-89:end) = NaN;
        Tsys_eta(Tsys_eta == Inf) = NaN;
        Tsys_eta(Tsys_eta < 25) = NaN;
        
        Nwindows = floor(length(Tsys_eta)/Nsamp_window);
        for w = 1:Nwindows
            Tsys_eta_window = real(Tsys_eta((w-1)*Nsamp_window+1:w*Nsamp_window));
            mu = mean(Tsys_eta_window, 'omitnan');
            sigma = std(Tsys_eta_window - mu, 'omitnan');
            Tsys_eta_window(abs(Tsys_eta_window - mu) > 1.0*sigma) = NaN;
            Tsys_eta((w-1)*Nsamp_window+1:w*Nsamp_window) = Tsys_eta_window;
        end
        
        % Plot initial bandpass
%         figure(raw_fig);
        h(pol_idx,scan) = plot(freqs,real(Tsys_eta).', ['-',line_col(pol_idx)]);
        Tsys_broad = [Tsys_broad, Tsys_eta.'];
        freqs_broad = [freqs_broad, freqs];
    end
    Tsys_filename = sprintf('Tsys_Aug_2017_%s_pol.mat', pol(pol_idx));
    fprintf('Saving Tsys data points to %s\n', Tsys_filename);
    save(Tsys_filename, 'Tsys_broad', 'freqs_broad');
end

session = AGBT16B_400_05;
scans_05 = {[4, 5],...
         [6, 7],...
         [8, 9],...
         [10, 11],...
         [12, 13],...
         [14, 15],...
         [16, 17],...
         [19, 20]};

for pol_idx = 1:length(pol)
    Tsys_broad = [];
    freqs_broad = [];
    for scan = 1:length(scans_05)
        filename = sprintf('figures/%s_scans%d_%d_%spol_tsys.mat',...
            session.session_name, scans_05{scan}(1), scans_05{scan}(2), pol(pol_idx));
        
        load(filename);
        fr = freqs;
        % Prune bandpass edges
        Tsys_eta(1:90) = NaN;
%         Tsys_eta(end:-1:end-89) = NaN;
        Tsys_eta(end-89:end) = NaN;
        Tsys_eta(Tsys_eta == Inf) = NaN;
        Tsys_eta(Tsys_eta < 25) = NaN;
        
        Nwindows = floor(length(Tsys_eta)/Nsamp_window);
        for w = 1:Nwindows
            Tsys_eta_window = real(Tsys_eta((w-1)*Nsamp_window+1:w*Nsamp_window));
            mu = mean(Tsys_eta_window, 'omitnan');
            sigma = std(Tsys_eta_window - mu, 'omitnan');
            Tsys_eta_window(abs(Tsys_eta_window - mu) > 1.0*sigma) = NaN;
            Tsys_eta((w-1)*Nsamp_window+1:w*Nsamp_window) = Tsys_eta_window;
        end
        
        % Plot initial bandpass
%         figure(raw_fig);
        h1(pol_idx,scan) = plot(freqs,real(Tsys_eta).', ['-',line_col(pol_idx+2)]);
        Tsys_broad = [Tsys_broad, Tsys_eta.'];
        freqs_broad = [freqs_broad, freqs];
    end
    Tsys_filename1 = sprintf('Tsys_May_2017_%s_pol.mat', pol(pol_idx));
    fprintf('Saving Tsys data points to %s\n', Tsys_filename1);
    save(Tsys_filename1, 'Tsys_broad', 'freqs_broad');
end


session = AGBT17B_360_06;
scans_06 = {[5,13],...
         [14,22],...
         [23,31],...
         [32,40],...
         [41,49],...
         [50,58],...
         [62,70]};

for pol_idx = 1:length(pol)
    Tsys_broad = [];
    freqs_broad = [];
    for scan = 1:length(scans_06)
        filename = sprintf('figures/%s_scans%d_%d_%spol_tsys.mat',...
            session.session_name, scans_06{scan}(1), scans_06{scan}(2), pol(pol_idx));
        
        load(filename);
        fr = freqs;
        % Prune bandpass edges
%         [~,max_idx] = max(Tsys_eta(maxSens_idx(pol_idx),:)); 
        Tsys_eta(maxSens_idx(pol_idx),250) = NaN;
        Tsys_eta(1:90) = NaN;
        Tsys_eta(Tsys_eta > 140) = NaN;
%         Tsys_eta(end:-1:end-89) = NaN;
        Tsys_eta(end-89:end) = NaN;
        Tsys_eta(Tsys_eta == Inf) = NaN;
        Tsys_eta(Tsys_eta < 23) = NaN;
        
        Nwindows = floor(length(Tsys_eta)/Nsamp_window);
        for w = 1:Nwindows
            Tsys_eta_window = real(Tsys_eta((w-1)*Nsamp_window+1:w*Nsamp_window));
            mu = mean(Tsys_eta_window, 'omitnan');
            sigma = std(Tsys_eta_window - mu, 'omitnan');
            Tsys_eta_window(abs(Tsys_eta_window - mu) > 1.0*sigma) = NaN;
            Tsys_eta((w-1)*Nsamp_window+1:w*Nsamp_window) = Tsys_eta_window;
        end
        
        % Plot initial bandpass
%         figure(raw_fig);
        h2(pol_idx,scan) = plot(freqs,real(Tsys_eta(maxSens_idx(pol_idx),:)).', ['-',line_col(pol_idx+4)]);
        Tsys_broad = [Tsys_broad, Tsys_eta(maxSens_idx(pol_idx),:)];
        freqs_broad = [freqs_broad, freqs];
    end
    Tsys_filename2 = sprintf('Tsys_Feb_2018_%s_pol.mat', pol(pol_idx));
    fprintf('Saving Tsys data points to %s\n', Tsys_filename2);
    save(Tsys_filename2, 'Tsys_broad', 'freqs_broad');
end

%%%%% GBT model %%%%%%%%

linewidth = 2.3;
fontsize = 12;

% Load files from GBT2
load Results_Diff_GBT2
w1 = zeros(1,38);
Tsys_etaX_GBT2 = TsysX./eta_apX;
Tsys_etaY_GBT2 = TsysY./eta_apY;
frequency_GBT2 = frequency;
% Interpolate
freq_gb = interp(frequency_GBT2(1:10),50);
freq_gb = freq_gb*1e-6;
Tsys_etaX_gb = interp(Tsys_etaX_GBT2(1:10),50);
Tsys_etaY_gb = interp(Tsys_etaY_GBT2(1:10),50);

h3(1,1) = plot(freq_gb, Tsys_etaX_gb, 'color', [0.8 0.8 0.8], 'LineWidth',linewidth);
h3(2,1) = plot(freq_gb, Tsys_etaY_gb, 'color', [0.5 0.5 0.5], 'LineWidth',linewidth);

% figure(1)
% plot(frequency_GBT2/1e9,Tsys_etaX_GBT2(:,1),'r*-','LineWidth',linewidth)
% hold on
% plot(frequency_GBT2/1e9,Tsys_etaY_GBT2(:,1),'rs-','LineWidth',linewidth)
% plot(frequency_Kite/1e9,Tsys_etaX_Kite(:,1),'b*-','LineWidth',linewidth)
% plot(frequency_Kite/1e9,Tsys_etaY_Kite(:,1),'bs-','LineWidth',linewidth)
% grid on
% xlabel('Frequency (GHz)','FontSize',fontsize)
% ylabel('T_s_y_s/\eta_a_p (K)','FontSize',fontsize)
% legend('GBT2 X','GBT2 Y','Kite X','Kite Y')
% xlim([1 1.9])
% ylim([20 46])
% set(gca,'FontSize',fontsize)


%%%%% Anish model %%%%%%

Tsys_eta_an =[60.692891, 45.533352, 36.102321, 28.368804, ...
              25.805023, 30.784875, 50.606389, 91.465503, ...
              183.708646, 368.815333, 546.192739];
freq_an = (1000:100:2000);

Tsys_eta_int = interp(Tsys_eta_an(1:10),50);
freq_int = interp(freq_an(1:10),50);

h4(1,1) = plot(freq_int, Tsys_eta_int, 'color', [0.5 0.8 0.8], 'LineWidth',linewidth);


hold off;
title('T_s_y_s/\eta vs Frequency');
xlabel('Frequency (MHz)');
ylabel('T_s_y_s/\eta (K)');
% legend([h1(1,1),h1(2,1),h(1,1),h(2,1),h2(1,1),h2(2,1),h3(1,1),h3(2,1)], {'400-05 - X', '400-05 - Y', ...
%     '400-13 - X', '400-13 - Y','360-06 - X', '360-06 - Y', ...
%     'GBT2 model - X', 'GBT2 model - Y'});
[lpos, ~] = legend([h1(1,1),h1(2,1),h(1,1),h(2,1),h2(1,1),h2(2,1),h3(1,1),h3(2,1), h4(1,1)], {'May 2017 - X', 'May 2017 - Y', ...
    'Aug 2017 - X', 'Aug 2017 - Y','Feb 2018 - X', 'Feb 2018 - Y', ...
    'GBT2 model - X', 'GBT2 model - Y', 'NRAO model'});
set(lpos,'position',[0.5,0.75,0,0]); % bottom,top,width,height
xlim([1000, 1725]);
ylim([0, 200]);
grid minor;
grid on;

fig_filename = 'new_overlay_tsys';
print('-dpng', '-r0', sprintf('%s.png', fig_filename)); % increase resolution with print(fileType,resolution(dpi),filename)
saveas(overlay_plot, sprintf('%s.png', fig_filename));
saveas(overlay_plot, sprintf('%s.pdf', fig_filename));
saveas(overlay_plot, sprintf('%s.eps', fig_filename));
saveas(overlay_plot, sprintf('%s.fig', fig_filename), 'fig');

% Plot pruned Tsys/eta
% figure(raw_fig);
% legend('X', 'Y');

% fig_filename = sprintf('figures/%s_overlaybroad_%spol_tsys',...
%         session.session_name, pol);
% saveas(overlay_plot, sprintf('%s.png', fig_filename));
% saveas(overlay_plot, sprintf('%s.pdf', fig_filename));
% saveas(overlay_plot, sprintf('%s.eps', fig_filename));
% saveas(overlay_plot, sprintf('%s.fig', fig_filename), 'fig');
