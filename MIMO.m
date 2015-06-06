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

% perform some initial stuff (if required)
% ...

% invert the channel matrix
 G = pinv(H);
 %G = 1\H;

% Equalize received vector
 sTilde = G*y;


% slice to nearest constellation point
 %B = repmat(A,n)
 %ar = y-H*sTilde;
 %[max_s index_s] = min(y-H*sTilde);
 Sravn = zeros(length(Constellations),1);
 sHat = zeros(length(sTilde),1);
 sHat_dist = zeros(length(sTilde),1);
 for i=1:length(sTilde)
     for j=1:length(Constellations)
         Sravn(j) = abs(sTilde(i)-Constellations(j));
     end;
     [sHat_dist(i) sHat(i)] = min(Sravn);
 end;
 %sHat = argmin ot rasstoyaniya % daet chislo v const ot 0 - 15
sHat = sHat - 1;
% remaining outputs
complexity = 0;

end
