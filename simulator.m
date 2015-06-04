% Wireless Receivers II - Assignment 1:
%
% Direct Sequence Spread Spectrum Simulation Framework
%
% Telecommunications Circuits Laboratory
% EPFL


function BER = simulator(P)
SeqLen = length(P.Sequence);
for i_antenna = 1:P.RX
    SpreadSequence(i_antenna,:)  = sqrt(1/(sum(P.Sequence(i_antenna,:).^2))) * P.Sequence(i_antenna,:);
end
NumberOfChips   = P.Modulation*SeqLen; % per Frame
himp_saved=zeros(P.ChannelLength,P.RX,P.RX);
Results = zeros(1,length(P.SNRRange));
N = 24576;
for ii = 1:P.NumberOfFrames
    ii
    %% -------------------------------------------------------------------------
    % Coding
    bits = randi([0 1],1,P.NumberOfBits); % Random Data
    %bits = ones(1,P.NumberOfBits);
    bits_tail = add_enc_tail(bits); % adding a tail
    c = conv_enc(bits_tail);  %convolutional encoding
    c_split = reshape(c, P.RX, []);
    
    %% -------------------------------------------------------------------------
    tx_signal=zeros(172032/P.RX,P.RX,P.RX);% + P.ChannelLength - 1);
    
    
    %% divide the information bits to the two antennas and apply modulation & spreading separately
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
        
        for i_channel = 1:P.RX
         
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
%HOWTO ---->  how should we combine multipath and mimo?
            otherwise,
                disp('Channel not supported')
        end
        
        % Add the two TX signals together for mimo case.
        tx_signal(:,i_antenna,i_channel) =  waveform;
        himp_saved(:,i_antenna,i_channel) = himp;
        
        end %i_channel
    end
    
    %%-------------------------------------------------------------------------
    % Simulation
    for ss = 1:length(P.SNRRange)
        ss
        y = zeros(P.RX,172032/P.RX + P.ChannelLength - 1);
        SNRdb  = P.SNRRange(ss);
        SNRlin = 10^(SNRdb/10);
        noise  = 1/sqrt(2*SNRlin) *(randn(1,WaveLengthTX) + 1i* randn(1,WaveLengthTX) );
        % Channel
        switch P.ChannelType
            case 'AWGN',
                y = tx_signal + noise';
            case 'Fading',
                y = tx_signal .* h + noise;
            case 'Multipath'
                for i_channel = 1:P.RX
                    for i_antenna = 1:P.RX
                    y(i_channel,:) = y(i_channel,:) + conv(tx_signal(:,i_antenna,i_channel),himp_saved(:,i_antenna,i_channel)).' + noise;
                    end
                end;
            otherwise,
                disp('Channel not supported')
        end
        
       
        
        %%-------------------------------------------------------------------------
        % Receiver
        % what is P.sequence ?
        rx_signal = [];
        
%% ----> The rake receiver is currently only operating on one of the 2 MIMO RX antennas...
        rxsymbols=zeros(length(mwaveform),P.RX,P.RX);
        for i_rx_antenna = 1:P.RX
            
            switch P.ReceiverType
                case 'Simple',
                    x_hat = (real(y)<0);
                case 'Rake',
                    
                    for f=1:P.RakeFingers
                        ycrop=y(i_rx_antenna,f:L_spread+f-1); %%TODO!!!
                        yresh=(reshape(ycrop,length(P.Sequence(i_rx_antenna,:)),length(mwaveform))).';
                        for i_tx_antenna = 1: P.RX
                            rxsymbols(:,i_tx_antenna,i_rx_antenna) = rxsymbols(:,i_tx_antenna,i_rx_antenna)+(yresh*conj(P.Sequence(i_rx_antenna,:)).')*conj(himp_saved(f,i_tx_antenna,i_rx_antenna)); %%NOTE: this is from the RX antenna perspective, not like before
                        end
                    end
                    
                    
                    
                    
                otherwise,
                    disp('Source Encoding not supported')
            end
        end
        
        rxmimo = sum(rxsymbols,3);
        
        for i_antenna = 1:P.RX
            
            x_hat = reshape(rxmimo(1:length(mwaveform),i_antenna) < 0,1,length(mwaveform));
            %%-------------------------------------------------------------------------
            sum0= sum(x_hat ~= mwaveform');
            rxbits_despread=despread_match_filter(x_hat,P.Long_code(:,:,i_antenna));
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
end



BER = Results/(P.NumberOfBits*P.NumberOfFrames);
%BER = Results/(P.NumberOfBits);





