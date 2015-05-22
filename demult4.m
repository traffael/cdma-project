function P_demult = demult4(P)
    j = 1;
    for i = 1:6144
        P_new(i) = P(j);
        j = j + 4;
    end;
    P_demult = P_new;
end