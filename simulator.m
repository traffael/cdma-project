% Wireless Receivers II - Assignment 1:
%
% Direct Sequence Spread Spectrum Simulation Framework
%
% Telecommunications Circuits Laboratory
% EPFL


function BER = simulator(P)
SeqLen          = length(P.Sequence);
SpreadSequence  = sqrt(1/(sum(P.Sequence.^2))) * P.Sequence(:);
NumberOfChips   = P.Modulation*SeqLen; % per Frame

Results = zeros(1,length(P.SNRRange));
N = 24576;
for ii = 1:4 %P.NumberOfFrames
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
    mwaveform=spread_match_filter(c_mult,P.Long_code);
    
    mod_waveform = 1-2*mwaveform ;
    
    waveform = SpreadSequence*mod_waveform';
    L_spread = length(mod_waveform)*length(SpreadSequence);
    waveform  = reshape(waveform,1,L_spread);
    mmwaveform = zeros(1,L_spread,0);
    for i=1:P.RX
        mmmwaveform = cat(3,mmwaveform,waveform);
    end
    
    
%%------------------------------------------------------------------------- 
    % Channel
    switch P.ChannelType
        case 'AWGN',
            h = ones(1,length(mwaveform),P.RX);
            NumberOfBitsRX=length(mwaveform);
        case 'Fading',
            h = channel(P.RX,length(mwaveform),1,P.CoherenceTime,1);
        case 'Multipath',
            NumberOfBitsRX   = L_spread+P.ChannelLength-1;
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
        noise  = 1/sqrt(2*SNRlin) *(randn(1,NumberOfBitsRX,P.RX) + 1i* randn(1,NumberOfBitsRX,P.RX) );
        % Channel
        switch P.ChannelType
            case 'AWGN',
                y = mwaveform + noise';
            case 'Fading',
                y = mwaveform .* h + noise;
            case 'Multipath'
                y = conv(mmmwaveform,himp) + noise;
            otherwise,
                disp('Channel not supported')
        end
        
 
        
%%-------------------------------------------------------------------------         
        % Receiver
        % what is P.sequence ? 
        switch P.ReceiverType
            case 'Simple',
                x_hat = (real(y)<0);                
            case 'Rake',
                rxsymbols=zeros(length(mwaveform),1);
                for f=1:P.RakeFingers
                    ycrop=y(f:L_spread+f-1);
                    yresh=(reshape(ycrop,length(P.Sequence),length(mwaveform))).';
                    
                    rxsymbols= rxsymbols+(yresh*conj(P.Sequence).')*conj(himp(f));
                end
                x_hat = reshape(rxsymbols(1:length(mwaveform)) < 0,1,length(mwaveform));
            otherwise,
                disp('Source Encoding not supported')
        end
          
%%-------------------------------------------------------------------------
        rxbits_despread=despread_match_filter(x_hat,P.Long_code);
        sum1 = sum(rxbits_despread ~= c_mult');
        % Demultiplication
        rxbits_demult = demult4(rxbits_despread);
        sum2 = sum(rxbits_demult ~= c_ortogonal');
        % Orthogonal demodulation
        rxsymbols_demul=1-2*rxbits_demult;
        demodwaveform = orthogonalDemodulation(rxsymbols_demul);  
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

BER = Results/(P.NumberOfBits*P.NumberOfFrames);
%BER = Results/(P.NumberOfBits);



    
             
