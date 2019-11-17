function Output_nirs_data = datasplit_Rest(nirs_data,SubjMark,Mark,ForwardReservedTime,BackReservedTime)
Output_nirs_data = struct;
for NR = 1:length(Mark)
    SiteEnd(NR) = find(SubjMark.MarkValue == Mark(NR));
    TimePointEnd(NR,:) = table2array(SubjMark(SiteEnd(NR),2));
end
for i = 1:length(Mark)
    Output_nirs_data(i).Mark    = table();
    Output_nirs_data(i).oxyData = nirs_data.oxyData(TimePointEnd(i)-round(ForwardReservedTime):TimePointEnd(i)+round(BackReservedTime),:);
    Output_nirs_data(i).dxyData = nirs_data.dxyData(TimePointEnd(i)-round(ForwardReservedTime):TimePointEnd(i)+round(BackReservedTime),:);
    Output_nirs_data(i).nch = nirs_data.nch;
    Output_nirs_data(i).fs = nirs_data.fs;
    Output_nirs_data(i).wavelength = nirs_data.wavelength;
    Output_nirs_data(i).distance = nirs_data.distance;
    Output_nirs_data(i).DPF = nirs_data.DPF;
    Output_nirs_data(i).N = i;
end
end