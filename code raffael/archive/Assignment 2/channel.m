function h = channel(RX,NumberOfSymbols,NumberOfCarriers,CoherenceTime,CoherenceBandwidth)

smoothfactor = 4;

toverlap = max(100,smoothfactor*2*CoherenceTime);

if NumberOfCarriers > 1
    foverlap = max(100,smoothfactor*2*CoherenceBandwidth);     
else
    foverlap = 0;
end

% generate white noise grid
whitegrid = 1/sqrt(2) * (randn(NumberOfCarriers+2*foverlap,NumberOfSymbols+2*toverlap,RX) + 1i * randn(NumberOfCarriers+2*foverlap,NumberOfSymbols+2*toverlap,RX));


if NumberOfCarriers > 1
    % 2D filtering
    F = zeros(8*CoherenceBandwidth+1,8*CoherenceTime+1);
    F(4*CoherenceBandwidth:4*CoherenceBandwidth+2,4*CoherenceTime:4*CoherenceTime+2) = floor(numel(F)/9);
    H = fsamp2(F);
else
    F = zeros(1,8*CoherenceTime+1);
    F(1,4*CoherenceTime:4*CoherenceTime+2) = floor(numel(F)/3);
    H = fsamp2(F);    
end

dims                = size(whitegrid);
filteredgrid        = zeros(dims);
filteredgrid_norm   = zeros(dims);

for i = 1:RX
    filteredgrid(:,:,i)         = filter2(H,whitegrid(:,:,i));
    filteredgrid_norm(:,:,i)    = filteredgrid(:,:,i)/sqrt(var(filteredgrid(:)));
end

% normalize data
h = filteredgrid_norm(foverlap+1:end-foverlap,toverlap+1:end-toverlap,:);