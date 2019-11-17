function Result = Struct_mean_nirsdata(C_Result)
    Nsubj = length(C_Result);
    R = struct;
    for i = 1: Nsubj
        R.oxy(:,:,i) = C_Result(i).oxy;
        R.dxy(:,:,i) = C_Result(i).dxy;
    end
    Result.AVG_oxy = mean(R.oxy,3);
    Result.AVG_dxy = mean(R.dxy,3);
end