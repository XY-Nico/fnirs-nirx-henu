function Output_nirs_data = Event_split(nirs_data,SubjMark,MarkStart,TrueMark,ErrorMark,EventForward,EventBack,label)
Output_nirs_data = struct;
SiteMarkStart = find(SubjMark.MarkValue == MarkStart);
SiteMarkEnd = SiteMarkStart+1;
TimePointStart = SubjMark.MarkTimePoint(SiteMarkStart)-round(EventForward);
TimePointEnd = SubjMark.MarkTimePoint(SiteMarkStart)+round(EventBack);
for i = 1:length(SiteMarkStart)
    Output_nirs_data(i).oxyData = nirs_data.oxyData(TimePointStart:TimePointEnd,:);
    Output_nirs_data(i).dxyData = nirs_data.dxyData(TimePointStart:TimePointEnd,:);
    Output_nirs_data(i).nch = nirs_data.nch;
    Output_nirs_data(i).fs = nirs_data.fs;
    Output_nirs_data(i).wavelength = nirs_data.wavelength;
    Output_nirs_data(i).distance = nirs_data.distance;
    Output_nirs_data(i).DPF = nirs_data.DPF;
    Output_nirs_data(i).Name = [label,'S',num2str(i)];
    if SubjMark.MarkValue(SiteMarkEnd(i)) == TrueMark
        Output_nirs_data(i).ACC = 1;
    elseif SubjMark.MarkValue(SiteMarkEnd(i)) == ErrorMark
        Output_nirs_data(i).ACC = 0;
    else
        Output_nirs_data(i).ACC = 'NAN';
    end
end
end