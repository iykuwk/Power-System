clc;
clear;
%Input Data & Y-Bus Matrix Construction
n = input('Number of buses: ');
slack = input('Slack bus number: ');
numLines = input('Total number of transmission lines: ');
Y = zeros(n, n);
disp('Enter line data [FromBus ToBus Resistance Reactance]:');
for i = 1:numLines
    lineData = input(sprintf('Line %d data: ', i));
    fb = lineData(1);
    tb = lineData(2);
    Z = lineData(3) + 1i * lineData(4);
    Yij = -1/Z;
    Y(fb, fb) = Y(fb, fb) - Yij;
    Y(tb, tb) = Y(tb, tb) - Yij;
    Y(fb, tb) = Y(fb, tb) + Yij;
    Y(tb, fb) = Y(fb, tb);
end
disp('Y-Bus Matrix:');
disp(Y);

%Load & Voltage Input 
MVA_base = input('Enter system base in MVA: ');
S = zeros(n, 1);
V = ones(n, 1) + 0i; % flat voltage
disp('Enter slack bus voltage magnitude and angle below');
Vm_slack = input('Magnitude: ');
Va_slack = input('Angle (degrees): ');
V(slack) = Vm_slack * exp(1i * deg2rad(Va_slack));
disp('Enter load data (P & Q in MW/MVAR) for non-slack buses:');
non_slack_buses = setdiff(1:n, slack);
for i = non_slack_buses
    loadData = input(sprintf('Bus %d load data [P Q] in MVA: ', i));
    S(i) = (loadData(1) + 1i * loadData(2)) / MVA_base;
end

%Gauss-Seidel Iteration
tol = input('Enter convergence tolerance : ');
maxIter = input('Enter maximum number of iterations: ');
for iter = 1:maxIter
    V_prev = V;
    for i = non_slack_buses
        sumYV = Y(i, :) * V - Y(i, i) * V(i);
        V(i) = (conj(S(i)) / conj(V(i)) - sumYV) / Y(i, i);
    end
    if max(abs(V - V_prev)) < tol
        fprintf('Solution converged in %d iterations.\n', iter);
        break;
    end
end

%Final Results
disp('Final Bus Voltages:');
for i = 1:n
    fprintf('V%d = %.4f + j%.4f\n', ...
        i, real(V(i)), imag(V(i)));
end