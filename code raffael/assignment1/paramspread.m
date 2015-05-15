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

P.SNRRange = -10:10; % SNR Range to simulate in dB

%multiple parameters
nSim=4;
for i=1:nSim
    Pm{i}=P;
end
Pm{1}.Sequence = [1 1 -1 1];
Pm{2}.Sequence = [1 1 1 -1 -1 1 -1 ];
Pm{3}.Sequence = [1 1 1 -1 -1 -1 1 -1 -1 1 -1];
Pm{4}.Sequence = [1 1 1 1 1 -1 -1 1 1 -1 1 -1 1];


close all;


for i=1:nSim
    
    BER = simulator(Pm{i});
    figure(1)
    semilogy(Pm{i}.SNRRange,BER)
    hold on
    
    figure(2)
    semilogy(EbN0shift(Pm{i}),BER)
    hold on

end

figure(1)
xlabel('SNR','FontSize',12,'FontWeight','bold');
ylabel('BER','FontSize',12,'FontWeight','bold');
xlim([min(Pm{end}.SNRRange) max(Pm{1}.SNRRange)]);
grid on;
legend('4','7','11','13')
hold off

figure(2)
xlabel('SNR','FontSize',12,'FontWeight','bold');
ylabel('BER','FontSize',12,'FontWeight','bold');
xlim([min(Pm{end}.SNRRange) max(Pm{1}.SNRRange)]);
grid on;
legend('4','7','11','13')
hold off
