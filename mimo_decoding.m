function [ output_stream ] = mimo_decoding( input_virtual_antennas, H ,P )
%% TODO
%Constellations = [-1+1i, -1+1i, 1-1i, 1+1i];
H = H(1:P.RakeFingers,:,:);
MIMO_in = P.nMIMO*P.RakeFingers;
len_inp = length(input_virtual_antennas);
Constellations = [1, -1];
Constellations = norm(Constellations);
H = reshape(H,MIMO_in,P.nMIMO);
y = reshape(input_virtual_antennas,len_inp,MIMO_in);
G = pinv(H);
G = pinv(H.'*H)*H.';
for i = 1:len_inp
    y1 = y(i,:);
    sTilde = G*y1';
    Sravn = zeros(length(Constellations),1);
    sHat = zeros(length(sTilde),1);
    sHat_dist = zeros(length(sTilde),1);
    for ii=1:length(sTilde)
        for j=1:length(Constellations)
            Sravn(j) = abs(sTilde(ii)-Constellations(j));
        end;
        [sHat_dist(ii) sHat(ii)] = min(Sravn);
    end;
    %sHat = argmin ot rasstoyaniya % daet chislo v const ot 0 - 15
    %sHat = sHat - 1;
    chan_out_1(i) = Constellations(sHat(1));
    chan_out_2(i) = Constellations(sHat(2));
end;
stream = [chan_out_1 ; chan_out_2];
output_stream = reshape(stream,1,[]);

end

