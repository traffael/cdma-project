function P_spread = spread_match_filter(P)
    ESN = [0 0 1 0 1 0 1 0 1 1 1 1 0 1 1 1 0 0 0 0 1 1 0 1 0 1 1 0 1 0 1 1];
    Public_log_code_mask = [ESN 0 0 0 1 1 0 0 0 1 1];  
    Initial_state = [1; zeros(41,1)];
    Polinomial = [1 1 1 1 0 1 1 1 0 0 1 0 0 0 0 0 1 1 1 1 0 1 1 0 0 1 1 1 0 0 0 1 0 1 0 1 0 0 0 0 0 1];
    Long_code = zeros(42,1);
    for i = 1:length(P)
        if Initial_state(42) == 1
            Initial_state = xor(Initial_state, Polinomial');
        end;
        Long_code = mod(Initial_state.*Public_log_code_mask',2);
        Initial_state = [Initial_state(42); Initial_state(1:41)];
        % Multiplying with spreading sequence 
    end
    P_spread = reshape(Long_code,42*length(Long_code),1);
end