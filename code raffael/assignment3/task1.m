%% plot the awgn spectral efficiency for snr= -6....20 dB

SNRdb  = -6:20;
SNRlin = 10.^(SNRdb./10);
SpecEff = log2(1+SNRlin);

figure(1)
plot(SNRdb,SpecEff)
xlabel('SNR','FontSize',12,'FontWeight','bold');
ylabel('Spectral efficiency','FontSize',12,'FontWeight','bold');
xlim([min(SNRdb) max(SNRdb)]);
grid minor;


%% find the average capacity of the fading channel

nIter = 1e6;

AvgCapacity=zeros(1,length(SNRdb));
for s=1:length(SNRdb)
    SNRlin = 10.^(SNRdb(s)./10);
    
    h = 1/sqrt(2)*(randn(1,nIter) + 1i* randn(1,nIter));
    normhby2 = abs(h).^2;
    C1 = log2(1+normhby2.*SNRlin);
    AvgCapacity(s)=mean(C1);
end

figure(2)
plot(SNRdb,AvgCapacity)
xlabel('SNR','FontSize',12,'FontWeight','bold');
ylabel('average capacity','FontSize',12,'FontWeight','bold');
xlim([min(SNRdb) max(SNRdb)]);
grid minor;


%% eCDF of spectral efficiency

cdf=0:0.2:6;

SNRdb  = [-6 -0, 5, 10];

figure(3)
for s=1:length(SNRdb)
    
    SNRlin = 10.^(SNRdb(s)./10);
    
    h = 1/sqrt(2)*(randn(1,nIter) + 1i* randn(1,nIter));
    normhby2 = abs(h).^2;
    C1 = log2(1+normhby2.*SNRlin);
    
    C1_cdf=zeros(1,length(cdf));
    for i=1:length(cdf)
        C1_cdf(i)=sum(C1<cdf(i))/length(C1);
    end
    plothandle(s)=plot(cdf,C1_cdf);
    hold on
end

xlabel('C_1','FontSize',12,'FontWeight','bold');
ylabel('eCDF of C_1','FontSize',12,'FontWeight','bold');
xlim([min(cdf) max(cdf)]);
legend(plothandle, 'SNR = -6dB', 'SNR = 0dB', 'SNR = 5dB', 'SNR = 10dB');
grid minor;
hold off

%% get the 10% outage capacity


cdf=0:0.02:6;

SNRdb  = [-6 -0, 5, 10];

outage_rate=0:0.1:1;
C_outage = zeros(1, length(outage_rate));

figure(4)
for s=1:length(SNRdb)
    
    SNRlin = 10.^(SNRdb(s)./10);
    
    h = 1/sqrt(2)*(randn(1,nIter) + 1i* randn(1,nIter));
    normhby2 = abs(h).^2;
    C1 = log2(1+normhby2.*SNRlin);
    
    C1_cdf=zeros(1,length(cdf));
    for i=1:length(cdf)
        C1_cdf(i)=sum(C1<cdf(i))/length(C1);
    end
    plothandle(s)=plot(100*C1_cdf,cdf);
    hold on
end


xlabel('outage rate (%)','FontSize',12,'FontWeight','bold');
ylabel('outage capacity at given rate','FontSize',12,'FontWeight','bold');
xlim([0 max(outage_rate*100)]);
legend(plothandle, 'SNR = -6dB', 'SNR = 0dB', 'SNR = 5dB', 'SNR = 10dB');
grid minor;
hold off
