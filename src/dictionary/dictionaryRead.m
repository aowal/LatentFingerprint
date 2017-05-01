function [result] = dictionaryRead(region)
%% Returns the list of matrix in the region file
delim = ";";
fileName = "../../FingerPrintDatabase/region"+num2str(region);
fid = fopen(fileName,'r');
fileText = fileread(fid);
fclose(fid);
fileTextList = strsplit(fileText,delim);
result = [];
for i=1:size(fileTextList)
    A = fileTextList(i);
    B = strrep(A,'\n',' ');
    C = char(strsplit(B));
    D = reshape(str2int(C), 2, [])';
    result(i) = D;
end
end