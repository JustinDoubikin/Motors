% Simulation Configuration Template
% Copy this file and modify parameters for your specific simulation

%% Motor Selection
config.motor_type = 'DC';  % Options: 'DC', 'BLDC', 'Stepper', 'Induction', 'PMSM'

%% Control Method Selection
config.control_method = 'PID';  % Options: 'PID', 'FOC', 'DTC', 'VectorControl', 'ScalarControl'

%% Simulation Parameters
config.sim_time = 10;           % Simulation time in seconds
config.time_step = 1e-5;        % Simulation time step in seconds
config.solver = 'ode45';        % MATLAB ODE solver

%% Motor Parameters (Example for DC Motor)
config.motor.Ra = 0.5;          % Armature resistance (Ohm)
config.motor.La = 0.01;         % Armature inductance (H)
config.motor.Ke = 0.1;          % Back EMF constant (V/rad/s)
config.motor.Kt = 0.1;          % Torque constant (Nm/A)
config.motor.J = 0.01;          % Motor inertia (kg.m^2)
config.motor.b = 0.001;         % Damping coefficient (Nm.s/rad)

%% Controller Parameters (Example for PID)
config.controller.Kp = 10;      % Proportional gain
config.controller.Ki = 5;       % Integral gain
config.controller.Kd = 0.1;     % Derivative gain
config.controller.output_limit = 24;  % Maximum output voltage (V)

%% Load Parameters
config.load.type = 'constant';  % Options: 'constant', 'linear', 'quadratic', 'step'
config.load.torque = 0.5;       % Load torque (Nm)
config.load.step_time = 5;      % Time for load step change (s)

%% Reference Signal
config.reference.type = 'step'; % Options: 'step', 'ramp', 'sine'
config.reference.amplitude = 100;  % Reference amplitude (rad/s for speed, rad for position)
config.reference.step_time = 1;    % Time for step change (s)

%% Initial Conditions
config.initial.speed = 0;       % Initial speed (rad/s)
config.initial.position = 0;    % Initial position (rad)
config.initial.current = 0;     % Initial current (A)

%% Output Configuration
config.output.save_results = true;
config.output.plot_results = true;
config.output.save_path = '../Simulations/Results/';
config.output.filename_prefix = 'sim_';

%% Visualization Options
config.plot.speed = true;
config.plot.current = true;
config.plot.torque = true;
config.plot.position = false;
config.plot.voltage = true;
