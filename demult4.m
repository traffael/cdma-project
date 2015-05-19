function P_demult = demult4(P)
    P_new = reshape(P,length(P)/4,4);
    P_demult = P_new(:,1);
end