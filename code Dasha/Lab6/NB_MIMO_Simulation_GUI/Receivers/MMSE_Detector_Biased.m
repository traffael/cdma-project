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
 H_h = H';
 Nt = 4;
 sigma_sq = 10.^(Pn_dB/10);
 Ps = 1; %???????
 I = eye(length(H));


% invert the channel matrix
 Z = H_h*H+Nt*sigma_sq/Ps*I;
 G = inv(Z)*H_h;
 
% Equalize received vector
 sTilde = G*y;

% slice to nearest constelation point
 Sravn = zeros(length(Constellations),1);
 sHat = zeros(length(sTilde),1);
 sHat_dist = zeros(length(sTilde),1);
 for i=1:length(sTilde)
     for j=1:length(Constellations)
         Sravn(j) = abs(sTilde(i)-Constellations(j));
     end;
     [sHat_dist(i) sHat(i)] = min(Sravn);
 end;

sHat = sHat - 1;
% remaining outputs
complexity = 0;

end
