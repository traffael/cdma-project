% Wireless Receivers II - Assignment 1:
%
% Direct Sequence Spread Spectrum Simulation Framework
%
% Telecommunications Circuits Laboratory
% EPFL

function BER = simulatorMIMO(P)

hadamardMatrix = 1/sqrt(P.hadamardLength)*hadamard(P.hadamardLength);

%initialize the convolutional coding
convEnc = comm.ConvolutionalEncoder('TrellisStructure', poly2trellis(P.codeLength+1,P.encoderPolynominal)); %terminated, put outsidew for
convDec = comm.ViterbiDecoder('TrellisStructure', poly2trellis(P.codeLength+1,P.encoderPolynominal));

WaveLengthTX = (P.NumberOfBits+P.codeLength)/P.codeRate*P.hadamardLength/P.nMIMO;
WaveLengthRX = WaveLengthTX+P.ChannelLength - 1;

Results = zeros(1,length(P.SNRRange)); %records the errors
for i_frame = 1:P.NumberOfFrames
    i_frame %feedback during long simulations
    
    tx_information_bits = randi([0 1],P.NumberOfBits,P.nUsers); % Random Data
    tx_bits_tail = [tx_information_bits; zeros(P.codeLength,P.nUsers)]; % adding encoder tail
    
    % Begin User loop
    tx_signal=zeros(WaveLengthTX,P.nMIMO); % will store the signal stream for both antennas
    
    for i_user_tx = 1:P.nUsers %index of the mobile user.
        % Coding
        tx_bits_coded = step(convEnc, tx_bits_tail(:,i_user_tx));  %convolutional encoding
        tx_bits_split = reshape(tx_bits_coded,[],P.nMIMO); %split up the bitstream to the two antennas
        
        %% divide the information bits to the two antennas and apply modulation & spreading separately
        for i_tx_antenna = 1:P.nMIMO
            % Orthogonal modulation
            tx_symbols_ortogonal = hadamardMatrix(:,i_user_tx) * (1-2*tx_bits_split(:,i_tx_antenna)).';
            tx_symbols_ortogonal = tx_symbols_ortogonal(:);
            
            % Spreading matched filter
            tx_symbols_matched_filter = P.Long_code(:,i_user_tx).*tx_symbols_ortogonal;
            
            tx_symbols = tx_symbols_matched_filter;
            
            % add up all the signals of the different users for each antenna.
            tx_signal(:,i_tx_antenna) = tx_signal(:,i_tx_antenna) + tx_symbols;
        end %i_tx_antenna
    end%i_user_tx
    
    %% -------------------------------------------------------------------------
    % Simulation
    %% Channel
    % (do this outside SNR-loop because conv() is slow)
    
    himp = sqrt(1/2)* (randn(P.ChannelLength*P.nMIMO,P.nMIMO) + 1i * randn(P.ChannelLength*P.nMIMO,P.nMIMO));
    himp = himp/norm(himp); %%normalize channel taps.
    
    %Uncomment this for debugging the MIMO:
    %himp = zeros(6,2);
    %himp(1,1) = 1;
    %himp(4,1) = 1;
    %himp(3,2) = 1;
    %himp(6,2) = 1;
    
    rx_signal = zeros(WaveLengthRX, P.nMIMO);
    switch P.ChannelType
        case 'AWGN',
            rx_signal = tx_signal;
        case 'Fading',
            rx_signal = tx_signal .* h;
        case 'Multipath'
            for j_rx_antenna = 1:P.nMIMO
                if j_rx_antenna == 1
                    rx_signal(:,j_rx_antenna) = conv(tx_signal(:,1),himp(1:length(himp)/2,1))+conv(tx_signal(:,2),himp(1:length(himp)/2,2));
                else
                    rx_signal(:,j_rx_antenna) = conv(tx_signal(:,1),himp(length(himp)/2+1:end,1))+conv(tx_signal(:,2),himp(length(himp)/2+1:end,2));
                end;
            end;
        otherwise,
            disp('Channel not supported')
    end
    %same noise vector for all different SNRs, to improve speed
    noise_vector = (randn(WaveLengthRX,P.nMIMO) + 1i* randn(WaveLengthRX,P.nMIMO) );
    
    i_user_rx = randi(P.nUsers); %index of the mobile user to be decoded on the RX side.
    %As all the users are equivalent it doesn't matter which one we choose.
    PN_sequence_RX = P.Long_code(:,i_user_rx); % used in receiver. defined here for speed.
    
    for i_snr = 1:length(P.SNRRange)
        % Add noise depending on SNR
        SNRdb  = P.SNRRange(i_snr);
        SNRlin = 10^(SNRdb/10);
        noise  = 1/sqrt(2*SNRlin*P.hadamardLength) * noise_vector;
        
        rx_signal_with_noise = rx_signal + noise;
        
        %%-------------------------------------------------------------------------
        % Receiver
        rx_virtual_antennas=zeros(length(tx_bits_split),P.nMIMO*P.RakeFingers);
        
        %% MIMO Rake receiver:
        a = 1;
        for i_rx_antenna = 1:P.nMIMO
            for f=1:P.RakeFingers
                rx_signal_crop=rx_signal_with_noise(f:WaveLengthTX+f-1,i_rx_antenna);
                rx_symbols_despread = rx_signal_crop.*PN_sequence_RX;
                rx_symbols_despread = reshape(rx_symbols_despread,P.hadamardLength,[]); %reshape to perform matrix multiplication
                rx_virtual_antennas(:,a) = hadamardMatrix(i_user_rx, :) * rx_symbols_despread;
                a = a+1;
            end
        end
        
        
        %% Do MIMO:
        rx_symbols_coded = real(himp\(rx_virtual_antennas.')).';
        rx_symbols_coded=rx_symbols_coded(:);
        
        %  sum3 = sum(rx_bits_coded ~= tx_bits_coded);
        
        
        %% conv. Decoder
        decDelay = convDec.TracebackDepth*log2(convDec.TrellisStructure.numInputSymbols);
        b_hat = step(convDec, [rx_symbols_coded; zeros(1/P.codeRate*decDelay,1)]);
        rx_information_bits = b_hat(decDelay+1:decDelay+length(tx_bits_tail));
        rx_information_bits = rx_information_bits(1:P.NumberOfBits);
        
        %%-------------------------------------------------------------------------
        % BER count
        errors =  sum(rx_information_bits ~= tx_information_bits(:,i_user_rx));
        
        Results(i_snr) = Results(i_snr) + errors;
    end
end



BER = Results/(P.NumberOfBits*P.NumberOfFrames);
