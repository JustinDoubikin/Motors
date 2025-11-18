% PMSM with FOC Configuration
% Example configuration for PMSM with Field-Oriented Control

%% Motor Selection
config.motor_type = 'PMSM';

%% Control Method Selection
config.control_method = 'FOC';

%% Simulation Parameters
config.sim_time = 5;
config.time_step = 1e-5;
config.solver = 'ode45';

%% PMSM Parameters (Surface-mounted PMSM)
config.motor.Rs = 0.5;          % Stator resistance (Ohm)
config.motor.Ld = 0.001;        % d-axis inductance (H)
config.motor.Lq = 0.001;        % q-axis inductance (H)
config.motor.lambda_m = 0.1;    % Permanent magnet flux linkage (Wb)
config.motor.p = 4;             % Number of pole pairs
config.motor.J = 0.0001;        % Motor inertia (kg.m^2)
config.motor.b = 0.00001;       % Damping coefficient (Nm.s/rad)

%% FOC Controller Parameters
% Current controller (d-axis)
config.controller.d_axis.Kp = 10;
config.controller.d_axis.Ki = 100;

% Current controller (q-axis)
config.controller.q_axis.Kp = 10;
config.controller.q_axis.Ki = 100;

% Speed controller
config.controller.speed.Kp = 0.1;
config.controller.speed.Ki = 1.0;
config.controller.speed.Kd = 0.001;

% Voltage limits
config.controller.voltage_limit = 48;  % DC bus voltage (V)
config.controller.current_limit = 10;  % Maximum current (A)

%% Load Parameters
config.load.type = 'constant';
config.load.torque = 0.5;       % Constant load torque (Nm)

%% Reference Signal (Speed control)
config.reference.type = 'step';
config.reference.amplitude = 1000;  % 1000 rad/s target speed
config.reference.step_time = 0.5;

%% Initial Conditions
config.initial.speed = 0;
config.initial.position = 0;
config.initial.id = 0;          % d-axis current
config.initial.iq = 0;          % q-axis current

%% Output Configuration
config.output.save_results = true;
config.output.plot_results = true;
config.output.save_path = '../Simulations/Results/';
config.output.filename_prefix = 'pmsm_foc_';

%% Visualization Options
config.plot.speed = true;
config.plot.current = true;
config.plot.torque = true;
config.plot.position = false;
config.plot.voltage = true;
