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
P.NumberOfFrames  = 1000;
P.nMIMO = 1; %1 antenna
P.useIS95Walsh = 1; %boolean, 1 if the standard Walsh mapping is used as
%                   defined in the IS95 standard. 0 if
%                   orthogonalMIMO(De)modulation function is used.

P.nUsers = 16; % Number of users
for i_user = 1:P.nUsers
    ESN = randi([0 1],1, 32);
    P.Long_code(:,i_user) = gen_long_code(ESN,P); %PN sequence. Specific to each USER, but the SAME for both mimo
end 

P.SNRRange = -16:2:10; % SNR Range to simulate in dB

P.ReceiverType  = 'Rake';

P.RakeFingers = 3;
BERmultipath = simulator(P);


figure(1)
hold on
semilogy(P.SNRRange,BERmultipath,'g.-')

xlabel('SNR','FontSize',12,'FontWeight','bold');
ylabel('BER','FontSize',12,'FontWeight','bold');
xlim([min(P.SNRRange) max(P.SNRRange)]);
grid on;
