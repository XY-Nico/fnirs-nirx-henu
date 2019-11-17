function Result = nirs_PLV(nirs_data)
Result = struct;
for channel1 = 1:size(nirs_data.oxyData,2)
    for channel2 = 1:size(nirs_data.oxyData,2)
        channel1_oxy_phase = angle(hilbert(nirs_data.oxyData(:,channel1)));
        channel2_oxy_phase = angle(hilbert(nirs_data.oxyData(:,channel2)));
        channel1_dxy_phase = angle(hilbert(nirs_data.dxyData(:,channel1)));
        channel2_dxy_phase = angle(hilbert(nirs_data.dxyData(:,channel2)));
        rp_oxy = channel1_oxy_phase - channel2_oxy_phase;
        rp_dxy = channel1_dxy_phase - channel2_dxy_phase;
        Result.oxy(channel1,channel2) = abs(sum(exp(1i*rp_oxy))/length(rp_oxy));
        Result.dxy(channel1,channel2) = abs(sum(exp(1i*rp_dxy))/length(rp_dxy));
    end
end
end