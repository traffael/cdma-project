%Task 2 
K = 200;
m = 1000;
P = 1;
R = 1;
%Eb_No = (-2:10);
SNR = (-2:7);
L = [13 34 55 K];
Result1 = zeros(length(L),length(SNR));
Result = zeros(1,length(SNR));
sigma_kvadr = (P/R)./(10.^(Eb_No/10));
poly = [7 5;155 117;753 561];
k = [3 7 9];
L = 5*k;



for u = 1:length(k)
    convEnc = comm.ConvolutionalEncoder('TrellisStructure', poly2trellis(k(u),poly(u,:))); %task 2
    convDec = comm.ViterbiDecoder('TrellisStructure', poly2trellis(k(u),poly(u,:)));  %task 2
    delay = convDec.TracebackDepth*log2(convDec.TrellisStructure.numInputSymbols);
for i = 1:length(SNR)
    for j = 1:m
        b = randi([0,1],K,1);
        c = step(convEnc, b);
        x = 1 - 2*c;
        %y = x + sqrt(sigma_kvadr(i)/2)*randi([0,1],K*2,1);
        y = awgn(x,SNR(i));
        x_hat_soft = y;
        x_hat_soft_new = [x_hat_soft; zeros(2*delay,1)];
        b_hat = step(convDec, [x_hat_soft; zeros(2*delay,1)]);
        b_hat = b_hat(delay+1:delay+K);
        Error = sum(b ~= b_hat);
        Result(i) = Result(i) + Error;
    end;
end;
Result1(u,:) = Result./(m*K);
end;

figure(1)
semilogy(Result1(1,:),'bo-');
hold on
semilogy(Result1(2,:),'go-');
semilogy(Result1(3,:),'ro-');
grid minor;
