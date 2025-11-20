clc; clear;
% Line Data: [From To R X]
line_data = [
    1 2 0.07 0.15;
    1 3 0.06 0.10;
    1 4 0.08 0.25;
    2 4 0.04 0.10;
    3 4 0.04 0.20
];
n_bus = 4;

% Build Ybus matrix (Using Function)
Ybus = formYbus(line_data, n_bus);
G = real(Ybus);
B = imag(Ybus);

disp('Ybus Matrix (p.u.):');
disp(Ybus);

% Bus Data
V = [1.05; 1.0; 1.0; 1.0];  % initial voltage magnitudes
delta = [0; 0; 0; 0];       % initial phase angles in radians
P = [0; -0.4; -0.5; -0.7];  % injected real powers
Q = [0; -0.15; -0.4; -0.2]; % injected reactive powers

% Slack Bus = 1
% PV Bus = 2
% PQ Buses = 3,4

% Indices
PQ = [3 4];
PV = [2];
npq = length(PQ);
npv = length(PV);

% Step 3: Calculate Jacobian
n = n_bus;
J1 = zeros(n-1,n-1);
J2 = zeros(n-1,npq);
J3 = zeros(npq,n-1);
J4 = zeros(npq,npq);

% J1: dP/dDelta
for i = 2:n
    for j = 2:n
        if i == j
            for k = 1:n
                J1(i-1,j-1) = J1(i-1,j-1) + V(i)*V(k)*(-G(i,k)*sin(delta(i)-delta(k)) + B(i,k)*cos(delta(i)-delta(k)));
            end
            J1(i-1,j-1) = J1(i-1,j-1) - V(i)^2*B(i,i);
        else
            J1(i-1,j-1) = V(i)*V(j)*(G(i,j)*sin(delta(i)-delta(j)) - B(i,j)*cos(delta(i)-delta(j)));
        end
    end
end

% J2: dP/dV
for i = 2:n
    for j = 1:npq
        m = PQ(j);
        if i == m
            for k = 1:n
                J2(i-1,j) = J2(i-1,j) + V(k)*(G(i,k)*cos(delta(i)-delta(k)) + B(i,k)*sin(delta(i)-delta(k)));
            end
            J2(i-1,j) = J2(i-1,j) + V(i)*G(i,i); % Fixed formula logic: usually P_calc/V + Gii*V
        else
            J2(i-1,j) = V(i)*(G(i,m)*cos(delta(i)-delta(m)) + B(i,m)*sin(delta(i)-delta(m)));
        end
    end
end

% J3: dQ/dDelta
for i = 1:npq
    m = PQ(i);
    for j = 2:n
        if m == j
            for k = 1:n
                J3(i,j-1) = J3(i,j-1) + V(m)*V(k)*(G(m,k)*cos(delta(m)-delta(k)) + B(m,k)*sin(delta(m)-delta(k)));
            end
            J3(i,j-1) = -J3(i,j-1) - V(m)^2*G(m,m); % Negative sign adjustment per standard formulas
        else
            J3(i,j-1) = -V(m)*V(j)*(G(m,j)*cos(delta(m)-delta(j)) + B(m,j)*sin(delta(m)-delta(j)));
        end
    end
end

% J4: dQ/dV
for i = 1:npq
    m = PQ(i);
    for j = 1:npq
        nbus = PQ(j);
        if m == nbus
            for k = 1:n
                J4(i,j) = J4(i,j) + V(k)*(G(m,k)*sin(delta(m)-delta(k)) - B(m,k)*cos(delta(m)-delta(k)));
            end
            J4(i,j) = J4(i,j) - V(m)*B(m,m);
        else
            J4(i,j) = V(m)*(G(m,nbus)*sin(delta(m)-delta(nbus)) - B(m,nbus)*cos(delta(m)-delta(nbus)));
        end
    end
end

% Combine Jacobian
J = [J1 J2; J3 J4];
disp('Jacobian Matrix (Initial State):');
disp(J);