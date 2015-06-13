function output_stream = conv_enc2(input_stream,P)
    poly = [753 561];
    convEnc = comm.ConvolutionalEncoder('TrellisStructure', poly2trellis(P.codeLength+1,poly)); %terminated, put outsidew for
    output_stream = step(convEnc, input_stream); 
end