clc; clear;
  
    % Input data format: [From To R X]
    linedata = [
        1   2    0.07    0.15;
        1   3    0.06    0.10;
        1   4    0.08    0.25;
        2   4    0.04    0.10;
        3   4    0.04    0.20;
    ];
    
    n = 4;
    slack_bus = 1;
    P_inj = [0; -0.4; -0.5; -0.7]; % P injections
    V = [1.05; 1.0; 1.0; 1.0];     % Voltage magnitudes
    
    fprintf('DC POWER FLOW ANALYSIS (Optimized)\n\n');
    
    % Calling Y-Bus Function
    Ybus = formYbus(linedata, n);
    fprintf('Y_bus Matrix:\n'); disp(Ybus);
    
    % Form B Matrices & Solve Angle
    % B' = -imag(Ybus) for DC approximation
    B = -imag(Ybus);
    
    % Reduce B matrix (remove slack bus row/col)
    non_slack = setdiff(1:n, slack_bus);
    B_reduced = B(non_slack, non_slack);
    P_known = P_inj(non_slack);
    
    % Solve: P = B * delta  -->  delta = B \ P
    delta_calc = B_reduced \ P_known;
    
    % Reconstruct full delta vector
    delta = zeros(n, 1);
    delta(non_slack) = delta_calc;
   
    % Calculate complex voltage V = |V| /_ delta
    V_comp = V .* exp(1j * delta);
    
    % Calculate S = V * conj(I) = V * conj(Y * V)
    S_inj = V_comp .* conj(Ybus * V_comp);
    P_calc = real(S_inj); % Actual P (includes losses)
    Q_calc = imag(S_inj); % Reactive Power
    
    % Results
    fprintf('\nBUS RESULTS:\n');
    fprintf('Bus | Angle(deg) |  V (pu)  | P_inj(pu) | Q_calc(pu)\n');
    fprintf('----|------------|----------|-----------|------------\n');
    for i = 1:n
        fprintf(' %d  |  %9.4f |  %.4f  |  %8.4f |  %9.4f\n', ...
            i, rad2deg(delta(i)), V(i), P_inj(i), Q_calc(i));
    end
    
    fprintf('\nLINE FLOW RESULTS:\n');
    fprintf('From-To | P_flow (pu) | Angle Diff(deg)\n');
    fprintf('--------|-------------|----------------\n');
    
    for k = 1:size(linedata, 1)
        fb = linedata(k, 1);
        tb = linedata(k, 2);
        
        % Retrieve Yij magnitude from Ybus (off-diagonal is -yij)
        Y_mag = abs(Ybus(fb, tb));
        
        ang_diff = delta(fb) - delta(tb);
        
        % Power Flow Equation: P = Vi*Vj*Yij*sin(delta_i - delta_j)
        P_flow = V(fb) * V(tb) * Y_mag * sin(ang_diff);
        
        fprintf('  %d->%d   |   %8.4f  |    %.4f\n', ...
            fb, tb, P_flow, rad2deg(ang_diff));
    end
    
    % Calculate Slack Bus Generation (Sum of flows leaving bus 1) (Approximated by summing P_calc indices - simplified check)
    fprintf('\nTotal P Mismatch/Loss: %.4f pu\n', sum(real(S_inj)) - sum(P_inj));

