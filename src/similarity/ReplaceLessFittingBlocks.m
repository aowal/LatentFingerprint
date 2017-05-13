%% Function to Replace the Less Similar Blocks

function[result] = ReplaceLessFittingBlocks(matrix)
    
    addpath('../dictionary/');
    result = matrix;
    
    [row,col] = size(matrix);
    nRegions =6;
    
    dict = GetDictionaryOfAllRegions();
    
    for i =1:row
        for j=1:col
            startRow = i+4;
            startCol = j+4;
            endRow = startRow+9;
            endCol = startCol+9;
       
            
            if(endRow<=row && endCol<=col)
                mat = matrix(startRow:endRow,startCol:endCol);
                currMaxScore =0;
                replaceablePatch = [];
                for k =1:nRegions
                    [currScore,currMatrix] = GetMostSimilarMatrix(dict{k},mat);
                
                    if currScore>currMaxScore
                        currMaxScore = currScore;
                        replaceablePatch = currMatrix;
                    end

                end
                result(startRow:endRow,startCol:endCol) = cleanPatch(matrix,replaceablePatch,startRow,startCol);
                
            end
        end
    end
    
end


function [replaceablePatch] = cleanPatch(orig,replaceablePatch,startRow,startCol)
    for i=1:10
        for j=1:10
            if orig(startRow+i-1,startCol+j-1) == 91
                replaceablePatch(i,j)=91;
            end
        end
    end
end