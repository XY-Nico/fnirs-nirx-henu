function output = Nirs_superposition(nirs_data)

output = struct;
for i = 1:length(nirs_data)
    oxyData(:,:,i) = nirs_data(i).oxyData;
    dxyData(:,:,i) = nirs_data(i).dxyData;
end
output.oxyData = squeeze(mean(oxyData,3));
output.dxyData = squeeze(mean(dxyData,3));
output.nch = nirs_data.nch;
output.fs = nirs_data.fs;
output.wavelength = nirs_data.wavelength;
output.distance = nirs_data.distance;
output.DPF = nirs_data.DPF;
output.name = nirs_data.Name;
end