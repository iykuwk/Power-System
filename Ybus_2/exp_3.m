clc;
clear;
data = [1, 2, 0.01, 0.15
        1, 3, 0.02, 0.25
        1, 4, 0.03, 0.35
        2, 3, 0.03, 0.35
        3, 4, 0.01, 0.15
        4, 5, 0.04, 0.5];
c = max(max(data(:,1:2)));
z = data(:,3) + 1i*data(:,4);
y = 1 ./ z;
from = data(:,1);
to = data(:,2);
y_prim = diag(y);
A=zeros(length(from), c);
for i= 1:length(from)
    A(i,from(i))=1;
    A(i,to(i))=-1;
end
ybus= A' * y_prim*A;
disp(ybus)