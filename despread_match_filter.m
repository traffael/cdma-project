function output_stream = despread_match_filter(input_stream, Long_code, P)
    N = size(Long_code,2); %(P.NumberOfBits + P.codeLength)/P.nMIMO;
    stream_reshaped = reshape(input_stream,length(input_stream)/N,[]);
    output_stream = zeros(size(stream_reshaped));
    
    long_code_symbols = 1-2*Long_code;
    
    for j = 1:N
        output_stream(:,j) = long_code_symbols(:,j).*stream_reshaped(:,j);
    end;
    output_stream = reshape(output_stream,length(input_stream),1);
end