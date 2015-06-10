function Long_c = Long_code(ESN, useIS95Walsh)
% ESN           : initial state for each user
% useIS95Walsh  : boolean, 1 if the standard Walsh mapping is used as
%                   defined in the IS95 standard. 0 if
%                   orthogonalMIMO(De)modulation function is used.

if(useIS95Walsh)
    dim1 = 256;
else
    dim1 = 256*3;
end

Public_log_code_mask = [ESN 0 0 0 1 1 0 0 0 1 1];
Initial_state = [1; zeros(41,1)];
Polinomial = [1 1 1 1 0 1 1 1 0 0 1 0 0 0 0 0 1 1 1 1 0 1 1 0 0 1 1 1 0 0 0 1 0 1 0 1 0 0 0 0 0 1];
Long_c = zeros(dim1,96);
for j = 1:96
    for i = 1:dim1 %% MODIF: *3 is because of different walsh modulation
        if Initial_state(42) == 1
            Initial_state = xor(Initial_state, Polinomial');
        end;
        Initial_state = [Initial_state(42); Initial_state(1:41)]; %modif: put this before the next line
        Long_c(i,j) = mod(sum(Initial_state.*Public_log_code_mask'),2);
        % Multiplying with spreading sequence
    end
end;
end