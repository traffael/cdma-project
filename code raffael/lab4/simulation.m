function [ BER ] = simulation( SNR, K, N ,demapping)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

nerr=0;
for k=1:N
    b=rand(K,1)<0.5;
    
    %convolutional encoder
    convEnc=comm.ConvolutionalEncoder;
    c=step(convEnc,b);
    
    %BPSK
    x=-(c-(c==0));
    y=awgn(x, SNR,'measured');
    
    %demapper
    if ( strcmp(demapping , 'hard'))
        x_hat=sign(y);
    elseif ( strcmp(demapping , 'soft'))
        x_hat=y;
    else
        disp('not supported');
    end
    
    %viterbi decoder
    convDec=comm.ViterbiDecoder;
    delay=convDec.TracebackDepth*log2(convDec.TrellisStructure.numInputSymbols);
    b_hat=step(convDec, [x_hat;zeros(2*delay,1)]);
    
    %BER
    nerr=nerr+sum((b~=b_hat(delay+1:K+delay)));
end
BER=nerr/(N*K);
end

