function [ output_stream ] = orthogonalMIMOModulation( input_stream, user )
%ORTHOGONALMODULATION Summary of this function goes here
%   Detailed explanation goes here
    hadamardMatrix = hadamard(64);
    
    input_stream=2*input_stream-1; %map 0->-1, 1->1
%     tail=mod(length(input_stream),64);
%     if(tail)
%         input_stream=[input_stream,zeros(1,tail)];
%     end
    
    output_stream = (input_stream.') * hadamardMatrix(user,:);
    output_stream = output_stream(:)>0;
    

end

