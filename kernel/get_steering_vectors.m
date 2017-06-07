function a = get_steering_vectors(Ron, Roff, good_idx, bad_freqs, save_dir, tmp_stmp, pol, overwrite)
    
    filename = sprintf('%s/%s_steering_vectors_%s.mat', save_dir, tmp_stmp, pol);

    if ~exist(filename, 'file') || overwrite == 1
    
        Nele = length(good_idx);
        Npoints = size(Ron,4);
        Nbins = size(Ron,3);
        a = zeros(Nele, Npoints, Nbins);
        for t = 1:size(Ron,4)
            for b = 1:size(Ron,3)
                if sum(bad_freqs == b) == 0
                    [a(:,t,b), ~] = eigs(Ron(good_idx, good_idx, b, t),...
                                         Roff(good_idx, good_idx, b), 1);
                end
            end
        end
        save(filename, 'a');
    else
        load(filename);
    end

end