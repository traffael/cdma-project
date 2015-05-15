SNR = (-2:7);
K = 200;
m = 1000;
b = randi([1,1],K,1);
%poly = [753 561];
%k = 9;
L = 34; %5*k;

convEnc = comm.ConvolutionalEncoder;
convDec = comm.ViterbiDecoder('TracebackDepth', L);

convEnc = comm.ConvolutionalEncoder;
convDec = comm.ViterbiDecoder;
delay = convDec.TracebackDepth*log2(convDec.TrellisStructure.numInputSymbols);

convEnc.PuncturePatternSource = 'Property';
convEnc.PuncturePattern = [1;1;0;1];
convDec.PuncturePatternSource = 'Property';
convDec.PuncturePattern = convEnc.PuncturePattern;

c = step(convEnc, b);
x = zeros(length(c),1);
x = 1 - 2*c;  

Result = zeros(1,length(SNR));
tic
for i = 1:length(SNR)
    for j = 1:m
        y = awgn(x,SNR(i));
        x_hat_hard = sign(y);
        b_hat = [x_hat_hard; zeros(2*delay+19,1)];
        b_hat1 = step(convDec,b_hat);
        b_hat2 = b_hat1(delay+1:end);
        Error = sum(b ~= b_hat2);
        Result (i) = Result(i) + Error;
    end;
end;
Result1 = Result./(m*K);
T = toc;

%figure(2)
%hold on
%semilogy(Result1,'bo-');
%xlabel('SNR','FontSize',12,'FontWeight','bold');
%ylabel('BER','FontSize',12,'FontWeight','bold');
%grid minor;

%T = [4.9646 5.1902 5.2873 5.5931 9.2598];
%T = T./200;
%plot(T);
%xlabel('Lx','FontSize',12,'FontWeight','bold');
%ylabel('Time, sec','FontSize',12,'FontWeight','bold');
%grid minor;

%T = [5.1322 6.0081 10.4385];
%T = T./200;
%plot(T);
%xlabel('Lx','FontSize',12,'FontWeight','bold');
%ylabel('Time, sec','FontSize',12,'FontWeight','bold');
%grid minor;

% 18 для случая [1;1;0;1]
