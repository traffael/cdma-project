function  [EbN0Range]  = EbN0shift(Sequence)
%
% The function takes the parameter variable P as a input
% and outputs the shifted Eb/N0 range corresponding to the 
% given SNR range. 
%
 
G = length(Sequence);

shift = 10*log10(G);

EbN0Range = Sequence - shift;