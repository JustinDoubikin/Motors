% DC Geared Motor Parameters - 12V 350RPM with Encoder
% Motor: https://core-electronics.com.au/12v-dc-motor-350rpm-w-encoder-12kg-cm.html
% Driver: Pololu DRV8838 (https://www.pololu.com/product/2999)
% Current Sensor: ±5A with 400mV/A output
%
% NOTE: Parameters marked with [ESTIMATED] are calculated based on 
% available specifications and will need system identification in real-world use.

function params = geared_motor_350rpm_params()
    %% Motor Specifications (from datasheet)
    params.name = 'DC Geared Motor 350RPM';
    params.voltage_rated = 12;          % Rated voltage (V)
    params.speed_rated_rpm = 350;       % No-load speed (RPM) at 12V
    params.speed_rated = params.speed_rated_rpm * 2*pi/60;  % Convert to rad/s (36.65 rad/s)
    params.torque_rated = 1.2;          % Rated torque (Nm) - 12 kg-cm converted
    params.current_noload = 0.08;       % [ESTIMATED] No-load current (A) - typical for this size
    params.current_rated = 1.5;         % [ESTIMATED] Rated current (A) - typical for 12V geared motor
    params.gear_ratio = 30;             % [ESTIMATED] Based on 350 RPM from typical DC motor speeds
    
    %% Calculated Motor Parameters
    % Back EMF constant (Ke) - V/(rad/s)
    % At no-load: V = Ke * omega + I_noload * Ra
    % Ke = (V - I_noload * Ra) / omega
    % Estimate Ra first, then calculate Ke
    params.Ra = 2.0;                    % [ESTIMATED] Armature resistance (Ohm) - typical for small DC motor
    params.Ke = (params.voltage_rated - params.current_noload * params.Ra) / params.speed_rated;
    % Ke ≈ 0.32 V/(rad/s)
    
    % Torque constant (Kt) - Nm/A (in SI units, Kt = Ke)
    params.Kt = params.Ke;              % Torque constant (Nm/A)
    
    % Armature inductance
    params.La = 0.002;                  % [ESTIMATED] Armature inductance (H) - typical for this size
    
    %% Mechanical Parameters (including gearbox)
    % Motor inertia (rotor only, before gearbox)
    params.J_motor = 1e-6;              % [ESTIMATED] Motor rotor inertia (kg.m^2)
    
    % Gearbox inertia (referred to motor side)
    params.J_gearbox = 5e-6;            % [ESTIMATED] Gearbox inertia (kg.m^2)
    
    % Total inertia at motor shaft
    params.J = params.J_motor + params.J_gearbox;  % Total inertia (kg.m^2)
    
    % Damping coefficient
    params.b = 0.0001;                  % [ESTIMATED] Damping coefficient (Nm.s/rad)
    
    %% Encoder Specifications
    params.encoder.ppr = 334;           % Pulses per revolution (from product description)
    params.encoder.type = 'quadrature'; % Encoder type
    params.encoder.resolution = params.encoder.ppr * 4;  % Quadrature gives 4x resolution
    params.encoder.cpr = params.encoder.resolution;      % Counts per revolution (1336)
    
    %% Driver Specifications (Pololu DRV8838)
    params.driver.name = 'Pololu DRV8838';
    params.driver.voltage_max = 11;     % Maximum motor voltage (V)
    params.driver.current_max = 1.8;    % Continuous current limit (A)
    params.driver.pwm_frequency = 25000; % Typical PWM frequency (Hz) - [ESTIMATED]
    params.driver.deadband = 0.0;       % [ESTIMATED] Deadband voltage (V)
    
    %% Current Sensor Specifications
    params.current_sensor.sensitivity = 0.4;  % 400mV/A = 0.4 V/A
    params.current_sensor.range = [-5, 5];    % ±5A range
    params.current_sensor.offset = 2.5;       % [ESTIMATED] Offset voltage at 0A (V) - for 5V supply
    params.current_sensor.noise = 0.010;      % [ESTIMATED] Sensor noise (A RMS)
    
    %% Operating Limits
    params.voltage_max = min(params.voltage_rated, params.driver.voltage_max);
    params.current_max = min(params.current_rated, params.driver.current_max);
    
    %% Notes for System Identification
    params.notes = {
        'IMPORTANT: Parameters marked [ESTIMATED] should be verified through system identification.'
        ''
        'Recommended System ID Tests:'
        '1. No-load test: Measure speed vs voltage to refine Ke and Ra'
        '2. Locked rotor test: Measure current vs voltage to verify Ra and La'
        '3. Step response: Measure speed response to refine J and b'
        '4. Load test: Apply known loads to verify Kt and friction'
        '5. Encoder verification: Count pulses during known rotations'
        ''
        'Current sensor calibration:'
        '- Measure offset voltage at zero current'
        '- Verify sensitivity with known current levels'
        ''
        'Gearbox parameters:'
        '- Gear ratio should be measured or confirmed from manufacturer'
        '- Efficiency losses not yet modeled (typically 70-85% for this type)'
    };
    
    %% Display parameters
    fprintf('DC Geared Motor Parameters Loaded:\n');
    fprintf('  Motor: %s\n', params.name);
    fprintf('  Rated Speed: %.0f RPM (%.2f rad/s)\n', params.speed_rated_rpm, params.speed_rated);
    fprintf('  Rated Torque: %.2f Nm\n', params.torque_rated);
    fprintf('  Encoder Resolution: %d CPR\n', params.encoder.cpr);
    fprintf('  Ke: %.4f V/(rad/s) [ESTIMATED]\n', params.Ke);
    fprintf('  Ra: %.2f Ohm [ESTIMATED]\n', params.Ra);
    fprintf('\n  NOTE: Run system identification to refine estimated parameters!\n');
end
