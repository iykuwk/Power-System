clc;
clear;

Vr = 400e3; Pr = 400e6; pf = 0.9;
R = 0.01*300; X = 0.1*300; B = 1.1e-6*300;

Ir = Pr/(sqrt(3)*Vr*pf);
phi = acos(pf);
Ir_complex = Ir*(cos(-phi)+1i*sin(-phi));

r = 0.01; x = 0.1; b = 1.1e-6;
z = r + 1i*x;
y = 1i*b;

gamma = sqrt (z*y);
Zc = sqrt(z/y);

len = 300;
A = cosh(gamma*len);
B = Zc*sinh(gamma*len);
C = (1/Zc)*sinh(gamma*len);
D = A;

Vs = A*Vr + B*Ir_complex;
Is = C*Vr + D*Ir_complex;

Ps = real(sqrt(3)*Vs*conj(Is));
efficiency = Pr/Ps*100;

fprintf('Long Line(300km):\n');
fprintf('Vs = %.2f kV\n', abs(Vs)/1e3);
fprintf('Efficiency = %.2f %%\n', efficiency);