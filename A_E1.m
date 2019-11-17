function   Mean_Nback = A_E1(i,fList,DPF,ext_coef)
Path = [cd,'\'];
EventForward = 0.3*7.8125;
EventBack = 1*7.8125;
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
nirs_data1 = Band_Filter(nirs_data);
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
Nback0 = Event_split(nirs_data,SubjMark,10,11,12,EventForward,EventBack,'Nback0');
Nback1 = Event_split(nirs_data,SubjMark,20,21,22,EventForward,EventBack,'Nback1');
Nback2 = Event_split(nirs_data,SubjMark,30,31,32,EventForward,EventBack,'Nback2');
NbackAll = [Nback0,Nback1,Nback2];
Mean_Nback0 = Nirs_superposition(Nback0);
Mean_Nback1 = Nirs_superposition(Nback1);
Mean_Nback2 = Nirs_superposition(Nback2);
Mean_Nback = [Mean_Nback0,Mean_Nback1,Mean_Nback2];
save([Path,fList(i).name,'\','NbackAll.mat'],'NbackAll');
save([Path,fList(i).name,'\','converted_nirs.mat'],'nirs_data');
