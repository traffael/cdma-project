% Wireless Receivers II - Assignment 1:
%
% Direct Sequence Spread Spectrum Simulation Framework
%
% Telecommunications Circuits Laboratory
% EPFL


function BER = simulatorMIMO(P)

Results = zeros(1,length(P.SNRRange)); %records the errors
for i_frame = 1:P.NumberOfFrames
    i_frame
    %% -------------------------------------------------------------------------
    % Coding
    tx_information_bits = randi([0 1],1,P.NumberOfBits); % Random Data
   tx_information_bits = ones(1,P.NumberOfBits);
    tx_bits_tail = add_enc_tail(tx_information_bits,P); % adding a tail
    tx_bits_coded = conv_enc(tx_bits_tail,P);  %convolutional encoding
    tx_bits_split = reshape(tx_bits_coded,[],P.nMIMO).'; %split up the bitstream to the two antennas
    
    %% -------------------------------------------------------------------------
    tx_signal=zeros(length(tx_bits_coded)*64/P.nMIMO,P.nMIMO); % *64: walsh mapping; *4: bits repetition
    himp_saved=zeros(P.ChannelLength,P.nMIMO,P.nMIMO); %this stores the different channel coefficients
    
    i_user_tx = 1; %index of the mobile user. Will be used later when implementing multiple users.
    %% divide the information bits to the two antennas and apply modulation & spreading separately
    for i_tx_antenna = 1:P.nMIMO
        % Orthogonal modulation
        tx_bits_ortogonal = orthogonalMIMOModulation(tx_bits_split(i_tx_antenna,:),i_user_tx);
        
        % Bits repetition
        tx_bits_repeated = tx_bits_ortogonal;%mult4(tx_bits_ortogonal);
        
        % Spreading match filter
        tx_bits_matched_filter=spread_match_filter(tx_bits_repeated,P.Long_code(:,:,i_tx_antenna),P);
        
        tx_symbols = 1-2*tx_bits_matched_filter ;
        %%-------------------------------------------------------------------------
        % Channel
        
        WaveLengthTX = size(tx_signal,1);
        WaveLengthRX = WaveLengthTX+P.ChannelLength - 1;
        for i_channel = 1:P.nMIMO
            
            switch P.ChannelType
                case 'AWGN',
                    h = ones(1,length(tx_symbols));
                case 'Fading',
                    h = channel(P.nMIMO,length(waveform),1,P.CoherenceTime,1);
                case 'Multipath',
                    %WaveLengthTX   = L_spread+P.ChannelLength-1;
                    himp = sqrt(1/2)* (randn(1,P.ChannelLength) + 1i * randn(1,P.ChannelLength));
                    %% DEBUG: remove this:
                    %himp = [1 0 0];%ones(1,P.ChannelLength);
                    himp = himp/norm(himp); %%normalize channel taps.
                otherwise,
                    disp('Channel not supported')
            end
            
            % Store the two TX signals in separate streams
            himp_saved(:,i_tx_antenna,i_channel) = himp;
            
        end %i_channel
        
        tx_signal(:,i_tx_antenna) =  tx_symbols;
    end %i_tx_antenna
    
    himp_saved = zeros(1,2,2);
    himp_saved(1,1,1) = 1;
    himp_saved(1,2,2) = 1;
    
    %%-------------------------------------------------------------------------
    % Simulation
    for i_snr = 1:length(P.SNRRange)
        i_snr
        rx_signal = zeros(P.nMIMO, WaveLengthRX);
        SNRdb  = P.SNRRange(i_snr);
        SNRlin = 10^(SNRdb/10);
        noise  = 1/sqrt(2*SNRlin) *(randn(1,WaveLengthRX) + 1i* randn(1,WaveLengthRX) );
        % Channel
        switch P.ChannelType
            case 'AWGN',
                rx_signal = tx_signal + noise';
            case 'Fading',
                rx_signal = tx_signal .* h + noise;
            case 'Multipath'
                for j_rx_antenna = 1:P.nMIMO
                    for j_tx_antenna = 1:P.nMIMO
                        rx_signal(j_rx_antenna,:) = rx_signal(j_rx_antenna,:) + conv(tx_signal(:,j_tx_antenna),himp_saved(:,j_rx_antenna,j_tx_antenna)).' ;%+ noise;
                    end
                end;
            otherwise,
                disp('Channel not supported')
        end
        
        
        
        %%-------------------------------------------------------------------------
        % Receiver
        i_user_rx = 1; %index of the mobile user. Will be used later when implementing multiple users.
        
        rx_virtual_antennas=zeros(size(tx_bits_split,2),P.nMIMO,P.RakeFingers);
        
        %% MIMO Rake receiver:
        for i_rx_antenna = 1:P.nMIMO
            for f=1:P.RakeFingers
                rx_signal_crop=rx_signal(i_rx_antenna,f:WaveLengthTX+f-1);
                rx_bits_despread = despread_match_filter(rx_signal_crop,P.Long_code(:,:,i_user_rx), P);
                
                rx_bits_demult = rx_bits_despread;%(demult4(rx_bits_despread));
                rx_bits_demod = orthogonalMIMODemodulation(rx_bits_demult,i_user_rx);
                rx_virtual_antennas(:,i_rx_antenna,f) = rx_bits_demod;
            end
            
        end
        
        %% Do MIMO TODO
        
        rx_bits_mimo = mimo_decoding(real(rx_virtual_antennas),himp_saved, P);
        rx_bits_coded = (rx_bits_mimo<0)';
        
        %% recombine the two bitstreams from MIMO again.
        %rx_bits_coded = [];
        %for i_antenna = 1:P.nMIMO
        %    rx_bits_coded = [rx_bits_coded rx_bits_mimo(:,i_antenna)];
        %end %mimo antenna loop
        %rx_bits_coded = reshape(rx_bits_coded.',1,[])';
        sum3 = sum(rx_bits_coded ~= tx_bits_coded);
        
        
        %% conv. Decoder
        rx_information_bits = conv_dec(rx_bits_coded,length(tx_bits_tail));
        
        
        %%-------------------------------------------------------------------------
        % BER count
        rx_information_bits = rx_information_bits(1:P.NumberOfBits);
        errors =  sum(rx_information_bits ~= tx_information_bits');
        
        Results(i_snr) = Results(i_snr) + errors;
    end
end



BER = Results/(P.NumberOfBits*P.NumberOfFrames);
%BER = Results/(P.NumberOfBits);





