K = 1000;
m = 1000;
SNR = (-2:7);
%b = ones(K,1);
b = randi([0,1],K,1);
convEnc = comm.ConvolutionalEncoder;
convDec = comm.ViterbiDecoder;
delay = convDec.TracebackDepth*log2(convDec.TrellisStructure.numInputSymbols);
c = step(convEnc, b);
x = zeros(length(c),1);
x = 1 - 2*c;  

Result = zeros(1,length(SNR));

for i = 1:length(SNR)
    for j = 1:m
        y = awgn(x,SNR(i));
        x_hat_hard = sign(y);
        b_hat = step( convDec,[x_hat_hard; zeros(2*delay,1)]);
        b_hat = b_hat(delay+1:end);
        Error = sum(b ~= b_hat);
        Result (i) = Result(i) + Error;
    end;
end;
Result1 = Result./(m*K);


for i = 1:length(SNR)
    for j = 1:1000
        y = awgn(x,SNR(i));
        x_hat_soft = y;
        b_hat = step( convDec, [x_hat_soft; zeros(2*delay,1)]);
        b_hat = b_hat(delay+1:end);
        Error = sum(b ~= b_hat);
        Result (i) = Result(i) + Error;
    end;
end;
Result2 = Result./(m*K);

figure(2)
semilogy(Result1,'bo-');
hold on
semilogy(Result2,'go-');
xlabel('SNR','FontSize',12,'FontWeight','bold');
ylabel('BER','FontSize',12,'FontWeight','bold');
grid minor;
