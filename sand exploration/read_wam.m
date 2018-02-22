N = size(VarName1,1);
wam_jp = [VarName1 VarName2 VarName3 VarName4 VarName5 VarName6 VarName7]; 
for i = N:-1:1
    if isnan(wam_jp(i,1))
        wam_jp(i,:) = [];
    end
end
save('wam_sqaure2.mat','wam_jp')
