SNR = (-2:7);
K = 200;
m = 1000;
b = randi([0,1],K,1);
poly = [7 5];
k = 3;
L = 34; %5*k;

convEnc = comm.ConvolutionalEncoder;
convDec = comm.ViterbiDecoder;
convDec = comm.ViterbiDecoder('TracebackDepth', L);
delay = convDec.TracebackDepth*log2(convDec.TrellisStructure.numInputSymbols);

c = step(convEnc, b);
x = zeros(length(c),1);
x = 1 - 2*c;  

Result = zeros(1,length(SNR));
tic
for i = 1:length(SNR)
    for j = 1:m
        y = awgn(x,SNR(i));
        x_hat_hard = sign(y);
        b_hat = [x_hat_hard; zeros(2*delay,1)];
        b_hat = step(convDec,b_hat);
        b_hat = b_hat(delay+1:end);
        Error = sum(b ~= b_hat);
        Result (i) = Result(i) + Error;
    end;
end;
Result1 = Result./(m*K);
T = toc;

figure(2)
hold on
%semilogy(Result1,'bo-');
xlabel('SNR','FontSize',12,'FontWeight','bold');
ylabel('BER','FontSize',12,'FontWeight','bold');
grid minor;


T = [4.9646 5.1902 5.2873 5.5931 9.2598];
T = T./200;
plot(T);
xlabel('Lx','FontSize',12,'FontWeight','bold');
ylabel('Time, sec','FontSize',12,'FontWeight','bold');
grid minor;
