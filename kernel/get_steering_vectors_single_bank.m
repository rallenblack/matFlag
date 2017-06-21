function a = get_steering_vectors_single_bank(Ron, Roff, good_idx, xid, bad_freqs, save_dir, tmp_stmp, pol, overwrite)
    
    filename = sprintf('%s/%s_steering_vectors_%s.mat', save_dir, tmp_stmp, pol);

    if ~exist(filename, 'file') || overwrite == 1
    
        Nele = length(good_idx);
        Npoints = size(Ron,4);
        Nbins = size(Ron,3);
        chans = [1:5, 101:105, 201:205, 301:305, 401:405] + 5*xid;
        a = zeros(Nele, Npoints, Nbins);
        for t = 1:size(Ron,4)
            fprintf('%d', t);
            bidx = 1;
            for b = chans
                if sum(bad_freqs == b) == 0
                    [a(:,t,bidx), d] = eigs(Ron(good_idx, good_idx, bidx, t),...
                                            Roff(good_idx, good_idx, bidx), 1);
                    a(:,t,bidx) = Roff(good_idx, good_idx, bidx)*a(:,t,bidx)*sqrt(d)/norm(a(:,t,bidx));
                end
                bidx = bidx + 1;
            end
        end
        save(filename, 'a');
    else
        load(filename);
    end

end