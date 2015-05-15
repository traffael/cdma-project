% Wireless Receivers II - Assignment 3.5b:
%
% CDMA Simulation Framework
%
% Telecommunications Circuits Laboratory
% EPFL


function BER = simulator_2(P)

    if P.CDMAUsers > P.HamLen
       disp('WARNING: More users than sequences!');
       BER = -1;
       return;
    end
    RX = P.CDMAUsers;
    
    % Generate the spreading sequences
    HadamardMatrix = hadamard(P.HamLen)/sqrt(P.HamLen);            
    SpreadSequence = fliplr(HadamardMatrix);
    
    SeqLen         = P.HamLen;
    
    NumberOfChips  = P.NumberOfSymbols*P.Modulation*SeqLen; % per Frame

    PNSequence     = genbarker(NumberOfChips); % -(2*step(GS)-1);
    
    NumberOfBits   = P.NumberOfSymbols*P.Modulation*RX; % per Frame
     
    % Channel
    switch P.ChannelType
        case 'Multipath',
            NumberOfChipsRX   = NumberOfChips+P.ChannelLength-1;
        otherwise,
            NumberOfChipsRX = NumberOfChips;
    end

Results = zeros(1,length(P.SNRRange));

for ii = 1:P.NumberOfFrames/5
    
    ii

    bits = randi([0 1],1,NumberOfBits); % Random Data
    
    % Modulation
    switch P.Modulation % Modulate Symbols
        case 1, % BPSK
            symbols = -(2*bits - 1);
        otherwise,
            disp('Modulation not supported')
    end
    

    % distribute symbols on users
    SymUsers = reshape(symbols,NumberOfBits/RX,RX)'; % верно 
        
    % multiply hadamard
    txsymbols = SpreadSequence(:,1:RX) * SymUsers; 
    waveform = txsymbols(:).*PNSequence; % было 2х1000 стало 8х1000 - инфа о сигнале в обоих последовательностях

    % reshape to add multi RX antenna suppport
    waveform  = reshape(waveform,1,NumberOfChips);
    mwaveform = repmat(waveform,[1 1 RX]);
    
    % Channel
    switch P.ChannelType
        case 'AWGN',
            himp = ones(RX,1);
        case 'Multipath',
            himp = sqrt(1/2)* ( randn(RX,P.ChannelLength) + 1i * randn(RX,P.ChannelLength) );
        otherwise,
            disp('Channel not supported')
    end
    
    %%%
    % Simulation
    snoise = ( randn(1,NumberOfChipsRX,RX) + 1i* randn(1,NumberOfChipsRX,RX) );
    
    % SNR Range
    for ss = 1:length(P.SNRRange)
        SNRdb  = P.SNRRange(ss);
        SNRlin = 10^(SNRdb/10);
        noise  = 1/sqrt(2*SeqLen*SNRlin) *snoise;
        
        % Channel
        switch P.ChannelType
            case 'AWGN',
                y = mwaveform + noise;
            case 'Multipath'     
                y = zeros(1,NumberOfChips+P.ChannelLength-1,RX);
                for i = 1:RX
                    y(1,:,i) = conv(mwaveform(1,:,i),himp(i,:)) + noise(1,:,i);  
                end
            otherwise,
                disp('Channel not supported')
        end
        
        rxbits_new = [];
        % Receiver
            switch P.ReceiverType
            case 'Rake',
                rxbits_new = [];
                N = SeqLen*P.NumberOfSymbols;
                Sign = reshape(y,length(y),P.CDMAUsers);  % верно
                for i = 1:P.CDMAUsers
                    SUM = 0;
                    for j = 1:min(P.ChannelLength,P.Fingers)
                        OBS = Sign(j:N+j-1,i).*conj(sign(PNSequence));
                        OBS = OBS*conj(sign(himp(i,j)));
                        Resh_OBS = reshape(OBS,8,1000);
                        SUM = SUM + Resh_OBS.'*conj(sign(SpreadSequence(:,i)));
                    end;
                rxbits = reshape(SUM < 0,1,P.NumberOfSymbols);    
                rxbits_new = [rxbits_new rxbits];
                end;
            otherwise,
                disp('Source Encoding not supported')
        end
        
        % BER count
        errors =  sum(rxbits_new ~= bits);
        Results(ss) = Results(ss) + errors;
        
    end
end

BER = Results/(NumberOfBits*P.NumberOfFrames);
end

