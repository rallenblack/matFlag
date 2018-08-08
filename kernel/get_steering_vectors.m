function a = get_steering_vectors(Ron, Roff, good_idx, bad_freqs, save_dir, tmp_stmp, pol, overwrite)
    
    filename = sprintf('%s/%s_steering_vectors_%s.mat', save_dir, tmp_stmp, pol);

    if ~exist(filename, 'file') || overwrite == 1
    
        Nele = length(good_idx);
        Npoints = size(Ron,4);
        Nbins = size(Ron,3);
        a = zeros(Nele, Npoints, Nbins);
        Ron1 = Ron(good_idx, good_idx, :, :);
        Roff1 = Roff(good_idx, good_idx, :);
        for t = 1:Npoints
            for b = 1:Nbins
                if sum(bad_freqs == b) == 0
                    Ron2  = (Ron1 (:,:,b,t) + Ron1 (:,:,b,t)')/2;
                    Roff2 = (Roff1(:,:,b)   + Roff1(:,:,b)'  )/2;
                    [V, e] = eig(Ron2, Roff2, 'vector');
                    [d, idx] = max(e);
                    v = V(:,idx);
%                     a(:,t,b) = Roff2*v*sqrt(d)/norm(v);
                    a(:,t,b) = Roff2*v;
                    a(:,t,b) = a(:,t,b)./norm(a(:,t,b)); % New addition, comment if there are any issues.
                end
            end
        end
        save(filename, 'a');
    else
        load(filename);
    end

end