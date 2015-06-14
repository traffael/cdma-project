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
P.codeLength = 8; % encoding (K=1+P.codeLength = 8)
P.codeRate = 1/2; % convolutional coding rate
P.encoderPolynominal = [753 561];
P.hadamardLength = 64; 
P.ChannelType   = 'Multipath'; % 'AWGN', 'Fading'
P.ChannelLength = 4;
P.NumberOfFrames  = 1e3;
P.nMIMO = 2; %2 antennas
P.useIS95Walsh = 0; %boolean, 1 if the standard Walsh mapping is used as
%                   defined in the IS95 standard. 0 if
%                   orthogonalMIMO(De)modulation function is used.

P.nUsers = 64; % Number of users
for i_user = 1:P.nUsers
    ESN = randi([0 1],1, 32);
    P.Long_code(:,i_user) = gen_long_code(ESN,P); %PN sequence. Specific to each USER, but the SAME for both mimo
end 

P.SNRRange = -35:2:5; % SNR Range to simulate in dB

P.ReceiverType  = 'Rake';

P.RakeFingers = 4;

u=[1 8];
r=[ 3 ];
for i_rakefingers=1:length(r)
    i_rakefingers
    simlab=[];
    for i_nuser=1:length(u)
        i_nuser
        P.nUsers     = u(i_nuser);
        P.ChannelLength = r(i_rakefingers);
        P.RakeFingers = r(i_rakefingers);
        
        BER(i_nuser,:,i_rakefingers) = simulatorMIMO(P);
        
     %   if(u(i_nuser)>9)
            simlab{i_nuser} = sprintf('%s - Length: %d - Users: %d' ,P.ChannelType,P.ChannelLength,P.nUsers);
      %  else
      %      simlab(i_nuser,:) = sprintf('%s - Length: %d - Users:  %d' ,P.ChannelType,P.ChannelLength,P.nUsers);
      %  end
    end

figure
semilogy(P.SNRRange,BER(:,:,i_rakefingers),'*-')

xlabel('SNR','FontSize',12,'FontWeight','bold');
ylabel('BER','FontSize',12,'FontWeight','bold');
xlim([min(P.SNRRange) max(P.SNRRange)]);
ylim([1e-6, 1e0]);

grid minor;
legend(simlab);

end

BER
save('sim10e5')

