function [ output_stream ] = orthogonalDemodulation( input_stream )
%ORTHOGONALMODULATION Summary of this function goes here
%   Detailed explanation goes here
    hadamardMatrix = hadamard(64);
    input_stream=1-2*input_stream;

    tail=mod(length(input_stream),64); %check size and add a tail if necessary
    if(tail)
        input_stream=[input_stream,zeros(1,tail)];
    end
    
    input_stream = reshape(input_stream,64,[]).'; %reshape to perform matrix multiplication
    indexes = input_stream * hadamardMatrix; 
    [dummy,indexes] = max(indexes,[],2); 
    
    indexes=indexes-1;
    
    output_stream = fliplr(dec2bin(indexes,6))';
    output_stream = str2num(output_stream(:));
end

