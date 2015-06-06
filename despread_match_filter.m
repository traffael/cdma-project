function output_stream = despread_match_filter(input_stream, Long_code)
    stream_reshaped = reshape(input_stream,256*3,length(input_stream)/256/3);
    output_stream = zeros(size(stream_reshaped));
    for j = 1:length(input_stream)/256/3
        output_stream(:,j) = xor(Long_code(:,j),stream_reshaped(:,j));
    end;
    output_stream = reshape(output_stream,length(input_stream),1);
end