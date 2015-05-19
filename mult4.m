function P_mult = mult4(P)
    P = randi([0,1],1,1000);
    P_new = reshape(P,length(P),1);
    P_quatr = [P_new P_new P_new P_new];
    P_mult = reshape(P_quatr,length(P_quatr)*4,1);
end