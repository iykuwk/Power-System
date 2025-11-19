clc;
clear;

Vr = 400e3;
Pr = 400e6;
pf = 0.9;
R = 0.01*20;
X = 0.1*20;

Ir = Pr/(sqrt(3)*Vr*pf);
ph1 = acos(pf);
Ir_complex = Ir*(cos(-ph1) + 1i*sin(-ph1));

Vs = Vr + (R + 1i*X)*Ir_complex;

Is = Ir_complex;
Ps = real(sqrt(3)*Vs*conj(Is));

efficiency = Pr/Ps * 100;

fprintf('Short Line(20 km):\n');
fprintf('Vs = %.2f kV\n', abs(Vs)/1e3);
fprintf('Efficiency = %.2f %%\n', efficiency);