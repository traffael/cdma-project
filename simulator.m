% Wireless Receivers II - Assignment 1:
%
% Direct Sequence Spread Spectrum Simulation Framework
%
% Telecommunications Circuits Laboratory
% EPFL


function BER = simulator(P)
SeqLen          = length(P.Sequence);
for i_antenna = 1:P.RX
    SpreadSequence(i_antenna,:)  = sqrt(1/(sum(P.Sequence(i_antenna,:).^2))) * P.Sequence(i_antenna,:);
end
NumberOfChips   = P.Modulation*SeqLen; % per Frame
himp_saved=zeros(P.RX,P.ChannelLength);
Results = zeros(1,length(P.SNRRange));
N = 24576;
for ii = 1:P.NumberOfFrames
    ii
    %% -------------------------------------------------------------------------
    % Coding
    %bits = randi([0 1],1,P.NumberOfBits); % Random Data
    bits = randi([0,1],1,P.NumberOfBits);
    bits_tail = add_enc_tail(bits); % adding a tail
    c = conv_enc(bits_tail);  %convolutional encoding
    c_split = reshape(c, P.RX, []);
    
    %% -------------------------------------------------------------------------
    tx_signal=zeros(1,172032/P.RX + P.ChannelLength - 1);
    
    for i_antenna = 1:P.RX
        Coding_out = c_split(i_antenna,:);
        
        % Orthogonal modulation
        c_ortogonal = orthogonalModulation(Coding_out);
        
        % Bits repetition
        c_mult = mult4(c_ortogonal);
        
        % Spreading match filter
        mwaveform=spread_match_filter(c_mult,P.Long_code(:,:,i_antenna));
        
        mod_waveform = 1-2*mwaveform ;
        
        waveform = SpreadSequence(i_antenna,:)'*mod_waveform';
        L_spread = length(mod_waveform)*length(SpreadSequence(i_antenna,:));
        waveform  = reshape(waveform,1,L_spread);
        
        %%-------------------------------------------------------------------------
        % Channel
        switch P.ChannelType
            case 'AWGN',
                h = ones(1,length(waveform));
                WaveLengthTX=length(waveform);
            case 'Fading',
                h = channel(P.RX,length(waveform),1,P.CoherenceTime,1);
            case 'Multipath',
                WaveLengthTX   = L_spread+P.ChannelLength-1;
                himp = sqrt(1/2)* ( randn(1,P.ChannelLength) + 1i * randn(1,P.ChannelLength) ); % channel has imaginary stuff?
                himp = himp/norm(himp); %%normalize channel taps.
                
            otherwise,
                disp('Channel not supported')
        end
        
        %%-------------------------------------------------------------------------
        % Simulation
        for ss = 1:length(P.SNRRange)
            ss
            SNRdb  = P.SNRRange(ss);
            SNRlin = 10^(SNRdb/10);
            noise  = 1/sqrt(2*SNRlin) *(randn(1,WaveLengthTX) + 1i* randn(1,WaveLengthTX) );
            % Channel
            switch P.ChannelType
                case 'AWGN',
                    y = waveform + noise';
                case 'Fading',
                    y = waveform .* h + noise;
                case 'Multipath'
                    y = conv(waveform,himp) + noise;
                otherwise,
                    disp('Channel not supported')
            end
            
            
            % Add the two TX signals together for mimo case.
            tx_signal = tx_signal + y;
            himp_saved(i_antenna,:) = himp;
            
        end
    end % mimo antenna loop
    
    
    
    
    
    %%-------------------------------------------------------------------------
    % Receiver
    % what is P.sequence ?
    rx_signal = [];
    
    for i_antenna = 1:P.RX
        
        switch P.ReceiverType
            case 'Simple',
                x_hat = (real(tx_signal)<0);
            case 'Rake',
                rxsymbols=zeros(length(mwaveform),1);
                for f=1:P.RakeFingers
                    ycrop=tx_signal(f:L_spread+f-1);
                    yresh=(reshape(ycrop,length(P.Sequence(i_antenna,:)),length(mwaveform))).';
                    rxsymbols= rxsymbols+(yresh*conj(P.Sequence(i_antenna,:)).')*conj(himp_saved(i_antenna,f));
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
        demodwaveform = orthogonalDemodulation(rxbits_demult);
        
        rx_signal = [rx_signal demodwaveform];
    end %mimo antenna loop
    rx_signal = reshape(rx_signal.',1,[])';
    sum3 = sum(rx_signal ~= c);
    %demodwaveform1 = x_hat;
    % conv. Decoder
    rxbits = conv_dec(rx_signal,length(bits_tail));
    
    
    %%-------------------------------------------------------------------------
    
    
    % BER count
    rxbits = rxbits(1:P.NumberOfBits);
    errors =  sum(rxbits ~= bits');
    
    Results(ss) = Results(ss) + errors;
    
    
end

BER = Results/(P.NumberOfBits*P.NumberOfFrames);
%BER = Results/(P.NumberOfBits);





