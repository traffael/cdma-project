% Creates the BER plot

% clear all
% close all
% clc

% SNR range
EbN0dB = 0:4:32;

% Number of frames per SNR
nRep = 1000;

% Define combing parameter
M = [ 2 4 8 16 32 ];

% Plot estimated channels or not
doPlot = 0;

% Initialize BER
BER = zeros(numel(M),length(EbN0dB),nRep);

% Calculate BER
for kt = 1:numel(M)
    for kk = 1:numel(EbN0dB)
        EbN0dB(kk)
        for km = 1:nRep
            BER(kt,kk,km) = OFDMTask(EbN0dB(kk), M(kt), doPlot);
        end
    end
end

% Get mean BER for each algorithm
BER = mean(BER,3);

% Plot results
figure(1)
figMar = {'bs-','ro-','gv-', 'c^-', 'm<-'};
for ii = 1:numel(M)
    semilogy(EbN0dB, BER(ii,:), figMar{mod(ii,5)+1}, 'LineWidth', 2)
    legendstr{ii} = sprintf('M = %d', M(ii));
    hold on
end
legend(legendstr, 'Location', 'Best')
grid on
xlabel('Eb/N0')
ylabel('BER')
title('BER vs Eb/N0 for different combing parameters')
hold off
