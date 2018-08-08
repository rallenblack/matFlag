clearvars;

chan_idx = [1:5, 101:105, 201:205, 301:305, 401:405];

[R, ~, xid, info_table] = extract_covariances('/lustre/projects/flag/TMP/BF/2017_07_07_20:16:47C.fits');

chunks = chan_idx + 5*xid;

nbin = 25;
el_idx = 1;
spectra = squeeze(R(el_idx,el_idx,:,2));

figure(1); clf;
plot(0:length(spectra)-1, log10(abs(spectra))); grid on;
