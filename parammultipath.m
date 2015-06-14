% Wireless Receivers II - Assignment 1:
%
% AWGN Spread Spectrum Multipath Parameter File
%
% Telecommunications Circuits Laboratory
% EPFL

% Parameters
P=[];
P.NumberOfBits      = 184;


P.CodingType    = 'None';
P.Modulation    = 1;        % 1: BPSK
P.ChannelType   = 'Multipath'; % 'AWGN', 'Fading'
P.codeRate = 1/3; % convolutional coding rate
P.encoderPolynominal = [557 663 711]; % [753 561];
P.hadamardLength = 64; 
P.codeLength = 8; % encoding (K=1+P.codeLength = 9)
P.ChannelLength = 3;
P.NumberOfFrames  = 1e5;
P.nMIMO = 1; %1 antenna
P.useIS95Walsh = 1; %boolean, 1 if the standard Walsh mapping is used as
%                   defined in the IS95 standard. 0 if
%                   orthogonalMIMO(De)modulation function is used.

P.nUsers = 64; % Number of users
for i_user = 1:P.nUsers
    ESN = randi([0 1],1, 32);
    P.Long_code(:,i_user) = gen_long_code(ESN,P); %PN sequence. Specific to each USER, but the SAME for both mimo
end 

P.SNRRange = -35:2:5; % SNR Range to simulate in dB

P.ReceiverType  = 'Rake';

P.RakeFingers = 3;
u=[1 4 8 16 32 64];
c=[3];
BERmultipath=[];

for i_chan=1:length(c)
    i_chan
    simlab=[];
    for i_nuser=1:length(u)
        i_nuser
        P.nUsers     = u(i_nuser);
        P.ChannelLength = c(i_chan);
        P.RakeFingers = c(i_chan);
        
        BERmultipath(i_nuser,:,i_chan) = simulator(P);
        
     %   if(u(i_nuser)>9)
            simlab{i_nuser} = sprintf('%s - Length: %d - Users: %d' ,P.ChannelType,P.ChannelLength,P.nUsers);
      %  else
      %      simlab(i_nuser,:) = sprintf('%s - Length: %d - Users:  %d' ,P.ChannelType,P.ChannelLength,P.nUsers);
      %  end
    end

figure
semilogy(P.SNRRange,BERmultipath(:,:,i_chan),'*-')
title('IS95 with standard Walsh mapping Code rate = 1/2');

xlabel('SNR','FontSize',12,'FontWeight','bold');
ylabel('BER','FontSize',12,'FontWeight','bold');
xlim([min(P.SNRRange) max(P.SNRRange)]);
ylim([1e-6, 1e0]);

grid minor;
legend(simlab);
end

BERmultipath

%% ===========================================================

BERmultipath2=[];
P.useIS95Walsh = 0; %boolean, 1 if the standard Walsh mapping is used as
P.codeRate = 1/2; % convolutional coding rate
P.encoderPolynominal = [753 561];

for i_chan=1:length(c)
    i_chan
    simlab=[];
    for i_nuser=1:length(u)
        i_nuser
        P.nUsers     = u(i_nuser);
        P.ChannelLength = c(i_chan);
        P.RakeFingers = c(i_chan);
        
        BERmultipath2(i_nuser,:,i_chan) = simulator(P);
        
     %   if(u(i_nuser)>9)
            simlab{i_nuser} = sprintf('%s - Length: %d - Users: %d' ,P.ChannelType,P.ChannelLength,P.nUsers);
      %  else
      %      simlab(i_nuser,:) = sprintf('%s - Length: %d - Users:  %d' ,P.ChannelType,P.ChannelLength,P.nUsers);
      %  end
    end

figure
semilogy(P.SNRRange,BERmultipath2(:,:,i_chan),'*-')
title('IS95 with non-standard Walsh mapping. Code rate = 1/2');

xlabel('SNR','FontSize',12,'FontWeight','bold');
ylabel('BER','FontSize',12,'FontWeight','bold');
xlim([min(P.SNRRange) max(P.SNRRange)]);
ylim([1e-6, 1e0]);

grid minor;
legend(simlab);
end

BERmultipath2

save('simmultipath')