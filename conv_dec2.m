function P_conv = conv_dec2(P,k)
    P=1-2*P ;
    K = 9;
    speed = 1/2;
    poly = [753 561];
    convDec = comm.ViterbiDecoder('TrellisStructure', poly2trellis(K,poly)); 
    delay = convDec.TracebackDepth*log2(convDec.TrellisStructure.numInputSymbols);
    b_hat = step(convDec, [P; zeros(1/speed*delay,1)]);
    P_conv = b_hat(delay+1:delay+k);
end