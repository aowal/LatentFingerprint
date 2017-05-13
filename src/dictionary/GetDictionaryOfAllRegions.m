function [dict] =  GetDictionaryOfAllRegions()
    dict = {6};
    nRegions = 6;
    for region=1:nRegions
        curDict = ReadDictionary(region);
        dict{region} = curDict;
    end
end