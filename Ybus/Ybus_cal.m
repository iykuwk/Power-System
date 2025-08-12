clc;
clear;

% Input Data
lineData = [
    1 2 0.01 0.15;
    1 3 0.02 0.25;
    1 4 0.03 0.35;
    2 3 0.03 0.35;
    3 4 0.01 0.15;
    4 5 0.04 0.50
];

n = 5; % no. of busses
nline = size(lineData, 1);
Ybus = zeros(n, n); % initializing Y-Bus as zeros

for k = 1:nline
    from = lineData(k,1);
    to = lineData(k,2);
    R = lineData(k,3);
    X = lineData(k,4);

    Z = R + 1i*X; 
    Y = 1 / Z;
    Ybus(from,to) = Ybus(from,to) - Y;
    Ybus(to, from) = Ybus(to, from) - Y;
end

disp(Ybus);