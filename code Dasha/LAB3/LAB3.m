% Plot the AWGN spectral efficiency for for a range of SNR = {?6, .., 20} dB
n = 10000;
m = 1000;
SNR = (-6:21);
lsnr = length(SNR);
C = log2(1+10.^(SNR./10));
plot(SNR,C,'b*-');
xlabel('SNR','FontSize',12,'FontWeight','bold');
ylabel('C','FontSize',12,'FontWeight','bold');
grid minor;

% What is the spectral efficiency for a given realization of h, i.e., C1(h) 
SNR1 = SNR(1);
H = randn(1,n)*sqrt(0.5)+1j*randn(1,n)*sqrt(0.5);
C1 = log2(1+abs(H)*10^(SNR1/10));
EC1 = sum(C1)/m;

% Find the average/ergodic capacity Eh {C(h)} of the fading channel
% Due to the dependence on the random channel realization, the capacity C1 
% (W = 1) is a also random variable. Plot the empirical cumulative distribution 
% function (eCDF) of C1 (W = 1).

ECDF1=zeros(lsnr,m);
C1_min = min(C1);
C1_max = max(C1);
h = (C1_max - C1_min)/m;
a1 = C1_min - h/2;

for k = 1:5
    SNR1 = SNR(k)*2;
    H = randn(1,n)*sqrt(0.5)+1j*randn(1,n)*sqrt(0.5);
    C1 = log2(1+abs(H)*10^(SNR1/10));
    a1 = C1_min - h/2;
    for i = 1:m
        for j = 1:length(C1)
           if a1 <= C1(j) <= a1 + h
              ECDF1(k,i) = ECDF1(k,i) + 1;
           end;
        end;
    a1 = a1+h;
    end;
end;
ECDF1 = ECDF1./max(max(ECDF1));
plot(ECDF1(1,:),'b-')
hold on
plot(ECDF1(2,:),'r-')
plot(ECDF1(3,:),'m-')
plot(ECDF1(4,:),'y-')
plot(ECDF1(5,:),'g-')
xlabel('C','FontSize',12,'FontWeight','bold');
ylabel('iCDF','FontSize',12,'FontWeight','bold');
grid minor;

%[f1,x] = ecdf(C1);
%plot(f1,x)
%plot(ECDF1);


%Compute the Mutual information between the sample set b and y that you find on the
%Moodle for download

% distribution law for y
m = 8;
Py = zeros(1,m+1);
a1 = min(y)-2;
for k = 1:m+1 
    a1 =  a1 + 1;
        for j = 1:n
           if y(j) == a1
              Py(k) = Py(k) + 1;
           end;
        end;
end;
Py = Py./sum(Py);

% distribution law for b
m = 3;
Pb = zeros(1,m);
a1 = min(b)-2;
for k = 1:m 
    a1 =  a1 + 1;
        for j = 1:n
           if b(j) == a1
              Pb(k) = Pb(k) + 1;
           end;
        end;
end;
Pb = Pb./sum(Pb);
Pb = [0 0 0 Pb 0 0 0];

% distribution law for y and b both
m = 4;
Pyb = zeros(1,m+1);
a1 = min(b)-2;
for k = 1:m+1 
    a1 =  a1 + 1;
        for j = 1:n
           if y(j) == a1 && b(j) == a1
              Pyb(k) = Pyb(k) + 1;
           end;
        end;
end;
Pyb = Pyb./sum(Pyb);
plot(Pb);
xlabel('n','FontSize',12,'FontWeight','bold');
ylabel('Pb','FontSize',12,'FontWeight','bold');

Pyb = [ 0 0 Pyb 0 0];

%I = zeros(9,9);
I = 0;
Na_vsyaki=zeros(9,9);
for i = 1:9
    for j = 1:9
        if Py(i)*Pb(j) > 0 && Pyb(i)/(Py(i)*Pb(j)) > 0
        I = I + Pyb(i).*log(Pyb(i)/(Py(i)*Pb(j)));
        Na_vsyaki(j,i) = Pyb(i).*log(Pyb(i)/(Py(i)*Pb(j)));
        end;
    end;
end;

% What is the code rate that is required by a perfect code to ensure error-free transmission
% with this de-/modulation
R = I/n;
