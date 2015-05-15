% Wireless Receivers II - Assignment 2:
%
% Comparison Fading vs AWGN
%
% Telecommunications Circuits Laboratory
% EPFL

% Parameters
P.NumberOfFrames      = 1000;
P.NumberOfSymbols     = 1000; % OFDM Symbols per Frame
P.NumberOfCarriers    = 1;    % OFDM Carrier within One symbol

P.CoherenceTime       = 100;
P.CoherenceBandwidth  = 1;

P.CodingType    = 'None';
P.Modulation    = 1;        % 1: BPSK
P.ChannelType   = 'Fading'; % 'AWGN', 'Fading'
P.ReceiverType  = 'MaximumRatio'; 
P.SNRRange = -5:10; % SNR Range to simulate in dB

P.RX = 1; % Number of RX antennas
BER1 = simulator(P);

P.SNRRange = -8:7;
P.RX = 2; 
BER2 = simulator(P);

P.SNRRange = -11:4;
P.RX = 3; 
BER3 = simulator(P);

P.SNRRange = -5:10;
figure(1)
clf
semilogy(P.SNRRange,BER1,'bx-','LineWidth',2)
hold on
semilogy(P.SNRRange,BER2,'rx-','LineWidth',2)
semilogy(P.SNRRange,BER3,'gx-','LineWidth',2)

xlabel('SNR','FontSize',14,'FontWeight','normal');
ylabel('BER','FontSize',14,'FontWeight','normal');
legend('Fading (1RX)','Fading (2RX)','Fading (3RX)', 'Location','SouthWest')

%print('-depsc2','fig/cmp-awgn-fading')