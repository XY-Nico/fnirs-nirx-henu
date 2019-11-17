function result_MIC = nirs_MIC(FileNameO,FileNameD,Path)
result_MIC = struct;
if length(FileNameO)==length(FileNameD)
    for i = 1:length(FileNameO)
        result_MIC(i).oxy = textread([Path,FileNameO(i).name]);
        result_MIC(i).dxy = textread([Path,FileNameD(i).name]);
    end
end
end