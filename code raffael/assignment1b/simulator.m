% Wireless Receivers II - Assignment 3.5b:
%
% CDMA Simulation Framework
%
% Telecommunications Circuits Laboratory
% EPFL


function BER = simulator(P)

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
            NumberOfChipsRX = NumberOfChips+P.ChannelLength-1;
        otherwise,
            NumberOfChipsRX = NumberOfChips;
    end

Results = zeros(1,length(P.SNRRange));

for ii = 1:P.NumberOfFrames
    
    

    bits = randi([0 1],1,NumberOfBits); % Random Data
 
    % Modulation
    switch P.Modulation % Modulate Symbols
        case 1, % BPSK
            symbols = -(2*bits - 1);
        otherwise,
            disp('Modulation not supported')
    end
    

    % distribute symbols on users
    SymUsers = reshape(symbols,NumberOfBits/RX,RX).';
        
    % multiply hadamard
    txsymbols = SpreadSequence(:,1:RX) * SymUsers;
        
    % apply Barker code
    waveform = txsymbols(:).*PNSequence;

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
        
 
        % Receiver
        switch P.ReceiverType
            case 'Rake',                
                rxbits=zeros(1,P.NumberOfSymbols*RX);
                for u=1:RX %%TODO: adapt for multiple users.
                    %correlate with spreading sequence:
                    yuser=y(:,:,u);
                    rxsymbols=zeros(P.NumberOfSymbols,1);
                    for f=1:P.ChannelLength %:P.RakeFingers
                        ycrop=yuser(1,f:P.NumberOfSymbols*SeqLen+f-1);
                        ydespread=ycrop.*(conj(PNSequence.'));
                        yresh=reshape(ydespread,SeqLen,P.NumberOfSymbols).';
                        
                        rxsymbols= rxsymbols+(yresh*conj(SpreadSequence(:,u)))*conj(himp(u,f));
                    end
                    rxbitsuser = reshape(rxsymbols(1:P.NumberOfSymbols) < 0,1,P.NumberOfSymbols);
                    rxbits((u-1)*P.NumberOfSymbols+1:u*P.NumberOfSymbols)=rxbitsuser;
                end
                
                

                 
            otherwise,
                disp('Source Encoding not supported')
        end
        
        % BER count
        errors =  sum(rxbits ~= bits);
        
        Results(ss) = Results(ss) + errors;
        
    end
end

BER = Results/(NumberOfBits*P.NumberOfFrames);
end

function seq = genbarker(len)
    BarkerSeq = [+1 +1 +1 +1 +1 -1 -1 +1 +1 -1 +1 -1 +1];

    factor = ceil(len/length(BarkerSeq));
    b = repmat(BarkerSeq,1,factor);
    b = BarkerSeq.'*ones(1,factor);
    seq = b(1:len).';
end
