% DC Geared Motor Parameters - 12V 350RPM with Encoder
% Motor: https://core-electronics.com.au/12v-dc-motor-350rpm-w-encoder-12kg-cm.html
% Driver: Toshiba TB67H420FTG (https://www.pololu.com/product/2999)
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
    params.torque_rated = 1.2;          % Stall torque (Nm) - 12 kg-cm converted
    params.current_noload = 0.23;       % No-load current (A) - from datasheet
    params.current_stall = 5.5;         % Stall current (A) - from datasheet
    params.gear_ratio = 34;             % Gear reduction ratio - from datasheet
    params.weight = 0.098;              % Motor weight (kg) - 98g
    
    %% Operating Points (from datasheet)
    % Maximum efficiency point
    params.max_eff.torque = 0.20;       % Torque at max efficiency (Nm) - 2.0 kg-cm
    params.max_eff.speed_rpm = 285;     % Speed at max efficiency (RPM)
    params.max_eff.speed = params.max_eff.speed_rpm * 2*pi/60;  % rad/s
    params.max_eff.power = 5.0;         % Power at max efficiency (W)
    params.max_eff.current = 0.65;      % Current at max efficiency (A)
    
    % Maximum power point
    params.max_power.torque = 0.58;     % Torque at max power (Nm) - 5.8 kg-cm
    params.max_power.speed_rpm = 180;   % Speed at max power (RPM)
    params.max_power.speed = params.max_power.speed_rpm * 2*pi/60;  % rad/s
    params.max_power.power = 9.0;       % Maximum power (W)
    params.max_power.current = 1.65;    % Current at max power (A)
    
    %% Calculated Motor Parameters
    % Back EMF constant (Ke) - V/(rad/s)
    % At no-load: V = Ke * omega + I_noload * Ra
    % First estimate Ra from stall condition: Ra = V_stall / I_stall
    params.Ra = params.voltage_rated / params.current_stall;  % Ra ≈ 2.18 Ohm
    
    % Now calculate Ke from no-load condition
    params.Ke = (params.voltage_rated - params.current_noload * params.Ra) / params.speed_rated;
    % Ke ≈ 0.314 V/(rad/s)
    
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
    params.encoder.ppr = 11;            % Pulses per revolution (single phase) - from datasheet
    params.encoder.type = 'quadrature'; % Encoder type (Hall effect quadrature)
    params.encoder.resolution = 374;    % Maximum output within one round - from datasheet
    params.encoder.cpr = params.encoder.resolution;  % Counts per revolution (374)
    
    %% Driver Specifications (Toshiba TB67H420FTG)
    params.driver.name = 'Toshiba TB67H420FTG Dual/Single Motor Driver';
    params.driver.voltage_min = 10;     % Minimum motor voltage (V)
    params.driver.voltage_max = 47;     % Maximum motor voltage (V)
    params.driver.current_continuous_dual = 1.7;   % Continuous current per channel, dual mode (A)
    params.driver.current_continuous_single = 3.4; % Continuous current, single mode (A)
    params.driver.current_peak_dual = 4.5;         % Peak current per channel, dual mode (A)
    params.driver.current_peak_single = 9.0;       % Peak current, single mode (A)
    params.driver.current_chopping_dual = 4.5;     % Default current chopping limit, dual (A)
    params.driver.current_chopping_single = 9.0;   % Default current chopping limit, single (A)
    params.driver.mode = 'dual';        % Operating mode: 'dual' or 'single'
    params.driver.pwm_frequency = 25000; % Typical PWM frequency (Hz) - [ESTIMATED]
    params.driver.reverse_protection = true;  % Has reverse voltage protection up to 40V
    
    %% Current Sensor Specifications
    params.current_sensor.sensitivity = 0.4;  % 400mV/A = 0.4 V/A
    params.current_sensor.range = [-5, 5];    % ±5A range
    params.current_sensor.offset = 2.5;       % [ESTIMATED] Offset voltage at 0A (V) - for 5V supply
    params.current_sensor.noise = 0.010;      % [ESTIMATED] Sensor noise (A RMS)
    
    %% Operating Limits
    % Select appropriate limits based on driver mode
    if strcmp(params.driver.mode, 'dual')
        params.voltage_max = min(params.voltage_rated, params.driver.voltage_max);
        params.current_max = params.driver.current_continuous_dual;  % 1.7A continuous
        params.current_peak = params.driver.current_peak_dual;       % 4.5A peak
    else  % single mode
        params.voltage_max = min(params.voltage_rated, params.driver.voltage_max);
        params.current_max = params.driver.current_continuous_single;  % 3.4A continuous
        params.current_peak = params.driver.current_peak_single;       % 9A peak
    end
    
    %% Notes for System Identification
    params.notes = {
        'IMPORTANT: Parameters marked [ESTIMATED] should be verified through system identification.'
        ''
        'Known parameters from datasheet:'
        '- Gear ratio: 34:1'
        '- No-load speed: 350 RPM at 12V'
        '- No-load current: 0.23A'
        '- Stall current: 5.5A'
        '- Stall torque: 12 kg-cm (1.2 Nm)'
        '- Encoder resolution: 374 counts per revolution'
        '- Max efficiency point: 2.0kg.cm @ 285rpm, 0.65A, 5.0W'
        '- Max power point: 5.8kg.cm @ 180rpm, 1.65A, 9.0W'
        '- Weight: 98g'
        ''
        'Calculated parameters (should be verified):'
        '- Ra ≈ 2.18 Ω (from stall condition)'
        '- Ke ≈ 0.314 V/(rad/s) (from no-load condition)'
        '- Kt ≈ 0.314 Nm/A (equals Ke in SI units)'
        ''
        'Recommended System ID Tests:'
        '1. No-load test: Verify Ke and Ra calculations'
        '2. Locked rotor test: Verify Ra and measure La'
        '3. Step response: Measure speed response to refine J and b'
        '4. Load test: Verify Kt and measure friction/efficiency'
        '5. Encoder verification: Count pulses during known rotations (should be 374 per rev)'
        ''
        'Current sensor calibration:'
        '- Measure offset voltage at zero current'
        '- Verify sensitivity with known current levels'
        ''
        'Driver configuration:'
        '- TB67H420FTG supports dual (1.7A cont.) or single (3.4A cont.) channel mode'
        '- Current chopping actively limits current to 4.5A (dual) or 9A (single)'
        '- Thermal protection will engage if continuous current too high'
        '- In practice, sustainable current is ~1.7A dual or ~3.4A single without overheating'
    };
    
    %% Display parameters
    fprintf('DC Geared Motor Parameters Loaded:\n');
    fprintf('  Motor: %s\n', params.name);
    fprintf('  Gear Ratio: %d:1\n', params.gear_ratio);
    fprintf('  No-load: %.0f RPM @ %.2fA\n', params.speed_rated_rpm, params.current_noload);
    fprintf('  Stall: %.2f Nm @ %.2fA\n', params.torque_rated, params.current_stall);
    fprintf('  Max Efficiency: %.1f W @ 285 RPM (%.2fA)\n', params.max_eff.power, params.max_eff.current);
    fprintf('  Max Power: %.1f W @ 180 RPM (%.2fA)\n', params.max_power.power, params.max_power.current);
    fprintf('  Encoder Resolution: %d CPR\n', params.encoder.cpr);
    fprintf('  Driver: %s (%s mode)\n', params.driver.name, params.driver.mode);
    fprintf('  Current Limits: %.1fA cont., %.1fA peak\n', params.current_max, params.current_peak);
    fprintf('\nCalculated Parameters:\n');
    fprintf('  Ra: %.3f Ω (from stall test)\n', params.Ra);
    fprintf('  Ke: %.4f V/(rad/s) (from no-load test)\n', params.Ke);
    fprintf('  Kt: %.4f Nm/A\n', params.Kt);
    fprintf('\n  NOTE: Verify calculated parameters through system identification!\n');
end
