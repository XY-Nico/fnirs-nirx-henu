function Output_nirs_data = datasplit_Experiment_Repaird(nirs_data,SubjMark,StartMark,StartReservedTime,EndReservedTime,label)
SiteStart = find(SubjMark.MarkValue == StartMark);
SiteEnd = SiteStart+1;
TimePointStart = SubjMark.MarkTimePoint(SiteStart(1))-round(StartReservedTime);
TimePointEnd   = SubjMark.MarkTimePoint(SiteEnd(end))+round(EndReservedTime);
Mark = SubjMark(SiteStart(1):SiteEnd(end),:);
Output_nirs_data = struct;
Mark.MarkTimePoint = Mark.MarkTimePoint-Mark.MarkTimePoint(1)+round(StartReservedTime);
Output_nirs_data.Mark = Mark;
Output_nirs_data.oxyData = nirs_data.oxyData(TimePointStart:TimePointEnd,:);
Output_nirs_data.dxyData = nirs_data.dxyData(TimePointStart:TimePointEnd,:);
Output_nirs_data.nch = nirs_data.nch;
Output_nirs_data.fs = nirs_data.fs;
Output_nirs_data.wavelength = nirs_data.wavelength;
Output_nirs_data.distance = nirs_data.distance;
Output_nirs_data.DPF = nirs_data.DPF;
Output_nirs_data.Name = [label];
end