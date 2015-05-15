function [sHat, complexity] = SIC_Detector(H, y, Pn_dB, Constellations)
% SIC_DETECTOR_BIASED - SIC detector. Performes a SIC detection.
%    [sHat, complexity] = SIC_Detector(H, y, Pn_dB, Constellations)
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
  Nt = 4;  % find somehow from # of constellations? 

% invert the channel matrix
% G = ...

% Equalize received vector
% sTilde = ...

 Sravn = zeros(Nt,1);
 sHat = zeros(Nt,1);
 sHat_dist = zeros(Nt,1);
 g = zeros(length(H),1);
 H_new = H;
 
 for kk = 1:Nt-1
     G = pinv(H_new);
     %e = zeros(Nt-kk+1,1);
     %e(1) = 1;
     g = G(1,:); % g(kk) = e'*H_cr(:,kk)';  % linear estimator
     sTilde = g*y;
     for i=1:length(sTilde)   % symbol detection
        for j=1:length(Constellations)
            Sravn(j) = abs(sTilde(i)-Constellations(j));
        end;
        [sHat_dist(i) sHat(i)] = min(Sravn);  
     end;
     y = y - H_new(kk)*sHat(kk);  % interference cancellation изменяем весь вектор y
     H_new = H_new(:,2:Nt-kk+1);  % removing a column
 end;
% slice to nearest constellation point
 sHat = sHat - 1;

% remaining outputs
complexity = 0;

end
