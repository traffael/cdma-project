% Wireless Receivers II - Assignment 5:
%
% MIMO Capacity
%
% Telecommunications Circuits Laboratory
% EPFL
%-------------
clear; close all; clc; % tabula rasa
%-------------
% Parameters
ant=[2,3,4]; % number of antennae
ebn0dB=0:2:20; % Eb/N0 ratios to consider (in db)
nInst=1e4; % number of random instances to average over
ebn0=10.^(ebn0dB/10); % calculate the linear Eb/N0 ratios
C=zeros(length(ant),length(ebn0)); % capacities
%-------------
% Derive all the curves
for a=1:length(ant) % for each antenna configuration
  disp(['Calculating the ',num2str(ant(a)),'x',num2str(ant(a)),...
    ' scenario']); % let the user know what we're up to
  for r=1:length(ebn0) % for each Eb/N0 level
    Ca=0; % initiate the accumulator
    for k=1:nInst % for each instance
        H=sqrt(1/2)*(randn(ant(a),ant(a))+1i*randn(ant(a),ant(a))); % get a random channel matrix
        [U S V] = svd(H);
        Int = eye(ant(a));% get the singular values
        Ca = Ca + log2(det(Int+ebn0(r)/ant(a)*S^2));% accumulate the capacity for this instance вставить SNR 
        %C = mean(log2(det(Int+ebn0(r)/ant(a)*S^2)));% accumulate the capacity for this instance вставить SNR 
    end % for loop (random instances)
    C(a,r)=Ca/nInst; % take the expectation
  end % for loop (Eb/N0 levels)
end % for loop (antenna configurations)
%-------------
% Plot the results
plot(ebn0dB,C'); % generate the basic plot
grid on; % turn on the grid
set(gca,'fontsize',14); % use bigger fonts
xlabel('E_b/N_0 [dB]','fontsize',14); % label the x axis
ylabel('Capacity [bits/s/Hz]','fontsize',14); % label the y axis
lbl=cell(length(ant),1); % labels for the legend
for q=1:length(ant) % loop through the configurations
  lbl{q}=[num2str(ant(q)),' x ',num2str(ant(q))];
end % for loop (antenna configurations)
legend(lbl,'location','northwest'); % add the legend
%EOF
