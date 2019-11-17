function [nirs_data,datajoint_configuration,MarkList]= Nirsdata_joint(dataAll)
nirs_data.nch = dataAll(1).nch;
nirs_data.fs = dataAll(1).fs;
nirs_data.wavelength = dataAll(1).wavelength;
nirs_data.distance = dataAll(1).distance;
nirs_data.DPF = dataAll(1).DPF;
N = length(dataAll);
nirs_data.oxyData = [];
nirs_data.dxyData = [];
MarkList = struct;
for i = 1:N
    nirs_data.oxyData = [nirs_data.oxyData;dataAll(i).oxyData];
    nirs_data.dxyData = [nirs_data.dxyData;dataAll(i).dxyData];
    if i == 1
        MarkList.MarkValue = dataAll(i).Mark.MarkValue;
        MarkList.MarkTimePoint = dataAll(i).Mark.MarkTimePoint;
    else
        MarkList.MarkValue = [MarkList.MarkValue;dataAll(i).Mark.MarkValue];
        MarkList.MarkTimePoint = [MarkList.MarkTimePoint;dataAll(i).Mark.MarkTimePoint+MarkList.MarkTimePoint(end)];
    end
    datajoint_configuration{i,1} =  dataAll(i).Name;
end
end