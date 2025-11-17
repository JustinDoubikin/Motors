% DC Motor with PID Speed Control Configuration
% Example configuration for a brushed DC motor with PID speed control

%% Motor Selection
config.motor_type = 'DC';

%% Control Method Selection
config.control_method = 'PID';

%% Simulation Parameters
config.sim_time = 10;
config.time_step = 1e-4;
config.solver = 'ode45';

%% DC Motor Parameters (Small brushed DC motor)
config.motor.Ra = 1.0;          % Armature resistance (Ohm)
config.motor.La = 0.005;        % Armature inductance (H)
config.motor.Ke = 0.05;         % Back EMF constant (V/rad/s)
config.motor.Kt = 0.05;         % Torque constant (Nm/A)
config.motor.J = 0.001;         % Motor inertia (kg.m^2)
config.motor.b = 0.0001;        % Damping coefficient (Nm.s/rad)

%% PID Controller Parameters
config.controller.Kp = 0.5;
config.controller.Ki = 2.0;
config.controller.Kd = 0.01;
config.controller.output_limit = 12;  % 12V supply

%% Load Parameters
config.load.type = 'step';
config.load.torque = 0.01;      % Initial load torque (Nm)
config.load.step_torque = 0.02; % Load torque after step
config.load.step_time = 5;

%% Reference Signal (Speed control)
config.reference.type = 'step';
config.reference.amplitude = 200;  % 200 rad/s target speed
config.reference.step_time = 1;

%% Initial Conditions
config.initial.speed = 0;
config.initial.position = 0;
config.initial.current = 0;

%% Output Configuration
config.output.save_results = true;
config.output.plot_results = true;
config.output.save_path = '../Simulations/Results/';
config.output.filename_prefix = 'dc_pid_';

%% Visualization Options
config.plot.speed = true;
config.plot.current = true;
config.plot.torque = true;
config.plot.position = false;
config.plot.voltage = true;
