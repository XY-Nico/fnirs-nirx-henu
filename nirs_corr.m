function  Result= nirs_corr(nirs_data)
Result = struct;
Result.oxy = corr(nirs_data.oxyData);
Result.dxy = corr(nirs_data.oxyData);
end
