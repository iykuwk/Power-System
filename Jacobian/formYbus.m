function Y = formYbus(linedata, n)
    % Initialize Y-bus with zeros
    Y = zeros(n, n);
    
    % Count number of transmission lines (rows in linedata)
    numLines = size(linedata, 1);
    
    for k = 1:numLines
        % Extract data for the current line
        fb = linedata(k, 1); % From Bus
        tb = linedata(k, 2); % To Bus
        R = linedata(k, 3);  % Resistance
        X = linedata(k, 4);  % Reactance
        
        % Calculate Mutual Admittance
        Z = R + 1i*X; 
        y_ij = 1/Z;
        
        % Update Diagonal Elements (Self Admittance)
        Y(fb, fb) = Y(fb, fb) + y_ij;
        Y(tb, tb) = Y(tb, tb) + y_ij;
        
        % Update Off-Diagonal Elements (Mutual Admittance)
        Y(fb, tb) = Y(fb, tb) - y_ij;
        Y(tb, fb) = Y(tb, fb) - y_ij;
    end
end
