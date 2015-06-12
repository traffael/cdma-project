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
    %tx_information_bits = ones(1,P.NumberOfBits);
    tx_bits_tail = add_enc_tail(tx_information_bits,P); % adding a tail
    tx_bits_coded = conv_enc(tx_bits_tail,P);  %convolutional encoding
    tx_bits_split = reshape(tx_bits_coded,[],P.nMIMO).'; %split up the bitstream to the two antennas
    
    %% -------------------------------------------------------------------------
    tx_signal=zeros(length(tx_bits_coded)*64/P.nMIMO,P.nMIMO)'; % *64: walsh mapping; *4: bits repetition
    
    i_user_tx = 1; %index of the mobile user. Will be used later when implementing multiple users.
    %% divide the information bits to the two antennas and apply modulation & spreading separately
    for i_tx_antenna = 1:P.nMIMO
        % Orthogonal modulation
        tx_bits_ortogonal = orthogonalMIMOModulation(tx_bits_split(i_tx_antenna,:),i_user_tx);
        
        % Bits repetition
        tx_bits_repeated = tx_bits_ortogonal;%mult4(tx_bits_ortogonal);
        
        % Spreading match filter
        tx_bits_matched_filter=spread_match_filter(tx_bits_repeated,P.Long_code(:,:,i_user_tx),P);
        
        tx_symbols = 1-2*tx_bits_matched_filter ;
        
        test = despread_match_filter(tx_symbols,P.Long_code(:,:,i_user_tx), P)<0;
        sumtest = sum(test~=tx_bits_repeated)
        %%-------------------------------------------------------------------------
        % Channel
        
        WaveLengthTX = size(tx_signal,2);
        WaveLengthRX = WaveLengthTX+P.ChannelLength - 1;
        tx_signal(i_tx_antenna,:) =  tx_symbols;
    end %i_tx_antenna
    
    %% Channel
    himp = sqrt(1/2)* (randn(P.ChannelLength*P.nMIMO,P.nMIMO) + 1i * randn(P.ChannelLength*P.nMIMO,P.nMIMO));
    himp = himp/norm(himp); %%normalize channel taps.
    
    %himp = zeros(6,2);
    %himp(1,1) = 1;
    %himp(4,1) = 1;
    %himp(3,2) = 1;
    %himp(6,2) = 1;
    
    %% -------------------------------------------------------------------------
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
                    a = 1;
                    if j_rx_antenna == 1
                        rx_signal(j_rx_antenna,:) = conv(tx_signal(1,:),himp(1:length(himp)/2,1))+conv(tx_signal(2,:),himp(1:length(himp)/2,2));%+ noise; % приходит на 1 антенну
                    else
                        rx_signal(j_rx_antenna,:) = conv(tx_signal(1,:),himp(length(himp)/2+1:end,1))+conv(tx_signal(2,:),himp(length(himp)/2+1:end,2));%+ noise; % приходит на 2 антенну
                    end;
                end;
            otherwise,
                disp('Channel not supported')
        end
        
        
        
        %%-------------------------------------------------------------------------
        % Receiver
        i_user_rx = 1; %index of the mobile user. Will be used later when implementing multiple users.
        
        rx_virtual_antennas=zeros(P.nMIMO*P.RakeFingers,length(tx_bits_split));
        
        %% MIMO Rake receiver:
        a = 1;
        for i_rx_antenna = 1:P.nMIMO
            for f=1:P.RakeFingers
                rx_signal_crop=rx_signal(i_rx_antenna,f:WaveLengthTX+f-1);
                rx_bits_despread = despread_match_filter(rx_signal_crop,P.Long_code(:,:,i_user_rx), P);
                
                rx_bits_demult = rx_bits_despread;%(demult4(rx_bits_despread));
                rx_bits_demod = orthogonalMIMODemodulation(rx_bits_demult,i_user_rx);
                rx_virtual_antennas(a,:) = rx_bits_demod;
                a = a+1;
            end
            
        end
        
        
        %% Do MIMO TODO
        
        rx_bits_coded = mimo_decoding((rx_virtual_antennas),himp, P);
        
        %% recombine the two bitstreams from MIMO again.
        %rx_bits_coded = [];
        %for i_antenna = 1:P.nMIMO
        %    rx_bits_coded = [rx_bits_coded rx_bits_mimo(:,i_antenna)];
        %end %mimo antenna loop
        %rx_bits_coded = reshape(rx_bits_coded.',1,[])';
        sum3 = sum(rx_bits_coded ~= tx_bits_coded);
        
        
        %% conv. Decoder
        plot((rx_bits_coded ~= tx_bits_coded))
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





