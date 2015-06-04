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
%nt=4; % number of transmit antennae Task1 
%nr=4; % number of receive antennae  Task1

nt = 3;
nr = 5;

%sn=0.01; % noise variance, quite small (just for illustration)
sn=0.5; % noise variance, quite small (just for illustration)
sr=1; % Rayleigh parameter for H
%L=3; % block length (number of symbols)
L=10000; % block length (number of symbols)
%-------------
% Set up the channel
H=sqrt(1/2)*(randn(nr,nt)+1i*randn(nr,nt)); % get a random channel matrix
r=rank(H); % how many eigenchannels can we support?
%-------------
% Generate the data to be transmitted and some noise
xb=randi(2,r,L)-1; % random binary data symbols to transmit
xt=-2*xb+1; % BPSK modulate
xt=[xt;zeros(nt-r,L)]; % pad with zeros (unused data!) to length nt
w=sqrt(sn/2)*(randn(nr,L)+1i*randn(nr,L)); % complex random noise
%-------------
% Transmission
[U Dec_H V] = svd(H);  % decompose the matrix получили диагональную матрицу круто V уже транспонированная
xt_tild = V*xt;  % pre processing; x is actually transmitted 
yt_tild = H*xt_tild + w;  % MIMO propagation потому что все Гауссовское, можно с шумом ничего не делать
yt = U'*yt_tild;  % post processing; we're interested in yt
%-------------
% Reception
yt=yt(1:r,:); % trunkate to nr, in case nr>nt
ym=sign(real(yt)); % *very* simplified hard symbol mapping
yb=-0.5*ym+0.5; % BPSK demodulate
Result = sum(xb~=yb,2)./L ;%EOF
%Result = sum(xt_tild~=yt_tild,2)./L ;
