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
P.ChannelType   = 'Multipath'; % 'AWGN', 'Fading'
P.ChannelLength = 1;
P.NumberOfFrames  = 5;
P.nMIMO = 2; %2 antennas
P.useIS95Walsh = 0; %boolean, 1 if the standard Walsh mapping is used as
%                   defined in the IS95 standard. 0 if
%                   orthogonalMIMO(De)modulation function is used.

ESN1 = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1];
%ESN2 = [1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0];
% only needed for the second user.

P.Long_code = zeros( 256*3/4,96,2);
P.Long_code(:,:,1) = gen_long_code(ESN1,P); %PN sequence. Specific to each USER, but the SAME for both mimo
%P.Long_code(:,:,2) = Long_code(ESN2); 

P.nUsers = 1; % Number of users

P.SNRRange = -16:2:10; % SNR Range to simulate in dB

P.ReceiverType  = 'Rake';

P.RakeFingers = 1;


BERmimo = simulatorMIMO(P);

figure(1)
semilogy(P.SNRRange,BERmimo,'b.-')

xlabel('SNR','FontSize',12,'FontWeight','bold');
ylabel('BER','FontSize',12,'FontWeight','bold');
xlim([min(P.SNRRange) max(P.SNRRange)]);
grid on;
