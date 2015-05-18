function [sHat, complexity] = MMSE_Detector_Biased(H, y, Pn_dB, Constellations)
% MMSE_DETECTOR_BIASED - Biased MMSE detector. Performes a MMSE detection using
% a More-Penrose pseudo inverse for detection.
%    [sHat, complexity] = MMSE_Detector_Biased(H, y, Pn_dB, Constellations)
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


% perform some initial stuff (if required)
% ...


% invert the channel matrix
% G = ...

% Equalize received vector
% sTilde = ...

% slice to nearest constellation point
% sHat = ...


% remaining outputs
complexity = 0;

end
