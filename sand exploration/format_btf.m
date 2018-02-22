N = size(VarName8,1);
for i = N:-1:1
    if isnan(VarName8(i))
        VarName8(i) = [];
    end
end
btf = VarName8;
save('btf2.mat','btf')