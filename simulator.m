% Wireless Receivers II - Assignment 1:
%
% Direct Sequence Spread Spectrum Simulation Framework
%
% Telecommunications Circuits Laboratory
% EPFL


function BER = simulator(P)
SeqLen          = length(P.Sequence);
SpreadSequence  = sqrt(1/(sum(P.Sequence.^2))) * P.Sequence(:); % power normalization

% Coding
%switch P.CodingType
%    case 'None',
%        NumberOfBits = P.NumberOfSymbols*P.Modulation; % per Frame
%    otherwise,
%        disp('Source Encoding not supported')
%end

% Channel
%switch P.ChannelType
%    case 'Multipath',
%        NumberOfChipsRX   = NumberOfChips+P.ChannelLength-1;       
%end

Results = zeros(1,length(P.SNRRange));

for ii = 1:20

%%-------------------------------------------------------------------------     
    % Coding
    %bits = randi([0 1],1,P.NumberOfBits); % Random Data
    bits = ones(1,P.NumberOfBits);
    bits_tail = add_enc_tail(bits); % adding a tail
    c = conv_enc(bits_tail);  %convolutional encoding
    
    
%%-------------------------------------------------------------------------
    % Orthogonal modulation
    mwaveform = orthogonalModulation(c);
    
%%-------------------------------------------------------------------------    
    % Channel
    switch P.ChannelType
        case 'AWGN',
            h = ones(1,length(mwaveform),P.RX);
        case 'Fading',
            h = channel(P.RX,length(mwaveform),1,P.CoherenceTime,1);
        case 'Multipath',
            himp = sqrt(1/2)* ( randn(1,length(mwaveform)) + 1i * randn(1,length(mwaveform)) ); % channel has imaginary stuff?
            h = himp(1)*ones(1,P.NumberOfBits,P.RX);
        otherwise,
            disp('Channel not supported')
    end
    
%%------------------------------------------------------------------------- 
    % Simulation
    for ss = 1:length(P.SNRRange)
        SNRdb  = P.SNRRange(ss);
        SNRlin = 10^(SNRdb/10);
        noise  = 1/sqrt(2*SNRlin) *( randn(1,length(mwaveform),P.RX) + 1i* randn(1,length(mwaveform),P.RX) );
        % Channel
        switch P.ChannelType
            case 'AWGN',
                y = mwaveform + noise';
            case 'Fading',
                y = mwaveform .* h + noise;
            case 'Multipath'
                y = conv(mwaveform,himp) + noise;
            otherwise,
                disp('Channel not supported')
        end
        
 
        
%%-------------------------------------------------------------------------         
        % Receiver
        switch P.ReceiverType
            case 'Simple',
                x_hat_soft = y;
                rxbits = conv_dec(x_hat_soft,length(bits_tail));
                
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
        errors =  sum(rxbits ~= bits_tail');
        
        Results(ss) = Results(ss) + errors;
        
    end
end

BER = Results/(NumberOfBits*P.NumberOfFrames);



    
             
