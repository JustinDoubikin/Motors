% DC Geared Motor with Encoder Feedback - PID Speed Control
% Motor: 12V DC Motor 350RPM with Encoder
% Configuration for closed-loop speed control using encoder feedback

%% Load Motor Parameters
motor_params = geared_motor_350rpm_params();

%% Motor Selection
config.motor_type = 'DC';

%% Control Method Selection
config.control_method = 'PID';

%% Simulation Parameters
config.sim_time = 10;           % Simulation time (seconds)
config.time_step = 1e-4;        % Time step (seconds)
config.solver = 'ode45';        % ODE solver

%% DC Motor Parameters (from motor parameter file)
config.motor.Ra = motor_params.Ra;          % Armature resistance (Ohm)
config.motor.La = motor_params.La;          % Armature inductance (H)
config.motor.Ke = motor_params.Ke;          % Back EMF constant (V/rad/s)
config.motor.Kt = motor_params.Kt;          % Torque constant (Nm/A)
config.motor.J = motor_params.J;            % Motor inertia (kg.m^2)
config.motor.b = motor_params.b;            % Damping coefficient (Nm.s/rad)
config.motor.voltage_max = motor_params.voltage_max;
config.motor.current_max = motor_params.current_max;

%% Encoder Configuration
config.encoder.enabled = true;
config.encoder.ppr = motor_params.encoder.ppr;      % Pulses per revolution
config.encoder.cpr = motor_params.encoder.cpr;      % Counts per revolution (quadrature)
config.encoder.noise = 0;                           % Encoder noise (counts) - can add for realism
config.encoder.update_rate = 1000;                  % Encoder reading rate (Hz)

%% Current Sensor Configuration
config.current_sensor.enabled = true;
config.current_sensor.sensitivity = motor_params.current_sensor.sensitivity;  % V/A
config.current_sensor.offset = motor_params.current_sensor.offset;            % V
config.current_sensor.noise = motor_params.current_sensor.noise;              % A (RMS)
config.current_sensor.bandwidth = 10000;            % Sensor bandwidth (Hz)

%% PID Controller Parameters
% Speed controller tuning
config.controller.Kp = 0.8;     % Proportional gain - tune based on motor response
config.controller.Ki = 3.0;     % Integral gain - eliminates steady-state error
config.controller.Kd = 0.02;    % Derivative gain - reduces overshoot
config.controller.output_limit = motor_params.voltage_max;  % Voltage limit (V)
config.controller.integral_limit = 5.0;  % Anti-windup limit

%% Current Limiting (for motor protection)
config.current_limit.enabled = true;
config.current_limit.max_current = motor_params.current_max;  % Maximum allowed current (A)
config.current_limit.action = 'reduce_voltage';  % Action when limit exceeded

%% Load Parameters
config.load.type = 'step';
config.load.torque = 0.3;       % Initial load torque (Nm) - about 25% of rated
config.load.step_torque = 0.6;  % Load torque after step (Nm) - about 50% of rated
config.load.step_time = 5;      % Time of load step (s)

%% Reference Signal (Speed control)
config.reference.type = 'step';
config.reference.amplitude = motor_params.speed_rated * 0.8;  % 80% of rated speed (rad/s)
config.reference.step_time = 1;  % Step time (s)

% Alternative: Multi-step reference to test tracking
% config.reference.type = 'multi_step';
% config.reference.steps = [
%     1.0,  motor_params.speed_rated * 0.5;   % 50% speed at t=1s
%     4.0,  motor_params.speed_rated * 0.8;   % 80% speed at t=4s
%     7.0,  motor_params.speed_rated * 0.3;   % 30% speed at t=7s
% ];

%% Initial Conditions
config.initial.speed = 0;       % Initial speed (rad/s)
config.initial.position = 0;    % Initial position (rad)
config.initial.current = 0;     % Initial current (A)

%% Output Configuration
config.output.save_results = true;
config.output.plot_results = true;
config.output.save_path = '../Simulations/Results/';
config.output.filename_prefix = 'geared_motor_350rpm_';

%% Visualization Options
config.plot.speed = true;       % Plot speed vs reference
config.plot.current = true;     % Plot motor current
config.plot.torque = true;      % Plot motor torque
config.plot.position = true;    % Plot encoder position (enable for this motor)
config.plot.voltage = true;     % Plot applied voltage
config.plot.encoder = true;     % Plot encoder counts (for debugging)

%% Performance Metrics to Calculate
config.metrics.settling_time = true;     % Calculate settling time
config.metrics.overshoot = true;         % Calculate overshoot percentage
config.metrics.steady_state_error = true; % Calculate steady-state error
config.metrics.rise_time = true;         % Calculate rise time

%% Display Configuration Summary
fprintf('\n=== Configuration Summary ===\n');
fprintf('Motor: %s\n', motor_params.name);
fprintf('Rated Speed: %.0f RPM\n', motor_params.speed_rated_rpm);
fprintf('Target Speed: %.0f RPM (%.1f%% of rated)\n', ...
        config.reference.amplitude*60/(2*pi), ...
        config.reference.amplitude/motor_params.speed_rated*100);
fprintf('Encoder Resolution: %d CPR\n', config.encoder.cpr);
fprintf('PID Gains: Kp=%.2f, Ki=%.2f, Kd=%.4f\n', ...
        config.controller.Kp, config.controller.Ki, config.controller.Kd);
fprintf('Current Limit: %.2f A\n', config.current_limit.max_current);
fprintf('Voltage Limit: %.2f V\n', config.controller.output_limit);
fprintf('=============================\n\n');
