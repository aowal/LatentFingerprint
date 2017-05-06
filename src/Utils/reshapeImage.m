function [out] = reshapeImage(A)
[m,n] = size(A);
row = m + mod(10-mod(m,10),10);
col = n + mod(10-mod(n,10),10);
out = zeros(row,col);

for i=1:m
    for j=1:n
        out(i,j) = A(i,j);
    end
end
end