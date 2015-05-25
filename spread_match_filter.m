function P_spread = spread_match_filter(P)
    %P = ones(256,96);
    P = reshape(P,256,96);
    P_spread = zeros(size(P));
    %P_despread = zeros(size(P));
    ESN = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
    Public_log_code_mask = [ESN 0 0 0 1 1 0 0 0 1 1];  
    Initial_state = [1; zeros(41,1)];
    Polinomial = [1 1 1 1 0 1 1 1 0 0 1 0 0 0 0 0 1 1 1 1 0 1 1 0 0 1 1 1 0 0 0 1 0 1 0 1 0 0 0 0 0 1];
    for j = 1:96
        Long_code = zeros(256,1);
        for i = 1:length(Long_code)
            if Initial_state(42) == 1
                Initial_state = xor(Initial_state, Polinomial');
            end;
            Initial_state = [Initial_state(42); Initial_state(1:41)]; %modif: put this before the next line
            Long_code(i) = mod(sum(Initial_state.*Public_log_code_mask'),2);
            % Multiplying with spreading sequence 
        end
        P_spread(:,j) = xor(Long_code,P(:,j));
    end;
    %error = sum(sum(P_despread ~= P));
    P_spread = reshape(P_spread,256*96,1);
end