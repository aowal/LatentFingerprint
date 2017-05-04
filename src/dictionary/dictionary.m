
addpath('../Utils/')
for i=2:51
    ftitle=num2str(i);
    regions=6;
    I = imread(['../../Fingerprint Database/Images/' ftitle '.jpg']);
    image=I;
    DB='NIST27';
    lambda1 = 6; lambda2 = 2; dict_name = 'dict';
    blksize = 16;
    param = SetParam(DB,image,blksize);
    param.lambda1 = lambda1;
    param.lambda2 = lambda2;
    bh = param.bh;
    bw = param.bw;
    MASK = true(bh,bw);
    [A,~,DIR] = GetBlocksStrongWaves(image,param,MASK);
    DIR =  NormalizeRidgeDir( round(-DIR*180/pi-90) ) ;
    DIR(A==0)=91;
    
    
    ImageData = reshape(DIR(:,1),[bh bw]);
    
    
    [row, col]=size(ImageData);
    blockSize =10;
    regionRow=row/3;
    regionCol=col/2;
    regionsArrayRowsStart=[1,1,row/3+1,row/3+1,(2*row)/3+1,(2*row)/3+1];
    regionsArrayRowsEnd=[row/3,row/3,(2*row)/3,(2*row)/3,row,row];
    regionsArrayColsStart=[1,col/2+1,1,col/2+1,1,col/2+1];
    regionsArrayColsEnd=[col/2,col,col/2,col,col/2,col];
    
    for i=1:row
        for j=1:col
            startRow = i;
            startCol = j;
            endRow = i+blockSize;
            endCol = j+blockSize;
            if endRow<=row && endCol<=col
                matrix = ImageData(startRow:endRow,startCol:endCol);
                regionList = getRegionList(startRow,startCol,endRow,endCol,regionsArrayRowsStart,regionsArrayRowsEnd,regionsArrayColsStart,regionsArrayColsEnd);
                regionList
                for k=1:size(regionList)
                    region = regionList(k);
                    dictionaryCreate(matrix,region);
                end
            end
        end
    end
end

function [regions] = getRegionList(rowStart,colStart,rowEnd,colEnd,regionsArrayRowsStart,regionsArrayRowsEnd,regionsArrayColsStart,regionsArrayColsEnd)
%% This function takes the boundary of the patch and the region boundaries and outputs the list of regions it belongs to.
nRegions = (size(regionsArrayRowsStart));
nRegions = nRegions(2);
regions = [];
k=1;
for i =1:nRegions
    regionRowStart = regionsArrayRowsStart(i);
    regionRowEnd = regionsArrayRowsEnd(i);
    regionColStart = regionsArrayColsStart(i);
    regionColEnd = regionsArrayColsEnd(i);
    
    x(1) = rowStart;
    y(1) = colStart;
    x(2) = rowStart;
    y(2) = colEnd;
    x(3) = rowEnd;
    y(3) = colStart;
    x(4) = rowEnd;
    y(4) = colEnd;
    
    belongs = 0;
    for j=1:4
        if x(j)>=regionRowStart && x(j)<=regionRowEnd && y(j)>=regionColStart && y(j)<= regionColEnd
            belongs =1;
            break;
        end
    end
     
    if belongs == 1
        regions(k) = i;
        k =k+1;
    end
end
end

