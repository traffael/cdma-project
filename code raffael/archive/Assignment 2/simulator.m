% Wireless Receivers II - Assignment 2:
%
% Diversity Simulation Framework
%
% Telecommunications Circuits Laboratory
% EPFL
function BER = simulator(P)

% Coding

switch P.CodingType
    case 'None',
        NumberOfBits = P.NumberOfSymbols*P.NumberOfCarriers*P.Modulation; % per Frame
    otherwise,
        disp('Source Encoding not supported')
end

Results = zeros(1,length(P.SNRRange));

for ii = 1:P.NumberOfFrames
    
    ii
    
    % Coding
    switch P.CodingType
        case 'None',
            bits = randi([0 1],1,NumberOfBits); % Random Data
        otherwise,
            disp('Source Encoding not supported')
    end
    
    % Modulation
    switch P.Modulation % Modulate Symbols
        case 1, % BPSK
            rawsymbols = -(2*bits - 1);
        otherwise,
            disp('Modulation not supported')
    end
    rawsymbols  = reshape(rawsymbols,P.NumberOfCarriers,P.NumberOfSymbols);
    symbols     = randn(P.NumberOfCarriers,P.NumberOfSymbols,0);
    for i=1:P.RX
        symbols = cat(3,symbols,rawsymbols);
    end
    
    % Channel
    switch P.ChannelType
        case 'AWGN',
            h = ones(P.NumberOfCarriers,P.NumberOfSymbols,P.RX);
        case 'Fading',
            h = channel(P.RX,P.NumberOfSymbols,P.NumberOfCarriers,P.CoherenceTime,P.CoherenceBandwidth);
        otherwise,
            disp('Channel not supported')
    end
    
    %%%
    % Simulation
    
    % SNR Range
    for ss = 1:length(P.SNRRange)
        SNRdb  = P.SNRRange(ss);
        SNRlin = 10^(SNRdb/10);
        noise  = 1/sqrt(SNRlin)*  1/sqrt(2) *( randn(P.NumberOfCarriers,P.NumberOfSymbols,P.RX) + 1i* randn(P.NumberOfCarriers,P.NumberOfSymbols,P.RX) );
        
        % Channel
        y = symbols .* h + noise;  
        
        % Receiver
        switch P.ReceiverType
            case 'Simple',
                rxsymbols = y.*conj(sign(h)); % phase correction
                rxbits = reshape(rxsymbols < 0,1,P.NumberOfCarriers*P.NumberOfSymbols); 
            otherwise,
                disp('Source Encoding not supported')
        end
        
        % BER count
        errors =  sum(rxbits ~= bits);
        
        Results(ss) = Results(ss) + errors;
        
    end
end

BER = Results/(NumberOfBits*P.NumberOfFrames);