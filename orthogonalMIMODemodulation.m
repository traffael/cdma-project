function [ output_stream ] = orthogonalMIMODemodulation( input_stream, user )
%ORTHOGONALMODULATION Summary of this function goes here
%   Detailed explanation goes here
    hadamardMatrix = hadamard(64);
    input_stream=2*input_stream-1;

    tail=mod(length(input_stream),64); %check size and add a tail if necessary
    if(tail)
        input_stream=[input_stream,zeros(1,tail)];
    end
    
    input_stream = reshape(input_stream,64,[]).'; %reshape to perform matrix multiplication
    output_stream = input_stream * hadamardMatrix(:,user); 
    output_stream = output_stream(:)>0;
end

