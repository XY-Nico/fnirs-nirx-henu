function  Result= nirs_coh(nirs_data)
Result = struct;
for channell = 1:size(nirs_data.oxyData,2)
    for channel2 = 1:size(nirs_data.oxyData,2)
        [Result.oxy(:,channell,channel2),Result.oxyFreq] = mscohere(nirs_data.oxyData(:,channell),nirs_data.oxyData(:,channel2),[],[],[],nirs_data.fs);
        [Result.dxy(:,channell,channel2),Result.dxyFreq] = mscohere(nirs_data.dxyData(:,channell),nirs_data.dxyData(:,channel2),[],[],[],nirs_data.fs);
    end
end
Result.oxy = squeeze(mean(Result.oxy(Result.oxyFreq > 0.01 & Result.oxyFreq < 0.1,:,:,:),1));
Result.dxy = squeeze(mean(Result.dxy(Result.dxyFreq > 0.01 & Result.dxyFreq < 0.1,:,:,:),1));
end
