function[score] = GetCohesiveScore(matrix)
    addpath('../dictionary/');
    count =0;
    totScore =0;
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
                for k =1:nRegions
                    
                    [currScore,~] = GetMostSimilarMatrix(dict{k},mat);
                
                    if currScore>currMaxScore
                        currMaxScore = currScore;
                    end
                end
                totScore = totScore +  currMaxScore;
                count = count +1;
            end
            
        end
    end
    
    score = totScore/count;
end
