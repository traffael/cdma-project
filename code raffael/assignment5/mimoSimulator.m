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
nt=5; % number of transmit antennae
nr=3; % number of receive antennae
sn=0.5; % noise variance
sr=1; % Rayleigh parameter for H
L=4; % block length (number of symbols)
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
[U,S,V] = svd(H);  % decompose the matrix
x=V*xt;  % pre processing; x is actually transmitted
y=H*x+w;  % MIMO propagation
yt=U'*y;  % post processing; we're interested in yt
%-------------
% Reception
yt=yt(1:r,:); % trunkate to nr, in case nr>nt
ym=sign(real(yt)); % *very* simplified hard symbol mapping
yb=-0.5*ym+0.5; % BPSK demodulate

BER=sum(xb~=yb,2)./L
