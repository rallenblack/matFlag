function [ delta_n, residual ] = compute_delay(R, faxis, fs, ref_el)

% R is a element x element x freq bin covariance matrix
Nel = size(R,1);
Nchans = size(R,3);

if Nchans ~= length(faxis)
    error('faxis not the same length as frequency bins in R');
end

residual = zeros(1,Nel);
delta_n = zeros(1,Nel);

good_chans = 40:170;

for el_idx = 1:Nel
    % compute magnitude for first row of correlation matrix
    mag = abs(squeeze(R(ref_el,el_idx,:)));
    
    % compute phase for first row of correlation matrix
    phi = angle(squeeze(R(ref_el,el_idx,:)));
    phi(mag == 0) = NaN;

    % determine how much phase to add to unwrap
    first_diff = phi(1:end - 1) - phi(2:end);
    neg_idx = find(first_diff < -pi);
    pos_idx = find(first_diff > pi);
    unwraps = zeros(size(phi));
    for i = 1:length(neg_idx)
        unwraps(neg_idx(i)+1:end) = unwraps(neg_idx(i)+1:end) - 2*pi;
    end
    for i = 1:length(pos_idx)
        unwraps(pos_idx(i)+1:end) = unwraps(pos_idx(i)+1:end) + 2*pi;
    end
    
    % unwrap
    phi = phi + unwraps;
    
    % construct frequency vector to solve for ramps
    good_idx = find(~isnan(phi));
    good_idx = intersect(good_idx, good_chans);
    F = [ones(length(good_idx),1), faxis(good_idx).'];
    phi1 = phi(good_idx);
    
%     %Plot unwrapped phase...
    if 1
        figure(1);
        subplot(2,1,1);
        plot(faxis(good_idx)/1e6, 20*log10(mag(good_idx))); grid on;
        title(sprintf('Magnitude of Cross-Correlation, Elements %d/%d', ref_el, el_idx));
        xlabel('Frequency (MHz)');
        ylabel('Power (dB, arb. units)');
        subplot(2,1,2);
        plot(faxis(good_idx)/1e6, phi(good_idx)); grid on;
        title(sprintf('Relative Phase Elements %d/%d', ref_el, el_idx));
        xlabel('Frequency (MHz)');
        ylabel('Phase (rad)');
        keyboard;
    end

    % solve for ramps and errors
    a_b = F\phi1;
    
    % Get residuals
    residual(el_idx) = norm(F*a_b - phi1)^2;

    % compute delays from ramps
    delta_n(el_idx) = a_b(2)/(2*pi)*fs;
end

