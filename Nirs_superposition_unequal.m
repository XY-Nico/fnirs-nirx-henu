function  output = Nirs_superposition_unequal(nirs_data,Length)
output = struct;

for i = 1:length(nirs_data)
    oxyData(:,:,i) = nirs_data(i).oxyData(1:Length,:);
    dxyData(:,:,i) = nirs_data(i).dxyData(1:Length,:);
end
output.oxyData = squeeze(mean(oxyData,3));
output.dxyData = squeeze(mean(dxyData,3));
output.nch = nirs_data.nch;
output.fs = nirs_data.fs;
output.wavelength = nirs_data.wavelength;
output.distance = nirs_data.distance;
output.DPF = nirs_data.DPF;
end