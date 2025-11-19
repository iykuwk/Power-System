clc;
clear;

line_data = [...
    1 2 0.01 0.15;
    1 3 0.02 0.25;
    1 4 0.03 0.35;
    2 3 0.03 0.35;
    3 4 0.01 0.15;
    4 5 0.04 0.50];

m = size(line_data,1);
cols = line_data(:,1:2);
rowmax = max(cols,[],2);
nbus = max(rowmax);

Z = line_data(:,3) + 1i*line_data(:,4);
Y = 1 ./ Z;
Yp = diag(Y);

A = zeros(m, nbus);
for k = 1:m
    f = line_data(k,1);
    t = line_data(k,2);
    A(k,f) = 1;
    A(k,t) = -1;
end

Ybus = A.'*Yp*A;
disp('Y-Bus Matrix via Singular Transformation Method:');
disp(Ybus)