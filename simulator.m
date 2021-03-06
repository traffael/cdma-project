%% Simulator for the non-MIMO system

function BER = simulator(P)

assert(length(P.encoderPolynominal)==1/P.codeRate,'Error: Code rate not consistent with Polynominal length');

hadamardMatrix = 1/sqrt(P.hadamardLength)*hadamard(P.hadamardLength);

%initialize the convolutional coding
convEnc = comm.ConvolutionalEncoder('TrellisStructure', poly2trellis(P.codeLength+1,P.encoderPolynominal)); %terminated, put outsidew for
convDec = comm.ViterbiDecoder('TrellisStructure', poly2trellis(P.codeLength+1,P.encoderPolynominal));

WaveLengthTX = length(P.Long_code);
WaveLengthRX = WaveLengthTX+P.ChannelLength - 1;

Results = zeros(1,length(P.SNRRange)); %records the errors
for i_frame = 1:P.NumberOfFrames
    %i_frame %feedback during long simulations
    
    tx_information_bits = randi([0 1],P.NumberOfBits,P.nUsers); % Random Data
    tx_bits_tail = [tx_information_bits; zeros(P.codeLength,P.nUsers)]; % adding encoder tail
    
    % Begin User loop
    tx_signal=zeros(WaveLengthTX,P.nMIMO); % will store the signal stream for both antennas
    
    for i_user_tx = 1:P.nUsers %index of the mobile user.
        % Coding
        tx_bits_coded = step(convEnc, tx_bits_tail(:,i_user_tx));  %convolutional encoding
        % Orthogonal modulation
        if(P.useIS95Walsh)
            tx_bits_coded_resh = reshape(tx_bits_coded,6,[]).';
            tx_mod_indexes = tx_bits_coded_resh * [1; 2; 4; 8; 16; 32]+1;
            tx_symbols_ortogonal = hadamardMatrix(:,tx_mod_indexes);
            tx_symbols_ortogonal = tx_symbols_ortogonal(:);
            % symbol repetition
            tx_symbols_ortogonal = repmat(tx_symbols_ortogonal.',[4 1]);
            tx_symbols_ortogonal = tx_symbols_ortogonal(:);
        else
            tx_symbols_ortogonal = hadamardMatrix(:,i_user_tx) * (1-2*tx_bits_coded).';
            tx_symbols_ortogonal = tx_symbols_ortogonal(:);
        end
                
        % Spreading matched filter
        tx_symbols_matched_filter = P.Long_code(:,i_user_tx).*tx_symbols_ortogonal;
        
        % add up all the signals of the different users for.
        tx_signal = tx_signal + tx_symbols_matched_filter;
        
    end%i_user_tx
    
    %% -------------------------------------------------------------------------
    % Simulation
    %% Channel
    % (do this outside SNR-loop because conv() is slow)
    
    himp = sqrt(1/2)* (randn(P.ChannelLength,1) + 1i * randn(P.ChannelLength,1));
    
    rx_signal = zeros(WaveLengthRX, 1);
    switch P.ChannelType
        case 'AWGN',
            rx_signal = tx_signal;
        case 'Fading',
            rx_signal = tx_signal .* h;
        case 'Multipath'
            rx_signal = conv(tx_signal,himp);
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
        
        switch P.ReceiverType
            case 'Simple',
                rx_symbols_despread = (real(rx_signal_with_noise)<0);
            case 'Rake',
                rx_symbols_despread=zeros(WaveLengthTX,1);
                for f=1:P.RakeFingers
                    rx_signal_crop=rx_signal_with_noise(f:WaveLengthTX+f-1);
                    rx_symbols_despread= rx_symbols_despread+(PN_sequence_RX.*rx_signal_crop)*conj(himp(f));
                end
            otherwise,
                disp('Source Encoding not supported')
        end
        
        
        
        %%-------------------------------------------------------------------------
        sum1 = sum((rx_symbols_despread<0) ~= (tx_symbols_ortogonal<0));
        
        % Orthogonal demodulation
        if(P.useIS95Walsh)
            % Demultiplication
            rx_symbols_demult = reshape(rx_symbols_despread,4,[]);
            rx_symbols_demult = [0.25 0.25 0.25 0.25]*rx_symbols_demult;
            % Demodulation
            rx_symbols_demod = reshape(rx_symbols_demult,64,[]).'; %reshape to perform matrix multiplication
            rx_mod_indexes = rx_symbols_demod * hadamardMatrix;
            [~,rx_mod_indexes] = max(rx_mod_indexes,[],2); %Find the most probable index of the Hadamard matrix coloumns.
            rx_mod_indexes=rx_mod_indexes-1;
            rx_symbols_coded = fliplr(dec2bin(rx_mod_indexes,6))';
            rx_symbols_coded = 1-2*str2num(rx_symbols_coded(:)); %the mapping to BPSK symbols is required for the conv. Decoder.
        else
            rx_symbols_despread = reshape(rx_symbols_despread,P.hadamardLength,[]); %reshape to perform matrix multiplication
            rx_symbols_coded = (hadamardMatrix(i_user_rx, :) * rx_symbols_despread).';
        end
        sum3 = sum((rx_symbols_coded<0) ~= tx_bits_coded(:));
        %demodwaveform1 = x_hat;
        
        
        %% conv. Decoder
        decDelay = convDec.TracebackDepth*log2(convDec.TrellisStructure.numInputSymbols);
        b_hat = step(convDec, [real(rx_symbols_coded); zeros(1/P.codeRate*decDelay,1)]);
        rx_information_bits = b_hat(decDelay+1:decDelay+length(tx_bits_tail));
        rx_information_bits = rx_information_bits(1:P.NumberOfBits);
        
        %%-------------------------------------------------------------------------
        % BER count
        errors =  sum(rx_information_bits ~= tx_information_bits(:,i_user_rx));
        
        Results(i_snr) = Results(i_snr) + errors;
    end%i_snr
    
end %i_frame


BER = Results/(P.NumberOfBits*P.NumberOfFrames);

end

