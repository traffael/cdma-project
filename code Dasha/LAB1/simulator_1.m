% Wireless Receivers II - Assignment 1:
%
% Direct Sequence Spread Spectrum Simulation Framework
%
% Telecommunications Circuits Laboratory
% EPFL


function BER = simulator(P)

SeqLen          = length(P.Sequence);
SpreadSequence  = sqrt(1/(sum(P.Sequence.^2))) * P.Sequence(:); % power normalization
NumberOfChips   = P.NumberOfSymbols*P.Modulation*SeqLen; % per Frame

% Coding
switch P.CodingType
    case 'None',
        NumberOfBits = P.NumberOfSymbols*P.Modulation; % per Frame
    otherwise,
        disp('Source Encoding not supported')
end

NumberOfChipsRX = NumberOfChips;
% Channel
switch P.ChannelType
    case 'Multipath',
        NumberOfChipsRX   = NumberOfChips+P.ChannelLength-1;       
end

Results = zeros(1,length(P.SNRRange));

for ii = 1:P.NumberOfFrames/20
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
            symbols = -(2*bits - 1);
        otherwise,
            disp('Modulation not supported')
    end
    
    % Pulse Shape
    waveform = SpreadSequence*symbols;
    
    % Reshape to add multi RX antenna suppport
    waveform  = reshape(waveform,1,NumberOfChips);
    mwaveform = zeros(1,NumberOfChips,0);
    for i=1:P.RX
        mwaveform = cat(3,mwaveform,waveform);
    end
    
    % Channel
    switch P.ChannelType
        case 'AWGN',
            h = ones(1,NumberOfChips,P.RX);
            %P.SNRRange = EbN0shift(P);
        case 'Fading',
            h = channel(P.RX,NumberOfChips,1,P.CoherenceTime,1);
        case 'Multipath',
            himp = sqrt(1/2)* ( randn(1,P.ChannelLength) + 1i * randn(1,P.ChannelLength) );
            h = himp(1)*ones(1,NumberOfChipsRX,P.RX);
            %P.SNRRange = EbN0shift(P);
        otherwise,
            disp('Channel not supported')
    end
    
    %%%
    % Simulation
  
    % SNR Range
    for ss = 1:length(P.SNRRange)
        SNRdb  = P.SNRRange(ss) ;%
        SNRlin = 10^(SNRdb/10);
        noise  = 1/sqrt(2*SeqLen*SNRlin) *( randn(1,NumberOfChipsRX,P.RX) + 1i* randn(1,NumberOfChipsRX,P.RX) );
        % Channel
        switch P.ChannelType
            case 'AWGN',
                y = mwaveform + noise;
            case 'Fading',
                y = mwaveform .* h + noise;
            case 'Multipath'
                y = conv(mwaveform,himp) + noise;
            otherwise,
                disp('Channel not supported')
        end
        
 
        % Receiver
        switch P.ReceiverType
            case 'Simple',
                rxsymbols = y.*conj(sign(h)); % phase correction
                rxbits = reshape(rxsymbols < 0,1,P.NumberOfSymbols);
            case 'Correlator',
                rssum = zeros(1000,1);
                rxsymbols = y.*conj(sign(h)); % phase correction
                rxsymbols = reshape(rxsymbols,length(P.Sequence),1000);
                for i = 1:1000
                    for j= 1 : length(P.Sequence)
                         rssum(i) = rssum(i)+rxsymbols(j,i)*conj(sign(SpreadSequence(j)));
                    end;
                end;
                rssum = rssum./ length(P.Sequence);
                rxbits = reshape(rssum < 0,1,P.NumberOfSymbols);
            case 'Rake',
                rxsymbols = y.*conj(sign(h));
                x = P.RakeFingers;
                MATR1 = cat(2,P.Sequence,P.Sequence);
                for i = 1:9
                    MATR1 = cat(2,MATR1,MATR1);
                end;
                S = zeros(x,1000);
                N = SeqLen*P.NumberOfFrames;
                for i = 1:x
                    SUP = rxsymbols(i:N+i-1).*conj(sign(MATR1(1:7000)));
                    A = reshape(SUP,SeqLen,P.NumberOfFrames);
                    S(i,:) = sum(A);
                end;
                if x > 1
                    S = sum(S);
                end;
                S = S./ length(P.Sequence);
                rxbits = reshape(S < 0,1,P.NumberOfSymbols);
            otherwise,
                disp('Source Encoding not supported')
        end
        
        % BER count
        errors =  sum(rxbits ~= bits);
        
        Results(ss) = Results(ss) + errors;
        
    end
end

BER = Results/(NumberOfBits*P.NumberOfFrames);



    
             
