function [ output_stream ] = orthogonalModulation( input_stream )
%ORTHOGONALMODULATION Summary of this function goes here
%   Detailed explanation goes here
    hadamardMatrix = (hadamard(64)<0);
    
    tail=mod(length(input_stream),6);
    if(tail)
        input_stream=[input_stream,zeros(1,tail)];
    end
    
    input_stream = reshape(input_stream,6,[]).';
    indexes = input_stream * [1; 2; 4; 8; 16; 32]+1;
    
    output_stream = hadamardMatrix(:,indexes);
    output_stream = output_stream(:);

end

