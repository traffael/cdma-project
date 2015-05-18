function P_conv = conv_enc(P)
    K = 9;
    poly = [557 663 711];
    convEnc = comm.ConvolutionalEncoder('TrellisStructure', poly2trellis(K,poly));
    P_conv = step(convEnc, P'); 
    
end