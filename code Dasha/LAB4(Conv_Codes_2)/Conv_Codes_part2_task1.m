%Task 3  потренироваться на меньшем колличестве данных

K = 200;
m = 1000;
P = 1;
R = 1;
Eb_No = (-2:10);
%SNR = (-2:7);
L = [13 34 55 K];
Result1 = zeros(length(L),length(Eb_No));
Result = zeros(1,length(Eb_No));
sigma_kvadr = (P/R)./(10.^(Eb_No/10));

for k = 1:length(L)
    convEnc = comm.ConvolutionalEncoder;
    convDec = comm.ViterbiDecoder('TracebackDepth', L(k));
    delay = convDec.TracebackDepth*log2(convDec.TrellisStructure.numInputSymbols);
for i = 1:length(Eb_No)
    for j = 1:m
        tic;
        b = randi([0,1],K,1);
        c = step(convEnc, b);
        x = 1 - 2*c;
        %y = x + sqrt(sigma_kvadr(i)/2)*randi([0,1],K*2,1);
        y = awgn(x,Eb_No(i));
        x_hat_soft = y;
        x_hat_soft_new = [x_hat_soft; zeros(2*delay,1)];
        b_hat = step(convDec, [x_hat_soft; zeros(2*delay,1)]);
        b_hat = b_hat(delay+1:end);
        Error = sum(b ~= b_hat);
        Result(i) = Result(i) + Error;
    end;
end;
T = toc;
Result1(k,:) = Result./(m*K);
end;

%figure(1)
semilogy(Result1(1,:),'bo-');
hold on
semilogy(Result1(2,:),'go-');
semilogy(Result1(3,:),'ro-');
semilogy(Result1(4,:),'yo-');
grid minor;