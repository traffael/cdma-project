load('y.mat');
load('b.mat');

Nsymbols=length(b);
nInSymbols=2;
nOutSymbols=9;
bSymbols=0:1;
ySymbols=-4:4;

probBY = zeros(nInSymbols,nOutSymbols); %p_(b,y)
probB = zeros(nInSymbols,nOutSymbols); %p_b
probY = zeros(nInSymbols,nOutSymbols); %p_y

for i=1:nInSymbols
    for j=1:nOutSymbols
        probB(i,j)=sum(b==bSymbols(i))/Nsymbols;
        probY(i,j)=sum(y==ySymbols(j))/Nsymbols;
        probBY(i,j)=sum((b==bSymbols(i)).*(y==ySymbols(j)))/Nsymbols;
    end 
end

%formula from page 6 of the course.
mutualInformation=sum(sum(probBY.*log(probBY./(probB.*probY))))


