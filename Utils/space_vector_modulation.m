function [Sa, Sb, Sc] = space_vector_modulation(Valpha, Vbeta, Vdc)
% SPACE_VECTOR_MODULATION - Generate PWM signals using SVM
%
% Generates three-phase PWM switching signals using Space Vector Modulation
%
% Inputs:
%   Valpha, Vbeta - Voltage references in αβ frame
%   Vdc - DC bus voltage
%
% Outputs:
%   Sa, Sb, Sc - PWM duty cycles for phases a, b, c (0 to 1)
%
% This is a simplified implementation. For actual use, implement
% sector determination and timing calculation.

    % Calculate reference voltage magnitude and angle
    Vref = sqrt(Valpha^2 + Vbeta^2);
    theta_v = atan2(Vbeta, Valpha);
    
    % Determine sector (1-6)
    sector = floor(theta_v / (pi/3)) + 1;
    if sector > 6
        sector = 1;
    end
    
    % Normalize angle within sector
    theta_n = theta_v - (sector - 1) * pi/3;
    
    % Calculate timing for vectors
    m = Vref / (Vdc / sqrt(3));  % Modulation index
    T1 = m * sin(pi/3 - theta_n);
    T2 = m * sin(theta_n);
    T0 = 1 - T1 - T2;
    
    % Generate duty cycles based on sector (simplified)
    switch sector
        case 1
            Sa = T1 + T2 + T0/2;
            Sb = T2 + T0/2;
            Sc = T0/2;
        case 2
            Sa = T1 + T0/2;
            Sb = T1 + T2 + T0/2;
            Sc = T0/2;
        case 3
            Sa = T0/2;
            Sb = T1 + T2 + T0/2;
            Sc = T2 + T0/2;
        case 4
            Sa = T0/2;
            Sb = T1 + T0/2;
            Sc = T1 + T2 + T0/2;
        case 5
            Sa = T2 + T0/2;
            Sb = T0/2;
            Sc = T1 + T2 + T0/2;
        case 6
            Sa = T1 + T2 + T0/2;
            Sb = T0/2;
            Sc = T1 + T0/2;
    end
    
    % Ensure duty cycles are within [0, 1]
    Sa = max(0, min(1, Sa));
    Sb = max(0, min(1, Sb));
    Sc = max(0, min(1, Sc));
end
