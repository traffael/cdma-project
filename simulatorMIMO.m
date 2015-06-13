% Wireless Receivers II - Assignment 1:
%
% Direct Sequence Spread Spectrum Simulation Framework
%
% Telecommunications Circuits Laboratory
% EPFL

function BER = simulatorMIMO(P)

hadamardMatrix = 1/sqrt(P.hadamardLength)*hadamard(P.hadamardLength);

%initialize the convolutional coding
encoderPolynominal = [753 561];
K = 9;
convEnc = comm.ConvolutionalEncoder('TrellisStructure', poly2trellis(P.codeLength+1,encoderPolynominal)); %terminated, put outsidew for
convDec = comm.ViterbiDecoder('TrellisStructure', poly2trellis(K,encoderPolynominal)); 




Results = zeros(1,length(P.SNRRange)); %records the errors
for i_frame = 1:P.NumberOfFrames
    i_frame
    %% -------------------------------------------------------------------------
    % Coding
    tx_information_bits = randi([0 1],P.NumberOfBits,1); % Random Data
    tx_bits_tail = [tx_information_bits; zeros(P.codeLength,1)]; % adding encoder tail
    
    tx_bits_coded = step(convEnc, tx_bits_tail);  %convolutional encoding
    tx_bits_split = reshape(tx_bits_coded,[],P.nMIMO); %split up the bitstream to the two antennas
    
    %% -------------------------------------------------------------------------
    tx_signal=zeros(length(tx_bits_coded)*P.hadamardLength/P.nMIMO,P.nMIMO,1); 
    
    i_user_tx = 1; %index of the mobile user. Will be used later when implementing multiple users.
    %% divide the information bits to the two antennas and apply modulation & spreading separately
    for i_tx_antenna = 1:P.nMIMO
        % Orthogonal modulation
        tx_bits_ortogonal = hadamardMatrix(:,i_user_tx) * (1-2*tx_bits_split(:,i_tx_antenna)).';
        tx_bits_ortogonal=tx_bits_ortogonal(:);
        
     
        % Spreading match filter
        tx_bits_matched_filter= P.Long_code(:,:,i_user_tx).*tx_bits_ortogonal;
        
        tx_symbols = tx_bits_matched_filter;

        %%-------------------------------------------------------------------------
        % Channel
        
        WaveLengthTX = size(tx_signal,1);
        WaveLengthRX = WaveLengthTX+P.ChannelLength - 1;
        tx_signal(:,i_tx_antenna) =  tx_symbols;
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
        
        rx_signal = zeros(WaveLengthRX, P.nMIMO);
        SNRdb  = P.SNRRange(i_snr);
        SNRlin = 10^(SNRdb/10);
        noise  = 1/sqrt(2*SNRlin*P.hadamardLength) *(randn(WaveLengthRX,1) + 1i* randn(WaveLengthRX,1) );
        % Channel
        switch P.ChannelType
            case 'AWGN',
                rx_signal = tx_signal + noise';
            case 'Fading',
                rx_signal = tx_signal .* h + noise;
            case 'Multipath'
                for j_rx_antenna = 1:P.nMIMO
                    if j_rx_antenna == 1
                        rx_signal(:,j_rx_antenna) = conv(tx_signal(:,1),himp(1:length(himp)/2,1))+conv(tx_signal(:,2),himp(1:length(himp)/2,2))+ noise;
                    else
                        rx_signal(:,j_rx_antenna) = conv(tx_signal(:,1),himp(length(himp)/2+1:end,1))+conv(tx_signal(:,2),himp(length(himp)/2+1:end,2))+ noise; 
                    end;
                end;
            otherwise,
                disp('Channel not supported')
        end

        %%-------------------------------------------------------------------------
        % Receiver
        i_user_rx = 1; %index of the mobile user. Will be used later when implementing multiple users.
        
        rx_virtual_antennas=zeros(length(tx_bits_split),P.nMIMO*P.RakeFingers);
        
        %% MIMO Rake receiver:
        a = 1;
        for i_rx_antenna = 1:P.nMIMO
            for f=1:P.RakeFingers
                rx_signal_crop=rx_signal(f:WaveLengthTX+f-1,i_rx_antenna);
                rx_bits_despread = rx_signal_crop.*P.Long_code(:,:,i_user_rx);
                
                %rx_bits_demod = orthogonalMIMODemodulation(rx_bits_demult,i_user_rx);
                rx_bits_despread = reshape(rx_bits_despread,P.hadamardLength,[]).'; %reshape to perform matrix multiplication
                rx_virtual_antennas(:,a) = rx_bits_despread * hadamardMatrix(:,i_user_rx); 
                a = a+1;
            end
            
        end
        
        
        %% Do MIMO 
        rx_bits_coded = mimo_decoding((rx_virtual_antennas.'),himp, P).';

        sum3 = sum(rx_bits_coded ~= tx_bits_coded);
        
        
        %% conv. Decoder
        plot((rx_bits_coded ~= tx_bits_coded))
        
        rx_bits_coded=1-2*rx_bits_coded ;
    
        speed = 1/2;    
        delay = convDec.TracebackDepth*log2(convDec.TrellisStructure.numInputSymbols);
        b_hat = step(convDec, [rx_bits_coded; zeros(1/speed*delay,1)]);
        rx_information_bits = b_hat(delay+1:delay+length(tx_bits_tail));

        
        
        %rx_information_bits = conv_dec2(rx_bits_coded,length(tx_bits_tail));
        
        
        %%-------------------------------------------------------------------------
        % BER count
        rx_information_bits = rx_information_bits(1:P.NumberOfBits);
        errors =  sum(rx_information_bits ~= tx_information_bits);
        
        Results(i_snr) = Results(i_snr) + errors;
    end
end



BER = Results/(P.NumberOfBits*P.NumberOfFrames);
%BER = Results/(P.NumberOfBits);





