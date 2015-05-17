function P_conv = conv_enc(P)
    K = 9;
    poly = [557 663 711];
    convEnc = comm.ConvolutionalEncoder('TrellisStructure', poly2trellis(K,poly));
    c = step(convEnc, P'); 
    P_conv = 1 - 2*c;
end