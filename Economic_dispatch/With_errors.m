clc; clear;

% Given cost coefficients
a = [500 400 200];
b = [5.3 5.5 5.8];
c = [0.004 0.006 0.009];

% Generator limits
Pmin = [200 150 100];
Pmax = [450 350 225];

Pd = 975; % Total demand
lambda = 6.0; % Initial guess
tol = 0.0001;
dP = 1;
    
while abs(dP) > tol
% Calculate unconstrained power for each generator
P1 = (lambda - b(1)) / (2 * c(1));
P2 = (lambda - b(2)) / (2 * c(2));
P3 = (lambda - b(3)) / (2 * c(3));
% Apply generator limits
P1 = min(max(P1, Pmin(1)), Pmax(1));
P2 = min(max(P2, Pmin(2)), Pmax(2));
P3 = min(max(P3, Pmin(3)), Pmax(3));
% Calculate total generation and mismatch
Pg = P1 + P2 + P3;
dP = Pd - Pg;
% Update lambda by gradient method
dLam = dP / (1/(2*c(1)) + 1/(2*c(2)) + 1/(2*c(3)));
lambda = lambda + dLam;
end

% Display results
fprintf('\nEconomic Dispatch Results With Limits\n');
fprintf('P1 = %.3f MW\n', P1);
fprintf('P2 = %.3f MW\n', P2);
fprintf('P3 = %.3f MW\n', P3);
fprintf('Total Generation = %.3f MW\n', Pg);
fprintf('Lambda = %.4f\n', lambda);

% Calculate total cost
C1 = a(1) + b(1)*P1 + c(1)*P1^2;
C2 = a(2) + b(2)*P2 + c(2)*P2^2;
C3 = a(3) + b(3)*P3 + c(3)*P3^2;
TotalCost = C1 + C2 + C3;
fprintf('Total Cost = %.3f Rs/hr\n', TotalCost);