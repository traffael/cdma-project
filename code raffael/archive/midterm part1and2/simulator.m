% Wireless Receivers II - Assignment 2:
%
% Direct Sequence Spread Spectrum Simulation Framework
%
% Telecommunications Circuits Laboratory
% EPFL


function BER = simulator(P)

SpreadLen       = length(P.Sequence);
PreambleLen     = length(P.Preamble);

SpreadSequence  = P.Sequence(:);
NumberOfChips   = (P.NumberOfSymbols+PreambleLen) * SpreadLen; % per Frame
NumberOfBits    = P.NumberOfSymbols*P.Modulation; % per Frame

Results = zeros(1,length(P.SNRRange));

for ii = 1:P.NumberOfFrames
    
    ii
    
    % 
    databits = randi([0 1],1,NumberOfBits); % Random Data

    % Modulation
    switch P.Modulation % Modulate Symbols
        case 1, % BPSK
            datasymbols = -(2*databits - 1);
        otherwise,
            disp('Modulation not supported')
    end
    
    symbols = [ P.Preamble , datasymbols ];
    
    % Spread Symbols
    chips = reshape(SpreadSequence*symbols,1,NumberOfChips);
    
    % Channel
    switch P.ChannelType
        case 'AWGN',
            h = [1];
        case 'Multipath',
            h = sqrt(1/2)* (randn(1,P.ChannelLength) +1i *randn(1,P.ChannelLength));
        otherwise,
            disp('Channel not supported')
    end
    
    %%%
    % Simulation
    
    % SNR Range
    for ss = 1:length(P.SNRRange)
        SNRdb  = P.SNRRange(ss);
        SNRlin = 10^(SNRdb/10);
        
        % Channel
        y_channel = conv(chips,h);

        % AWGN
        noise  = 1/sqrt(2*SNRlin) *( randn(1,length(y_channel)) + 1i* randn(1,length(y_channel)) );
        y_noise = y_channel + noise;
          
        % Carrier Frequency Offset
        y = y_noise .* exp(1i*2*pi*(2*(rand-0.5))*P.CFOffset *(1:length(y_noise)) );
        
        % % % % % %
        % Receiver
        %
        
        % Process Preamble

            ...
       
        % Correct estimated CFO
        y_hat  = y;
        
        % Process Data
        y_data      = y_hat(PreambleLen*SpreadLen+1:end);
        
        % Receiver
        switch P.ReceiverType
            case 'Rake',
                FrameLength = P.NumberOfSymbols * SpreadLen ;
                
                % determine real size of rake
                upto       = min(P.RakeFingers,length(h));
                fingers    = zeros(upto,P.NumberOfSymbols);
                 
                for i=1:upto
                    data    =  y_data(i:i+FrameLength-1);
                    rxvecs  = reshape(data,SpreadLen,P.NumberOfSymbols);
                    fingers(i,:) = conj(h(i))/SpreadLen * SpreadSequence.' * rxvecs;
                end
                mrc = 1/norm(h(1:upto)) * sum(fingers,1);
                rxbits = real(mrc) < 0;                
            otherwise,
                disp('Source Encoding not supported')
        end
        
        % BER count
        errors =  sum(rxbits ~= databits);
        
        Results(ss) = Results(ss) + errors;
        
    end
end

BER = Results/(NumberOfBits*P.NumberOfFrames);
