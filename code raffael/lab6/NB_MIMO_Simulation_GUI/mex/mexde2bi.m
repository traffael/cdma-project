% MY_DE2BI Convert decimal numbers to binary numbers
% B = MY_DE2BI(D) converts a nonnegative integer decimal vector D to a
% binary matrix B. Each row of the binary matrix B corresponds to one
% element of D. The default orientation of the binary output is
% Right-MSB, i.e., the first element in a row of B represents the least
% significant bit. If D is a matrix rather than a row or column vector, the
% matrix is first converted to a vector (column-wise).
%
% In addition to the vector input, two optional parameters can be given:
%
% B = MY_DE2BI(D,MSBFLAG) uses MSBFLAG to determine the output
% orientation. MSBFLAG has two possible values, 'right-msb' and
% 'left-msb'. Giving a 'right-msb' MSBFLAG does not change the
% function's default behavior. Giving a 'left-msb' MSBFLAG flips the
% output orientation to display the MSB to the left.
%
% B = MY_DE2BI(D,MSBFLAG,N) uses N to define how many digits (columns)
% are output. The number of digits must be large enough to represent the
% largest number in D.


function b = mexde2bi(d, n)

    if ~isfloat(d)
        d = double(d);
        % Promote input to double, so that we can handle other types (uint8, etc)
        % This is necessary since log2 can only handle doubles, and other
        % functions used below, such as kron, cannot mix double and uint
        % inputs
    end    
   

    
	% Check number of arguments and assign default values as necessary	
%     nmax = max(1, floor(1+log2(double(max(d)))));   
%     
% 	if (nargin < 3)
% 		n = nmax;       
% 	elseif (nmax > n)
% 		error('my_de2bi:insufficientNbits', ...
% 			'Specified number of bits is is too small to represent some of the input numbers');
% 	end			
					
	if (nargin < 3)	
		msbflag = 'right-msb';
	end
	


	% Make sure input is nonnegative decimal
	if any((d < 0) | (d ~= fix(d)) | isnan(d) | isinf(d))
    	error('Input must contain only finite real positive integers.');
    end

    % Convert d to column if necessary
	d = d(:);
    
    switch lower(msbflag)
		case 'left-msb'
			shifts=-(n-1:-1:0);
		case 'right-msb'
			shifts=-(0:n-1);
		otherwise
			error('my_de2bi:wrongMSBflag', 'Unsupported value for MSBFLAG');
    end
    
    
    b=bitand(bitshift(repmat(d,size(shifts)),repmat(shifts,size(d))),1);
    

    
