function [result] = dictionaryRead(region)
%% Returns the list of matrix in the region file
% delim = ";";
fileName = "../../Fingerprint Database/RegionDB/region"+num2str(region);
matrix = dlmread(fileName);
rows = (size(matrix));
nRows = rows(1)/10;
N = 10*ones(1,nRows);
result = mat2cell(matrix,N,10);
end