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
        Count1=size(currRegionMatrix,1); Count2=size(latentPatch,1); n=0;
        T=15;  %Threshold for distance
        TT=14; %Threshold for theta
        for i=1:Count1
            Found=0; j=1;
            while (Found==0) && (j<=Count2)
                dx=(currRegionMatrix(i,1)-latentPatch(j,1));
                dy=(currRegionMatrix(i,2)-latentPatch(j,2));
                d=sqrt(dx^2+dy^2);    %Euclidean Distance between T1(i) & T2(i)
                if d<T
                    DTheta=abs(currRegionMatrix(i,3)-latentPatch(j,3))*180/pi;
                    DTheta=min(DTheta,360-DTheta);
                    if DTheta<TT
                        n=n+1;        %Increase Score
                        Found=1;
                    end
                end
                j=j+1;
            end
        end
        
        currSimScore=sqrt(n^2/(Count1*Count2));       %Similarity Index
    
        if(sim<currSimScore)
            sim=currSimScore;
            result = currRegionMatrix;
        end
 
    end
    
end