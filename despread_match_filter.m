function output_stream = despread_match_filter(input_stream, Long_code, P)
    N = (P.NumberOfBits + P.codeLength)/P.nMIMO;
    stream_reshaped = reshape(input_stream,N,[])';
    output_stream = zeros(size(stream_reshaped));
    for j = 1:N
        output_stream(:,j) = xor(Long_code(:,j),stream_reshaped(:,j));
    end;
    output_stream = reshape(output_stream,length(input_stream),1);
end