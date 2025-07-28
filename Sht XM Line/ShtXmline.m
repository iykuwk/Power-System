%% Short Transmission Line Analysis
% Description: Calculates sending-end voltage, power, efficiency, and regulation.
% Author Name: Yashodahn Zingade
% Date : 2025-07-25
clc;
clear;

V_r = 400e3;  % Receiving voltage      
P_r = 400e6;  % Receiving Side Power         
pf = 0.9;     % Power factor           
length = 20;  % Transmission line length         
R_per_km = 0.01;  % Resistance Per KM
X_per_km = 0.1;   % Reactance Per KM                      

Z = (R_per_km + 1j*X_per_km) * length; % Formula for total impedance 
V_r_phase = V_r / sqrt(3); % Receiving Voltage Per Phase
I_r = (P_r / (sqrt(3)*V_r*pf)); % Receving End current Per Phase       
phi = acos(pf);                         
I_r_phasor = I_r * exp(-1j*phi); % Phasor Current angle         

V_s_phase = V_r_phase + Z * I_r_phasor; % Recieving End Voltage       
V_s = (V_s_phase) * sqrt(3);               
P_s = 3 * real(V_s_phase * conj(I_r_phasor)); % Recieving end Power
efficiency = (P_r / P_s) * 100; % System Efficiency
VR = (((V_s_phase) - (V_r_phase)) / (V_r_phase)) * 100; 
% Voltage Regulation               

fprintf('--- Short Transmission Line Simulation Results ---\n');
fprintf('Line Impedance (Z): %.2f + j%.2f ohms\n', real(Z), imag(Z));
fprintf('Receiving End Current: %.2f A\n', (I_r_phasor));
fprintf('Sending End Voltage (line-to-line): %.2f kV\n', V_s/1e3);
fprintf('Sending End Power: %.2f MW\n', P_s/1e6);
fprintf('Transmission Efficiency: %.2f %%\n', efficiency);
fprintf('Voltage Regulation: %.2f %%\n', VR);
