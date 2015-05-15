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
P.ChannelType   = 'AWGN'; % 'AWGN', 'Fading'
P.ReceiverType  = 'Simple'; 

P.RX = 1; % Number of RX antennas

P.SNRRange = 0:8; % SNR Range to simulate in dB

BER1 = simulator(P);

P.ChannelType   = 'Fading'; % 'AWGN', 'Fading'

BER2 = simulator(P);

P.RX = 2; 
P.ReceiverType  = 'AntennaSelect'; 

BER3 = simulator(P);

P.ReceiverType  = 'MaximumRatio'; 

BER4 = simulator(P);

figure(1)
semilogy(P.SNRRange,BER1,'bo-','LineWidth',2)
hold on
semilogy(P.SNRRange,BER2,'rx-','LineWidth',2)
semilogy(P.SNRRange,BER3,'gx-','LineWidth',2)
semilogy(P.SNRRange,BER4,'cx-','LineWidth',2)

xlabel('SNR','FontSize',14,'FontWeight','normal');
ylabel('BER','FontSize',14,'FontWeight','normal');
legend('AWGN','Fading (Simple)','Fading (2RX AntennaSelect)','Fading (2RX MRC)', 'Location','SouthWest')

%print('-depsc2','fig/cmp-awgn-fading')