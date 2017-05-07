% TRANSFORMED MINUTIAE MATCHING SCORE
%
% Usage:  [ si ] = score( T1, T2 );
%
% Argument:   T1 -  First  Transformed Minutiae 
%             T2 -  Second Transformed Minutiae
%               
% Returns:    sm - Similarity Measure
%
% May 2017

function [sim,result] = GetMostSimilarMatrix(dictMatrix, latentPatch)

    [N,M] = size(dictMatrix);
    size(dictMatrix);
    sim  = 0;
    result = [];
    
    for idx=1:N
        currRegionMatrix = dictMatrix(idx); 
        currRegionMatrix = cell2mat(currRegionMatrix);
%         currSimScore = sum(sum(pdist2(currRegionMatrix,latentPatch,'jaccard')))
%         currSimScore = 1.0000 - currSimScore
        currSimScore = numel(find(currRegionMatrix==latentPatch))/numel(currRegionMatrix);
        if(sim<currSimScore)
            sim=currSimScore;
            result = currRegionMatrix;
        end
 
    end
    
end