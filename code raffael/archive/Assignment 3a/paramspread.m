% Wireless Receivers II - Assignment 2:
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

P.Sequence = [ 1 1 1 -1 -1 1 -1 ]; 

P.SNRRange = -10:10; % SNR Range to simulate in dB

BER = simulator(P);

figure(1)
semilogy(P.SNRRange,BER)
xlabel('SNR','FontSize',12,'FontWeight','bold');
ylabel('BER','FontSize',12,'FontWeight','bold');
xlim([min(P.SNRRange) max(P.SNRRange)]);
grid on;
