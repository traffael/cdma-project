% Wireless Receivers II - Assignment 1:
%
% AWGN Spread Spectrum Parameter File
%
% Telecommunications Circuits Laboratory
% EPFL

% Parameters
P.NumberOfFrames      = 1000;
P.NumberOfSymbols     = 1000;

P.CoherenceTime       = 100;

P.CodingType    = 'None';
P.Modulation    = 1;        % 1: BPSK
P.ChannelType   = 'AWGN'; % 'AWGN', 'Fading','Multipath'

P.ReceiverType  = 'Correlator';

P.RX = 1; % Number of RX antennas

P.SNRRange = -20:10; % SNR Range to simulate in dB
SNRRange = P.SNRRange;

P.SNRRange = EbN0shift(SNRRange);
P.Sequence = [ 1 1 -1 1];
BER1 = simulator(P);

P.Sequence =  [1 1 1 1 -1 1 -1];
BER2 = simulator(P);

P.Sequence =  [1 1 1 1 1 1 -1];
BER3 = simulator(P);

P.Sequence =  [-1 -1 -1 1 1 1 1];
BER4 = simulator(P);

%P.Sequence =  [1 1 1 1 1 1 1];
%BER5 = simulator(P);

%P.Sequence =  [1 -1 1 -1 1 1 1];
%BER6 = simulator(P);

P.Sequence =  [-1 -1 -1 -1 -1 -1 -1];
BER7 = simulator(P);

%P.Sequence =  [1 1 1 -1 -1 -1 1 -1 -1 1 -1];
%BER3 = simulator(P);

%P.Sequence =  [1 1 1 1 1 -1 -1 1 1 -1 1 -1 1];
%BER4 = simulator(P);



figure(1)
semilogy(P.SNRRange,BER1,'b.-')
hold on
semilogy(P.SNRRange,BER2,'r.-')
semilogy(P.SNRRange,BER3,'g.-')
semilogy(P.SNRRange,BER4,'m.-')
%semilogy(P.SNRRange,BER6,'y.-')
semilogy(P.SNRRange,BER7,'k.-')

%EbN0 = EbN0shift(P);
xlabel('SNR','FontSize',12,'FontWeight','bold');
ylabel('BER','FontSize',12,'FontWeight','bold');
xlim([min(P.SNRRange) max(P.SNRRange+5)]);
grid on;
