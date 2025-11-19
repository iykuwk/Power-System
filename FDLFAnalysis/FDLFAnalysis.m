clc; 
clear;
% Input Data format: [From  To   R     X]
linedata = [
  1   2   0.07  0.15;
  1   3   0.06  0.10;
  1   4   0.08  0.25;
  2   3   0.04  0.10;
  3   4   0.04  0.20;
  ];
    
    n = 4;
    bus_type = [1 2 3 3]; % 1=Slack, 2=PV, 3=PQ
    Pspec = [0; 0.5; -0.8; -0.6]; % Specified P 
    Qspec = [0; 0;   -0.4; -0.3]; % Specified Q 
    
    % Calling Ybus Fucntion
    Ybus = formYbus(linedata, n);
    B = imag(Ybus);
    
    pv_pq_idx = find(bus_type ~= 1); % Buses 2,3,4 (for P)
    pq_idx = find(bus_type == 3);    % Buses 3,4 (for Q)
    
    % Create B matrices using Matrix Slicing (Efficient)
    Bprime = -B(pv_pq_idx, pv_pq_idx);
    Bdoubleprime = -B(pq_idx, pq_idx);
    
    V = [1.05; 1.0; 1.0; 1.0];
    delta = zeros(n, 1);
    tol = 1e-4;
    max_iter = 20;
    
    fprintf('Y-bus Matrix:\n'); disp(Ybus);
    
    % Iteration Loop 
    fprintf('\nStarting Iterations...\n');
    
    for iter = 1:max_iter
        % 1. Vectorized Calculation of P and Q (No nested loops)
        V_complex = V .* exp(1j * delta);
        S_calc = V_complex .* conj(Ybus * V_complex);
        P_calc = real(S_calc);
        Q_calc = imag(S_calc);
        
        % 2. Mismatches
        dP = Pspec(pv_pq_idx) - P_calc(pv_pq_idx);
        dQ = Qspec(pq_idx) - Q_calc(pq_idx);
        
        max_err = max([abs(dP); abs(dQ)]);
        fprintf('Iter %d: Max Error = %.6f\n', iter, max_err);
        
        if max_err < tol
            fprintf('\nConverged in %d iterations.\n', iter);
            break;
        end
        
        % 3. Update Angles (P-theta) using Backslash Operator (\)
        % Solves Ax = b efficiently without calculating inverse
        dTh = Bprime \ (dP ./ V(pv_pq_idx)); 
        delta(pv_pq_idx) = delta(pv_pq_idx) + dTh;
        
        % 4. Update Voltages (Q-V)
        % Recalculate Q with new angles for better accuracy
        V_complex = V .* exp(1j * delta);
        Q_calc = imag(V_complex .* conj(Ybus * V_complex));
        dQ = Qspec(pq_idx) - Q_calc(pq_idx);
        
        dV = Bdoubleprime \ (dQ ./ V(pq_idx));
        V(pq_idx) = V(pq_idx) + dV;
    end
    
    % Results
    disp(' '); disp('FINAL BUS DATA:');
    disp('Bus    V(pu)      Angle(deg)    P(pu)      Q(pu)');
    results = [ (1:n)', V, rad2deg(delta), P_calc, Q_calc ];
    disp(results);
    
    disp(' '); disp('LINE FLOWS:');
    disp('From   To     P_flow     Q_flow     S_mag');
    
    for k = 1:size(linedata, 1)
        fb = linedata(k, 1);
        tb = linedata(k, 2);
        Z = linedata(k, 3) + 1j*linedata(k, 4);
        
        Vf = V(fb) * exp(1j*delta(fb));
        Vt = V(tb) * exp(1j*delta(tb));
        
        I_line = (Vf - Vt) / Z;
        S_line = Vf * conj(I_line);
        
        fprintf('%d      %d      %.4f     %.4f     %.4f\n', ...
            fb, tb, real(S_line), imag(S_line), abs(S_line));
    end

