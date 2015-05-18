
K=100;
N=1e3;
SNR=-2:7;


BERhard=zeros(1, length(SNR));
BERsoft=zeros(1, length(SNR));
for i=1:length(SNR)
    i
    BERhard(i)=simulation(SNR(i),K,N,'hard');
    BERsoft(i)=simulation(SNR(i),K,N,'soft');
    
    BERhard10(i)=simulation(SNR(i),10*K,N,'hard');
    BERsoft10(i)=simulation(SNR(i),10*K,N,'soft');
end

figure
semilogy(SNR,BERsoft)
hold on;
semilogy(SNR,BERhard,'-r')
semilogy(SNR,BERsoft10,'-g')

semilogy(SNR,BERhard10,'-k')


grid on
title('BER');
xlabel('SNR (dB)');
ylabel('Bit error rate (logarithmic)');
legend('soft decoder K=100' , 'hard decoder K=100','soft decoder K=1000' , 'hard decoder K=1000')

hold off

