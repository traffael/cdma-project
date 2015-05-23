% Wireless Receivers II - Assignment 1:
%
% Direct Sequence Spread Spectrum Simulation Framework
%
% Telecommunications Circuits Laboratory
% EPFL

Results = zeros(1,1);
N = 24576;
for ii = 1:1
    ii
%%-------------------------------------------------------------------------     
    % Coding
    P.NumberOfBits=6*64;
    NumberOfBitsRX=P.NumberOfBits;
    %bits = randi([0 1],1,P.NumberOfBits); % Random Data
    %bits = randi([0,1],1,6*64);
%%-------------------------------------------------------------------------
    % Orthogonal modulation
    c_orthogonal = orthogonalModulation(bits);
    
    % Bits repetition  
%    c_mult = mult4(c_ortogonal);
    
    % Spreading match filter  
%    mwaveform=spread_match_filter(c_mult);
    
	mwaveform = 1-2*c_orthogonal ;
    %mwaveform = 1-2*mwaveform ;
%%------------------------------------------------------------------------- 
    % Channel
  
            h = ones(1,length(mwaveform));
       
%%------------------------------------------------------------------------- 
    % Simulation
 
        SNRdb  = 12;
        SNRlin = 10^(SNRdb/10);
        noise  = 1/sqrt(2*SNRlin) *( randn(1,NumberOfBitsRX) + 1i* randn(1,NumberOfBitsRX) );
        % Channel
        
        P.ChannelType='AWGN';
        switch P.ChannelType
            case 'AWGN',
                y = mwaveform;% + noise';
            case 'Fading',
                y = mwaveform .* h + noise;
            case 'Multipath'
                y = conv(mwaveform,himp) + noise';
            otherwise,
                disp('Channel not supported')
        end
     
%%-------------------------------------------------------------------------         
        % Receiver
        % what is P.sequence ? 
        P.ReceiverType = 'Simple';
        switch P.ReceiverType
            case 'Simple',
                x_hat = y;                
            case 'Rake',
                rxsymbols=zeros(24576,1);
                for f=1:P.RakeFingers
                    ycrop = y(f:N+f-1);
                    rxsymbols = rxsymbols+ycrop*conj(himp(f));
                end
                x_hat = reshape(rxsymbols(1:N) < 0,1,N);
            otherwise,
                disp('Source Encoding not supported')
        end
          
%%-------------------------------------------------------------------------
        %rxbits_despread=despread_match_filter(x_hat);
        %sum1 = sum(rxbits_despread ~= c_mult');
        % Orthogonal demodulation
        %rxbits_demodul = demult4(rxbits_despread);
        %sum2 = sum(rxbits_demodul ~= c_ortogonal');
        rxbits_demodul=x_hat';
        demodwaveform = orthogonalDemodulation(rxbits_demodul);  
        sum3 = sum(demodwaveform ~= bits');      
        %demodwaveform1 = x_hat;
        
        deconvwaveform = 1-2*demodwaveform ;
        
%%------------------------------------------------------------------------- 
        % conv. Decoder
        %rxbits = conv_dec(deconvwaveform,length(bits_tail));
        % BER count
        
end




    
             
