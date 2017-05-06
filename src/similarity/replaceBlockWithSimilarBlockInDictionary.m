function[result,similarityScores] = ReplaceBlockWithSimilarBlockInDictionary(matrix)
%% Function to Replace the Block With Similar Block
addpath("../dictionary/")
[rows,cols] = size(matrix);
similarityScores = zeros(rows/10,cols/10);
blockSize =10;
nRegions =6;
validRegions=getNextValidRegions(0,nRegions);
result = matrix;
dict = zeros(nRegions);
for region=1:nRegions
    dict(region) = ReadDictionary(region);
end
i =1;
while i<=rows
    j=1;
    while j<=cols
        startRow = i;
        startCol =j;
        endRow = startRow+blockSize-1;
        endCol = startCol+blockSize-1;
        patch = matrix(startRow:endRow,startCol:endCol);
        [res,maxScore,region] = getSimilarForPatch(patch,validRegions,dict,nRegions);
        result(startRow:endRow,startCol:endCol) = res;
        validRegions = getNextValidRegions(region,nRegions);
        similarityScores(startRow/10+1,startCol/10+1)=maxScore;
        j = j+blockSize;
    end
    i = i+ blockSize;
end

end

function [result,score,region] = getSimilarForPatch(patch,validRegions,dict,nRegions)
% Patch 10 X 10 matrix. It basically calls the getMostSimilarMatrix 
    score =0;
    result = [];
    region =0;
    for curRegion =1:nRegions
        if validRegions(curRegion) == 1
            %% Check for this region
            [sim,res] = GetMostSimilarMatrix(patch,dict(curRegion));
            if sim>score
                score =sim;
                result = res;
                region = curRegion;
            end
        end
    end
end

function [validRegions] = getNextValidRegions(currentRegion,numberOfRegions)
    validRegions = ones(numberOfRegions);  
    if currentRegion ~= 0
       % Assuming Number of cols will be 2
       validRegions = 2*validRegions;
       row = ceil(currentRegion/2);
       col = mod(currentRegion,2)+1;
       
       %% Trying out valid cases 
       rowChanges = [-1,-1,-1,0,0,0,1,1,1];
       colChanges = [0,-1,1,0,-1,1,0,-1,1];
       for i=1:9
           nextRow = row -rowChanges(i);
           nextCol = col - colChanges(i);
           if (nextRow*2)<=numberOfRegions && nextRow>0 && nextCol>0 && nextCol<=2
               nextRegion = (nextRow-1)*2+nextCol;
               validRegions(nextRegion) = 1;
           end
       end
       
       for i=1:numberOfRegions
           if validRegions(i) ==2
               validRegions(i)=0;
           end
       end
       
    end
end