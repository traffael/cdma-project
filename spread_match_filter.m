function P_spread = spread_match_filter(P,Long_code)
    P1 = reshape(P,256,96);
    P_spread = zeros(size(P1));
    for j = 1:96
        P_spread(:,j) = xor(Long_code(:,j),P1(:,j));
    end;
    P_spread = reshape(P_spread,256*96,1);
end