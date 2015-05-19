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
    c_ortogonal = orthogonalModulation(c);
    
    % Bits repetition  
    c_mult = mult4(c_ortogonal);
    
    % Spreading match filter  
    mwaveform=spread_match_filter(c_mult);
    
    mwaveform = 1-2*mwaveform ;
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
        % what is P.sequence ? 
        switch P.ReceiverType
            case 'Simple',
                x_hat = y;                
            case 'Rake',
                rxsymbols=zeros(24576,1);
                for f=1:P.RakeFingers
                    ycrop=y(f:24576*length(P.Sequence)+f-1);
                    yresh=(reshape(ycrop,length(P.Sequence),24576)).';
                    rxsymbols= rxsymbols+(yresh*conj(P.Sequence).')*conj(himp(f));
                end
                rxbits_despread = reshape(rxsymbols(1:P.NumberOfSymbols) < 0,1,P.NumberOfSymbols);
            otherwise,
                disp('Source Encoding not supported')
        end
          
%%-------------------------------------------------------------------------
        % Orthogonal demodulation
        rxbits_demodul = demult4(rxbits_despread);
        demodwaveform = orthogonalDemodulation(rxbits_demodul);        
        demodwaveform1 = x_hat;
        
%%------------------------------------------------------------------------- 
        % conv. Decoder
        rxbits = conv_dec(demodwaveform1,length(bits_tail));
        % BER count
        errors =  sum(rxbits ~= bits_tail');
        
        Results(ss) = Results(ss) + errors;
        
    end
end

%BER = Results/(P.NumberOfBits*P.NumberOfFrames);
BER = Results/(P.NumberOfBits);



    
             
