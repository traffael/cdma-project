function Long_c = Long_code(P)
    ESN = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
    Public_log_code_mask = [ESN 0 0 0 1 1 0 0 0 1 1];  
    Initial_state = [1; zeros(41,1)];
    Polinomial = [1 1 1 1 0 1 1 1 0 0 1 0 0 0 0 0 1 1 1 1 0 1 1 0 0 1 1 1 0 0 0 1 0 1 0 1 0 0 0 0 0 1];
    Long_c = zeros(256,96);
    for j = 1:96
        for i = 1:256
            if Initial_state(42) == 1
                Initial_state = xor(Initial_state, Polinomial');
            end;
            Initial_state = [Initial_state(42); Initial_state(1:41)]; %modif: put this before the next line
            Long_c(i,j) = mod(sum(Initial_state.*Public_log_code_mask'),2);
            % Multiplying with spreading sequence 
        end
    end;
end