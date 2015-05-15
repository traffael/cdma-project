function SimResultsList=RunSim(Sim,Sys)
% Sweep SNR to obtain BER curves for various MIMO detection algorithms
% Note: data before constellation mapping :  s
%       data after constellation mapping  :  x
%       channel                           :  y = H * x + n
%       equalized data                    :  y_hat
%       sliced (and re-ordered) data      :  x_hat
%       final data (constellation idx)    :  s_hat

addpath Receivers;

% Training power per transmit-antenna relatove to the total transmit power
% during data transmission (Total training power = Ptrain*Ntx)
Sim.Ptrain_dB=500;      % set to +inf for perfect RX-CSI

%profile on;
start = now; [a, hostname] = system('hostname');

% -----------------------------------------------
% Constellations
% -----------------------------------------------
% Modulation_order = 2: QPSK, 4: 16QAM, 6: 64QAM
%Sys.Constellations=dmodce([0:2^Sys.Modulation_order-1],1,1,'qask',2^Sys.Modulation_order);

constObj = modem.qammod('M',2^Sys.Modulation_order, 'PhaseOffset', 0, 'SymbolOrder','binary', 'InputType', 'integer');
Sys.Constellations = constObj.Constellation;

% compute the power normalization (ensure TX power = 1)
const_power=(norm(Sys.Constellations)^2)/2^Sys.Modulation_order;
scaling=sqrt(1/const_power);
Sys.Constellations_norm=Sys.Constellations*scaling*sqrt(1/Sys.Ntx);

% -----------------------------------------------
% Reserve space for variables
% -----------------------------------------------
% s_hat
s_hat=zeros(Sys.Ntx,Sim.nr_of_data_per_channel);

% logs
BER_log=[];
for RxNumber=[1:length(Sim.RxList)]
    complexity_log{RxNumber}=zeros(length(Sim.SNR_dB_list),Sim.nr_of_channels);
end;
k=1;
% sweep through different SNR settings
disp(['simulating ', num2str(Sim.nr_of_channels), ' channels with ', num2str(Sim.nr_of_data_per_channel),...
    ' data/channel...']);
for SNR_dB=Sim.SNR_dB_list
  randn('seed',0);
  rand('seed',0);
  SNR=10^(SNR_dB/10);
  BER=zeros(1,length(Sim.RxList));
  disp(strcat('--------------------------- SNR_dB=', num2str(SNR_dB), ' ------------------------'));
  for avrg=[1:Sim.nr_of_channels]
    % -----------------------------------------------
    % generate random channel, entries with unit variance
    % -----------------------------------------------
    H=sqrt(1/2)*randn(Sys.Nrx,Sys.Ntx)+sqrt(-1/2)*randn(Sys.Nrx,Sys.Ntx);
    
    % -----------------------------------------------
    % generate random transmit data
    % -----------------------------------------------
    s=floor(rand(Sys.Ntx,Sim.nr_of_data_per_channel)*(2^Sys.Modulation_order));
    
    % -----------------------------------------------
    % modulation & power normalization
    % -----------------------------------------------
    %x=dmodce(s,1,1,'qask',2^Sys.Modulation_order)*scaling*sqrt(1/Sys.Ntx);
    x=Sys.Constellations(s+1)*scaling*sqrt(1/Sys.Ntx);
    x=x(:);
    
    % -----------------------------------------------
    % transmission & AWGN
    % -----------------------------------------------
    n = sqrt(1/2)*randn(Sys.Nrx,Sim.nr_of_data_per_channel)+sqrt(-1/2)*randn(Sys.Nrx,Sim.nr_of_data_per_channel);
    n = n*sqrt(1/SNR);
    y = H*x + n;
    
    % -----------------------------------------------
    % "imperfect" channel estimation 
    % -----------------------------------------------
    Ptrain=10^(Sim.Ptrain_dB/10);
    Hn = sqrt(1/(SNR*Ptrain))*(sqrt(1/2)*randn(Sys.Nrx,Sys.Ntx)+sqrt(-1/2)*randn(Sys.Nrx,Sys.Ntx));
    Hest = H + Hn;
    
    % -----------------------------------------------
    % rescaling & MIMO detection 
    % -----------------------------------------------
    Pn_dB = 10*log10(1/SNR);
    
    for RxNumber=[1:length(Sim.RxList)]
        RxFunctionName=Sim.RxList(RxNumber);
        RxFunctionCall=sprintf('%s(Hest,y,Pn_dB,Sys.Constellations_norm)',RxFunctionName{:});
        [s_hat,complexity]=eval(RxFunctionCall);
        s_bin=de2bi(s,Sys.Modulation_order);
        complexity_log{RxNumber}(k,avrg)=complexity;
        % compute BER
        BER(RxNumber)=BER(RxNumber)+length(find(mexde2bi(s_hat(:),Sys.Modulation_order)~=s_bin));
    end;
    
  end;
  tot_bits = Sys.Ntx*Sim.nr_of_channels*Sim.nr_of_data_per_channel*Sys.Modulation_order;
  BER_log=[BER_log;BER/tot_bits];
  k=k+1;
end;

SimResultsList={};
for RxNumber=[1:length(Sim.RxList)]
    SimResults.Sim=Sim;
    SimResults.complexity_log=complexity_log{RxNumber};
    SimResults.Sim.RxName=Sim.RxList(RxNumber);
    SimResults.Sim.RxList={};
    SimResults.Sys=Sys;
    SimResults.BER_log=BER_log(:,RxNumber);
    SimResults.DateStamp=now;
    SimResults.SelLine=1;
    SimResults.SelColor=1;
    SimResults.SelPoints=1;
    SimResults.Visible=1;
    SimResults.CommentText='Add comment here!';
    SimResults.LegendText=Sim.RxList{RxNumber};
    SimResults.LegendText(find(SimResults.LegendText=='_'))=' ';
    SimResultsList={SimResultsList{:},SimResults};
end;
