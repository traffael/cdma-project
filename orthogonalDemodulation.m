function [ output_stream ] = orthogonalDemodulation( input_stream )
%ORTHOGONALMODULATION Summary of this function goes here
%   Detailed explanation goes here
    hadamardMatrix = -hadamard(64);
    
    tail=mod(length(input_stream),6);
    if(tail)
        input_stream=[input_stream,zeros(1,tail)];
    end
    
    input_stream = reshape(input_stream,64,[]).';
    indexes = input_stream * hadamardMatrix;
    [dummy,indexes] = max(indexes,[],2);
    
    output_stream = dec2bin(indexes,6)';
    output_stream = output_stream(:);
end

