% Wireless Receivers II - Assignment 2:
%
% Antenna select diversity
%
% Telecommunications Circuits Laboratory
% EPFL

% Parameters
P.NumberOfFrames      = 500;
P.NumberOfSymbols     = 1000; % OFDM Symbols per Frame
P.NumberOfCarriers    = 1;    % OFDM Carrier within One symbol

P.CoherenceTime       = 100;
P.CoherenceBandwidth  = 1;

P.CodingType    = 'None';
P.Modulation    = 1;        % 1: BPSK
P.ChannelType   = 'Fading'; % 'AWGN', 'Fading'
P.ReceiverType  = 'MaximumRatio';

P.RX = 2; % Number of RX antennas

P.SNRRange = 0:10; % SNR Range to simulate in dB

BER = simulator(P);

figure(1)
semilogy(P.SNRRange,BER)
xlabel('SNR','FontSize',12,'FontWeight','bold');
ylabel('BER','FontSize',12,'FontWeight','bold');