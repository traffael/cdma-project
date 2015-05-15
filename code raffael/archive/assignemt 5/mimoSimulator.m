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
nt=4; % number of transmit antennae
nr=4; % number of receive antennae
sn=0.01; % noise variance, quite small (just for illustration)
sr=1; % Rayleigh parameter for H
L=3; % block length (number of symbols)
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
  % decompose the matrix
  % pre processing; x is actually transmitted
  % MIMO propagation
  % post processing; we're interested in yt
%-------------
% Reception
yt=yt(1:r,:); % trunkate to nr, in case nr>nt
ym=sign(real(yt)); % *very* simplified hard symbol mapping
yb=-0.5*ym+0.5; % BPSK demodulate
%EOF
