function P_despread = despread_match_filter(P, Long_code)
    P2 = reshape(P,256,96);
    P_despread = zeros(size(P2));
    for j = 1:96
        P_despread(:,j) = xor(Long_code(:,j),P2(:,j));
    end;
    P_despread = reshape(P_despread,256*96,1);
end