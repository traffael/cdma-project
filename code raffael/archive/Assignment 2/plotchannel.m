NumberOfSymbols     = 1000; % OFDM Symbols per Frame
NumberOfCarriers    = 20;    % OFDM Carrier within One symbol

CoherenceTime       = 100;
CoherenceBandwith   = 20;


h = channel(1,NumberOfSymbols,NumberOfCarriers,CoherenceTime,CoherenceBandwith);


figure(1)
subplot(1,2,1)
if NumberOfCarriers == 1 || NumberOfSymbols == 1
    plot(abs(h))
else
    surf(abs(h))
end

zlim([0 2])
xlabel('Time','FontSize',12,'FontWeight','bold')
ylabel('Frequency','FontSize',12,'FontWeight','bold');
zlabel('|h|','FontSize',12,'FontWeight','bold');

subplot(1,2,2)
if NumberOfCarriers == 1 || NumberOfSymbols == 1
    plot(unwrap(angle(h)))
else
    surf(angle(h))
end
xlabel('Time','FontSize',12,'FontWeight','bold')
ylabel('Frequency','FontSize',12,'FontWeight','bold');
zlabel('angle(h)','FontSize',12,'FontWeight','bold');
