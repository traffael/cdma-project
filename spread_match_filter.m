function output_stream = spread_match_filter(input_stream,Long_code, P)
    %N = size(Long_code,2); %(P.NumberOfBits + P.codeLength)/P.nMIMO;
    %stream_reshaped = reshape(input_stream,length(input_stream)/N,[]);
    %output_stream = zeros(size(stream_reshaped));
  %  for j = 1:N  %TODO: why a for loop?
  %      output_stream(:,j) = xor(Long_code(:,j),stream_reshaped(:,j));
  %  end;
 output_stream = xor(Long_code,input_stream.');
end