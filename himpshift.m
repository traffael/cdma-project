N=1e6;
himp=0;

for i=1:N
himp = himp+  norm(sqrt(1/2)* (randn(2*P.nMIMO,P.nMIMO) + 1i * randn(2*P.nMIMO,P.nMIMO)));
end

himpavg2=himp/N

himp=0;

for i=1:N
himp = himp+  norm(sqrt(1/2)* (randn(3*P.nMIMO,P.nMIMO) + 1i * randn(3*P.nMIMO,P.nMIMO)));
end

himpavg3=himp/N

himp=0;

for i=1:N
himp = himp+  norm(sqrt(1/2)* (randn(4*P.nMIMO,P.nMIMO) + 1i * randn(4*P.nMIMO,P.nMIMO)));
end

himpavg4=himp/N

dBshift(1)=log10(himpavg2^2)*10
dBshift(2)=log10(himpavg3^2)*10
dBshift(3)=log10(himpavg4^2)*10

u=[1 4 8 16 32 64];
c=[2 3 4];
for i_chan=1:length(c)
    i_chan
    simlab=[];
    for i_nuser=1:length(u)
        i_nuser
        P.nUsers     = u(i_nuser);
        P.ChannelLength = c(i_chan);
        P.RakeFingers = c(i_chan);
        
        
     %   if(u(i_nuser)>9)
            simlab{i_nuser} = sprintf('%s - Length: %d - Users: %d' ,P.ChannelType,P.ChannelLength,P.nUsers);
      %  else
      %      simlab(i_nuser,:) = sprintf('%s - Length: %d - Users:  %d' ,P.ChannelType,P.ChannelLength,P.nUsers);
      %  end
    end

figure
semilogy(P.SNRRange - dBshift(i_chan),BER(:,:,i_chan),'*-')

xlabel('SNR','FontSize',12,'FontWeight','bold');
ylabel('BER','FontSize',12,'FontWeight','bold');
xlim([min(P.SNRRange)-dBshift(3), max(P.SNRRange)-dBshift(1)]);
ylim([1e-6, 1e0]);

grid minor;
legend(simlab);

end

