clc;
clear;

P = 400*10^6/3;
Vr = 400*10^3/sqrt(3);
pf = 0.9;
Ir = P/(pf*Vr)*exp(-acos(pf)*1i);

R = 0.01*20;
X = 0.1*20i;

Z = R + X;

A = 1;
B = Z;
C = 0;
D = 1;

T = [A B; C D];
Y = [Vr; Ir];

S = T*Y;

Vs = S(1);
Is = S(2);

% Voltage Regulation
VR = (abs(abs(Vs) - abs(Vr))/abs(Vs))*100;

% Efficiency
n = P/(real(Vs*conj(Is)))*100;



