clc;clear
fList = dir('10*');
Path = [cd,'\'];
NSubj = length(fList);
mkdir(Path,'\M2R');

for subj = 1:NSubj
    load([Path,fList(subj).name,'\','Data.mat']);
    [N0(1),~,~]= Nirsdata_joint(Nback0_FC(1:2));
    [N0(2),~,~]= Nirsdata_joint(Nback0_FC(3:4));
    C1 = Nirs_superposition_unequal(N0,600);
    C2 = Nirs_superposition_unequal(Nback1_FC,600);
    C3 = Nirs_superposition_unequal(Nback1_FC,600);
    for i = 1:3
        Key = ['R',num2str(i),'O=C',num2str(i),'.oxyData;'];eval(Key);
        Key = ['R',num2str(i),'D=C',num2str(i),'.dxyData;'];eval(Key);
        Key = strcat('xlswrite(',"[Path,'M2R\",fList(subj).name,'R',num2str(i),"O.xls'],",'R',num2str(i),'O',')');eval(Key);
        Key = strcat('xlswrite(',"[Path,'M2R\",fList(subj).name,'R',num2str(i),"D.xls'],",'R',num2str(i),'D',')');eval(Key);
    end
end