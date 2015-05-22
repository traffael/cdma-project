function P_mult = mult4(P)
    %P = randi([0,1],1,1000);
    P_new = reshape(P,length(P),1);
    P_quatr = [P_new P_new P_new P_new];
    P_mult = [];
    for i =1:length(P)
        P_mult = [P_mult P_quatr(i,1:4)];
    end;
end