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
P.codeLength = 8; % encoding (K=1+P.codeLength = 8)
P.ChannelLength = 3;
P.NumberOfFrames  = 3;
P.nMIMO = 1; %1 antenna
P.useIS95Walsh = 1; %boolean, 1 if the standard Walsh mapping is used as
%                   defined in the IS95 standard. 0 if
%                   orthogonalMIMO(De)modulation function is used.

ESN1 = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];

P.Long_code = gen_long_code(ESN1,P);
P.RX = 1; % Number of RX antennas
P.Users = 2;

P.SNRRange = -20:2:5; % SNR Range to simulate in dB

P.ReceiverType  = 'Rake';

P.RakeFingers = 3;
BERmultipath = simulator(P);


figure(1)
semilogy(P.SNRRange,BERmultipath,'b.-')

xlabel('SNR','FontSize',12,'FontWeight','bold');
ylabel('BER','FontSize',12,'FontWeight','bold');
xlim([min(P.SNRRange) max(P.SNRRange)]);
grid on;
