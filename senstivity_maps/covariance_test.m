% load('/lustre/flag/AGBT17B_360_01/BF/mat/2018_01_27_15:41:57.mat');
% load('/lustre/flag/AGBT17B_360_02/BF/mat/2018_01_27_18:34:28.mat');
load('/lustre/flag/AGBT17B_360_03/BF/mat/2018_01_28_07:14:41.mat');
% load('/lustre/flag/AGBT17B_360_04/BF/mat/2018_01_29_08:29:59.mat');
% load('/lustre/flag/AGBT17B_360_05/BF/mat/2018_01_30_12:11:32.mat');
% load('/lustre/flag/AGBT17B_360_06/BF/mat/2018_02_03_20:35:45.mat');
% load('/lustre/flag/AGBT17B_360_07/BF/mat/2018_02_05_06:41:19.mat');

X_pol = [1:7, 35, 9:12, 14, 13, 15:19];
Y_pol = [21, 20, 23:34, 36:38];

for nb = 1:500
% R3(nb) = mean(diag(R(X_pol,X_pol,nb)),1);
R3(nb) = mean(diag(R(Y_pol,Y_pol,nb)),1);
end

% fr = (-249:250)*303.75e-3 +1450;
fr = 1:500;

R3(250) = NaN;
% plot(fr,abs(R3).^2);
plot(fr,10*log10(abs(R3).^2));
grid on;
title('AGBT17B\_360\_04 - 3C295');
xlabel('Frequency (MHz)');
ylabel('Power (arb. units)');