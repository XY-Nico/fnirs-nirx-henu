function Output_nirs_data = datasplit_Experiment(nirs_data,SubjMark,Nblock,StartMark,StartReservedTime,EndReservedTime,label)
SiteStart = find(SubjMark.MarkValue == StartMark);
SiteEnd = SiteStart+1;
TimePointStart = table2array(SubjMark(SiteStart(1:length(SiteStart)/Nblock:length(SiteStart)),2));
TimePointEnd   = table2array(SubjMark(SiteEnd(length(SiteEnd)/Nblock:length(SiteEnd)/Nblock:length(SiteEnd)),2));
Mark = SubjMark(sort([SiteStart;SiteEnd]),:);
Output_nirs_data = struct;
for i = 1:Nblock
    Mark.MarkTimePoint = Mark.MarkTimePoint-Mark.MarkTimePoint((1+(length(Mark.MarkValue)/(Nblock))*(i-1)))+round(StartReservedTime);
    Output_nirs_data(i).Mark    = Mark((1+(length(Mark.MarkValue)/(Nblock))*(i-1)):((length(Mark.MarkValue)/(Nblock))*i),:);
    Output_nirs_data(i).oxyData = nirs_data.oxyData(TimePointStart(i)-round(StartReservedTime):TimePointEnd(i)+round(EndReservedTime),:);
    Output_nirs_data(i).dxyData = nirs_data.dxyData(TimePointStart(i)-round(StartReservedTime):TimePointEnd(i)+round(EndReservedTime),:);
    Output_nirs_data(i).nch = nirs_data.nch;
    Output_nirs_data(i).fs = nirs_data.fs;
    Output_nirs_data(i).wavelength = nirs_data.wavelength;
    Output_nirs_data(i).distance = nirs_data.distance;
    Output_nirs_data(i).DPF = nirs_data.DPF;
    Output_nirs_data(i).Name = [label,'S',num2str(i)];
end
end