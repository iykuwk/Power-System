clc;
clear;

Vr = 400e3; Pr = 400e6; pf = 0.9;
R = 0.01*150; X = 0.1*150; B = 1.1e-6*150;

Ir = Pr/(sqrt(3)*Vr*pf);
phi = acos(pf);
Ir_complex = Ir*(cos(-phi)+1i*sin(-phi));

Y = 1i*B;
Z = R + 1i*X;

A = 1 + Z*Y/2;
B = Z;
C = Y*(1+Z*Y/4);
D = A;

Vs = A*Vr + B*Ir_complex;
Is = C*Vr + D*Ir_complex;

Ps = real(sqrt(3)*Vs*conj(Is));
efficiency = Pr/Ps*100;

fprintf('Medium Line(150km):\n');
fprintf('Vs = %.2f kV\n', abs(Vs)/1e3);
fprintf('Efficiency = %.2f %%\n', efficiency);