function nirs_data = Band_Filter(nirs_data)
hp = 0.01;
lp = 0.1;
band = [hp lp];
twid = 0.15;
fs = nirs_data.fs;
nyquist = fs/2;
filtO = round(2*(fs/band(1))); %% order
freqs = [0 (1-twid)*band(1) band(1) band(2) (1+twid)*band(2) nyquist ]/nyquist;
ires = [ 0 0 1 1 0 0 ];
fweights = firls(filtO,freqs,ires);
Nchannel = size(nirs_data.oxyData);Nchannel = Nchannel(2);
for i = 1:Nchannel
    oxyData(:,i) = filtfilt(fweights,1,nirs_data.oxyData(:,i));
    dxyData(:,i) = filtfilt(fweights,1,nirs_data.dxyData(:,i));
end
nirs_data.oxyData = oxyData;
nirs_data.dxyData = dxyData;
nirs_data.band_filter = 'had filtered';
end