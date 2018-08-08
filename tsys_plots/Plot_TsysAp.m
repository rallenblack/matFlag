clc;clear;close all;
linewidth = 1.5;
fontsize = 12;

% Load files from GBT2
load Results_Diff_GBT2
w1 = zeros(1,38);
Tsys_etaX_GBT2 = TsysX./eta_apX;
Tsys_etaY_GBT2 = TsysY./eta_apY;
frequency_GBT2 = frequency;

% Load files from Kite dipole array
load Results_Diff_GBT_Kite
Tsys_etaX_Kite = TsysX./eta_apX;
Tsys_etaY_Kite = TsysY./eta_apY;
frequency_Kite = frequency;

figure(1)
plot(frequency_GBT2/1e9,Tsys_etaX_GBT2(:,1),'r*-','LineWidth',linewidth)
hold on
plot(frequency_GBT2/1e9,Tsys_etaY_GBT2(:,1),'rs-','LineWidth',linewidth)
plot(frequency_Kite/1e9,Tsys_etaX_Kite(:,1),'b*-','LineWidth',linewidth)
plot(frequency_Kite/1e9,Tsys_etaY_Kite(:,1),'bs-','LineWidth',linewidth)
grid on
xlabel('Frequency (GHz)','FontSize',fontsize)
ylabel('T_s_y_s/\eta_a_p (K)','FontSize',fontsize)
legend('GBT2 X','GBT2 Y','Kite X','Kite Y')
xlim([1 1.9])
ylim([20 46])
set(gca,'FontSize',fontsize)

load HFSS_S11_S22_GBT2.txt
freq_GBT2 = HFSS_S11_S22_GBT2(:,1);
HFSS_S11_GBT2 = HFSS_S11_S22_GBT2(:,2) + j*HFSS_S11_S22_GBT2(:,3);
HFSS_S22_GBT2 = HFSS_S11_S22_GBT2(:,4) + j*HFSS_S11_S22_GBT2(:,5);
figure(2)
plot(freq_GBT2,20*log10(abs(HFSS_S11_GBT2)),'b-','LineWidth',linewidth);
hold on
plot(freq_GBT2,20*log10(abs(HFSS_S22_GBT2)),'b--','LineWidth',linewidth);

load Kite_S_Freq
plot(frequency_Kite/1e9,S11_Kite,'r-','LineWidth',linewidth)
plot(frequency_Kite/1e9,S22_Kite,'r--','LineWidth',linewidth)
xlabel('Frequency (GHz)','FontSize',fontsize)
ylabel('S11 Parameters (dB)','FontSize',fontsize)
legend('GBT2 X','GBT2 Y','Kite X','Kite Y')
set(gca,'FontSize',fontsize)
grid on





