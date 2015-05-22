% Wireless Receivers II - Assignment 1:
%
% Direct Sequence Spread Spectrum Simulation Framework
%
% Telecommunications Circuits Laboratory
% EPFL


function BER = simulator(P)

Results = zeros(1,length(P.SNRRange));
N = 24576;
for ii = 1:1
    ii
%%-------------------------------------------------------------------------     
    % Coding
    %bits = randi([0 1],1,P.NumberOfBits); % Random Data
    bits = randi([0,1],1,P.NumberOfBits);
    bits_tail = add_enc_tail(bits); % adding a tail
    c = conv_enc(bits_tail);  %convolutional encoding
%%-------------------------------------------------------------------------
    % Orthogonal modulation
    c_ortogonal = orthogonalModulation(c);
    
    % Bits repetition  
    c_mult = mult4(c_ortogonal);
    
    % Spreading match filter  
    mwaveform=spread_match_filter(c_mult);
    
    %mwaveform = 1-2*mwaveform ;
%%------------------------------------------------------------------------- 
    % Channel
    switch P.ChannelType
        case 'AWGN',
            h = ones(1,length(mwaveform),P.RX);
        case 'Fading',
            h = channel(P.RX,length(mwaveform),1,P.CoherenceTime,1);
        case 'Multipath',
            NumberOfBitsRX   = length(mwaveform)+P.ChannelLength-1;
            himp = sqrt(1/2)* ( randn(1,P.ChannelLength) + 1i * randn(1,P.ChannelLength) ); % channel has imaginary stuff?
            h = himp(1)*ones(1,NumberOfBitsRX,P.RX);
            
        otherwise,
            disp('Channel not supported')
    end
    
%%------------------------------------------------------------------------- 
    % Simulation
    for ss = 1:length(P.SNRRange)
        ss
        SNRdb  = P.SNRRange(ss);
        SNRlin = 10^(SNRdb/10);
        noise  = 1/sqrt(2*SNRlin) *( randn(1,NumberOfBitsRX,P.RX) + 1i* randn(1,NumberOfBitsRX,P.RX) );
        % Channel
        switch P.ChannelType
            case 'AWGN',
                y = mwaveform;% + noise';
            case 'Fading',
                y = mwaveform .* h + noise;
            case 'Multipath'
                y = conv(mwaveform,himp) + noise';
            otherwise,
                disp('Channel not supported')
        end
        
 
        
%%-------------------------------------------------------------------------         
        % Receiver
        % what is P.sequence ? 
        switch P.ReceiverType
            case 'Simple',
                x_hat = y;                
            case 'Rake',
                rxsymbols=zeros(24576,1);
                for f=1:P.RakeFingers
                    ycrop = y(f:N+f-1);
                    rxsymbols = rxsymbols+ycrop*conj(himp(f));
                end
                x_hat = reshape(rxsymbols(1:N) < 0,1,N);
            otherwise,
                disp('Source Encoding not supported')
        end
          
%%-------------------------------------------------------------------------
        rxbits_despread=despread_match_filter(x_hat);
        sum1 = sum(rxbits_despread ~= c_mult');
        % Orthogonal demodulation
        rxbits_demodul = demult4(rxbits_despread);
        sum2 = sum(rxbits_demodul ~= c_ortogonal');
        demodwaveform = orthogonalDemodulation(rxbits_demodul);  
        sum3 = sum(demodwaveform ~= c);      
        %demodwaveform1 = x_hat;
        
        deconvwaveform = 1-2*demodwaveform ;
        
%%------------------------------------------------------------------------- 
        % conv. Decoder
        rxbits = conv_dec(deconvwaveform,length(bits_tail));
        % BER count
        rxbits = rxbits(1:P.NumberOfBits);
        errors =  sum(rxbits ~= bits');
        
        Results(ss) = Results(ss) + errors;
        
    end
end

%BER = Results/(P.NumberOfBits*P.NumberOfFrames);
BER = Results/(P.NumberOfBits);



    
             
