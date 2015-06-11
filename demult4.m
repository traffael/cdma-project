function output_stream = demult4(input_stream)
    stream_reshaped=reshape(input_stream,4,[]);
    output_stream = [0.25 0.25 0.25 0.25]*stream_reshaped;
end