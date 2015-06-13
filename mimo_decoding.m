function [ stream ] = mimo_decoding( input_virtual_antennas, H ,P )

len_inp = length(input_virtual_antennas);
Constellations = [1+1i ,-1-1i];

chan_out_1 = zeros(1,len_inp);
chan_out_2 = zeros(1,len_inp);
for i = 1:len_inp
    y1 = input_virtual_antennas(:,i);
    sTilde1 = H\y1;
    Sravn = zeros(length(Constellations),1);
    sHat = zeros(length(sTilde1),1);
    sHat_dist = zeros(length(sTilde1),1);
    for ii=1:length(sTilde1)
        for j=1:length(Constellations)
            Sravn(j) = abs(sTilde1(ii)-Constellations(j));
        end;
        [sHat_dist(ii), sHat(ii)] = min(Sravn);
    end;

    chan_out_1(i) = Constellations(sHat(1));
    chan_out_2(i) = Constellations(sHat(2));
end;
stream = ([chan_out_1, chan_out_2]<0);

end

