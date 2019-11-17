function y = cell2num(test)
for n=1:length(test)
    x{n}=str2num(test{n});
end
for m=1:length(x)
    y(m)=x{m}(1);
end
y = y';
end