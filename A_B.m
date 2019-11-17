function   [NbackAll,RestTimeEnd,RestTimeStart,betaList] = A_B1(i,fList,hb,DPF,HPF,ext_coef,LPF,flag_window,StartReservedTime,EndReservedTime,StartForwardReservedTime,StartBackReservedTime,EndForwardReservedTime,EndBackReservedTime)
%duration处设置为了根据每个刺激点做一次刺激
Path = [cd,'\'];
disp(["--------the subject's ID is ",fList(i).name,'------------']);
disp('----------------------------------------Start!----------------------------------------');
load([Path,fList(i).name,'\','NIRS_probeInfo.mat']);
T = textread([Path,fList(i).name,'\','NIRS_config.txt'],'%c');T = T';
T = strrep(T,'SamplingRate',';SamplingRate');
T = strrep(T,';..',';');
eval(T);
index=probeInfo.probes.index_c;
ni.IMGlabel={};
for j=1:length(probeInfo.probes.index_c)
    ni.IMGlabel{j,1}=strcat(num2str(index(j,1)),'-',num2str(index(j,2)));
end
save([Path,fList(i).name,'\','ch_configuration.mat'],'ni');
fname_nirs{1} = [Path,fList(i).name,'\','NIRS.wl1'];
fname_nirs{2} = [Path,fList(i).name,'\','NIRS.wl2'];
ch_config =[Path,fList(i).name,'\','ch_configuration.mat'];
wl = num2str(Wavelengths);wavelength = [str2double(wl(1:3)),str2double(wl(4:6))];
Thdr = textread([Path,fList(i).name,'\','NIRS.hdr'],'%c');Thdr = Thdr';
dist = str2double(Thdr(findstr(Thdr,'ChanDis="')+9:findstr(Thdr,'ChanDis="')+10))/10; %#ok<*FSTR>
nirs_data = data_conversion_batch(fname_nirs,'nirx',SamplingRate,dist/10,wavelength,DPF,1,length(probeInfo.probes.index_c),ext_coef,ch_config);
save([Path,fList(i).name,'\','converted_nirs_or.mat'],'nirs_data');
Eventfile= importdata([Path,fList(i).name,'\','NIRS.hdr'],'%s');
for Eventfilerow = 1:length(Eventfile)
    if strcmp(Eventfile{Eventfilerow,1},'[Markers]')
        Event_first = Eventfilerow+2;
    end
    if strcmp(Eventfile{Eventfilerow,1},'[DataStructure]')&&exist('Event_first') %#ok<*EXIST>
        Event_end = Eventfilerow-2;
    end
end
Event_number = 1;clear SubjMark;
for Eventfilerow = Event_first:Event_end
    SubjMark(Event_number,:) = regexp(Eventfile{Eventfilerow,1},'	', 'split'); %#ok<*AGROW>
    Event_number = Event_number+1;
end
MarkValue = cell2num(SubjMark(:,2));
MarkTimePoint = cell2num(SubjMark(:,3));
SubjMark = table(MarkValue,MarkTimePoint);
nirs_data = Band_Filter(nirs_data);
Nback0_FC = datasplit_Experiment(nirs_data,SubjMark,4,10,StartReservedTime,EndReservedTime,'Nback0');
Nback1_FC = datasplit_Experiment(nirs_data,SubjMark,2,20,StartReservedTime,EndReservedTime,'Nback0');
Nback2_FC = datasplit_Experiment(nirs_data,SubjMark,2,30,StartReservedTime,EndReservedTime,'Nback0');
Nback0 = datasplit_Experiment_Repaird(nirs_data,SubjMark,10,StartReservedTime,EndReservedTime,'Nback0');
Nback1 = datasplit_Experiment_Repaird(nirs_data,SubjMark,20,StartReservedTime,EndReservedTime,'Nback0');
Nback2 = datasplit_Experiment_Repaird(nirs_data,SubjMark,30,StartReservedTime,EndReservedTime,'Nback0');
RestTimeStart = datasplit_Rest(nirs_data,SubjMark,101,StartForwardReservedTime,StartBackReservedTime);
RestTimeEnd = datasplit_Rest(nirs_data,SubjMark,103,EndForwardReservedTime,EndBackReservedTime);
save([Path,fList(i).name,'\','Data.mat'],'Nback0_FC','Nback1_FC','Nback2_FC','RestTimeStart','RestTimeEnd');
NbackAll = [Nback0,Nback1,Nback2];
[nirs_data,datajoint_configuration,MarkList]= Nirsdata_joint(NbackAll);
save([Path,fList(i).name,'\','datajoint_configuration.mat'],'datajoint_configuration');
save([Path,fList(i).name,'\','MarkList.mat'],'MarkList');
save([Path,fList(i).name,'\','converted_nirs.mat'],'nirs_data');
fname_nirs = [Path,fList(i).name,'\','converted_nirs.mat'];
method_cor = 0;
dir_save = [Path,fList(i).name,'\HBO','\'];
mkdir(dir_save);
hrf_type = 2;
units = 0;
Mark = [10,20,30];
NMark = length(Mark);
for mark = 1:NMark
    names{mark} = ['M',num2str(Mark(mark))];
    onsets{mark} = MarkList.MarkTimePoint(find(MarkList.MarkValue == Mark(mark))); %#ok<*FNDSB>
    durations{mark} = MarkList.MarkTimePoint(find(MarkList.MarkValue == Mark(mark))+1)-MarkList.MarkTimePoint(find(MarkList.MarkValue == Mark(mark)));
end
specification_batch(fname_nirs,hb,HPF,LPF,method_cor,dir_save,flag_window,hrf_type,units,names,onsets,durations);
fname_SPM = [Path,fList(i).name,'\HBO\SPM_indiv_HbO.mat'];
fname_nirs = [Path,fList(i).name,'\converted_nirs'];
nirs_ES = estimation_batch(fname_SPM, fname_nirs);
disp(['Get beta values...',fList(i).name])
for nbeta = 1:NMark
    betaList(nbeta,:) = nirs_ES.nirs.beta(3*nbeta-2,:);
end
save([Path,fList(i).name,'\','betaList.mat'],'betaList');