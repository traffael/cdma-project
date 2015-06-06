function output_stream = conv_enc(input_stream,P)
    poly = [557 663 711];
    convEnc = comm.ConvolutionalEncoder('TrellisStructure', poly2trellis(P.codeLength+1,poly));
    output_stream = step(convEnc, input_stream'); 
end