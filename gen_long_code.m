function Long_c = gen_long_code(ESN, P)
%%generates the PN-sequence according to the IS95 standard.
% ESN           : initial state for each user
% useIS95Walsh  : boolean, 1 if the standard Walsh mapping is used as
%                   defined in the IS95 standard. 0 if
%                   orthogonalMIMO(De)modulation function is used.

if(P.useIS95Walsh)
    code_length = (P.NumberOfBits+P.codeLength)/P.codeRate*P.hadamardLength/P.nMIMO/6*4; %multiplication factor 4, walsh mapping 6->64
else
    code_length = (P.NumberOfBits+P.codeLength)/P.codeRate*P.hadamardLength/P.nMIMO;
end

Public_log_code_mask = [ESN 0 0 0 1 1 0 0 0 1 1];
Generator_state = [1; zeros(41,1)];
Polinomial = [1 1 1 1 0 1 1 1 0 0 1 0 0 0 0 0 1 1 1 1 0 1 1 0 0 1 1 1 0 0 0 1 0 1 0 1 0 0 0 0 0 1];
Long_c = zeros(code_length,1);
for i = 1:code_length
    if Generator_state(42) == 1
        Generator_state = xor(Generator_state, Polinomial');
    end;
    Generator_state = [Generator_state(42); Generator_state(1:41)];
    Long_c(i) = mod(sum(Generator_state.*Public_log_code_mask'),2);
end;
Long_c=1-2*Long_c(:);
end