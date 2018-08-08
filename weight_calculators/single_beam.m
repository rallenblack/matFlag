function wei = single_beam(Ron, Roff, Nbins, good_idx, bad_freqs)
    w = zeros(length(good_idx), Nbins);
    Nbin_Act = 500;
    Nele_Act = 64;
    wei = zeros(Nele_Act, Nbin_Act);
    for b = 1:size(Ron,3)
        bad_flag = sum(bad_freqs == b);
        if bad_flag
            w(:,b) = zeros(length(good_idx), 1);
        else
            [V,d] = eig(Ron(good_idx,good_idx,b), Roff(good_idx,good_idx,b), 'vector');
            [~,max_idx] = max(d);
            v = V(:,max_idx);
            w(:,b) = Roff(good_idx,good_idx,b)\v;
            w(:,b) = w(:,b)./(w(:,b)'*v);
        end
        wei(good_idx,b) = w(:,b);
    end
end