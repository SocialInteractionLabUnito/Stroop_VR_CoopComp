function y = sterr(x)
s = std(x, 'omitnan');
n = length(x);
se = s/sqrt(n);
y = se;
return