function [sHat, complexity] = ZF_Detector(H, y, Pn_dB, Constellations)
% ZF_DETECTOR_BIASED - Biased ZF detector. Performes a ZF detection using
% a More-Penrose pseudo inverse for detection.
%    [sHat, complexity] = ZF_Detector(H, y, Pn_dB, Constellations)
%    
%    Arguments:
%      H:              (matrix)          Channel matrix
%      y:              (vector)          Receive vector
%      Pn_dB:          (real)            Noise power
%      Constellations: (vector)          Vector with all possible constellations
%    Return values:
%      sHat:           (integer vector)  Estimate of transmit vector
%      complexity:     (integer)         Complexitx messure. (Not used)
% 
% Author(s): YOU
% Copyright (c) 2012 TCL.

i=0;

% perform some initial stuff (if required)
% ...

% invert the channel matrix
G = inv(H);

% Equalize received vector
% sTilde = ... index from 0-15 of the closest point


% slice to nearest constellation point
% sHat = ...

% remaining outputs
complexity = 0;

end
