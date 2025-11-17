% Induction Motor with Scalar V/f Control Configuration
% Example configuration for 3-phase induction motor with V/f control

%% Motor Selection
config.motor_type = 'Induction';

%% Control Method Selection
config.control_method = 'ScalarControl';

%% Simulation Parameters
config.sim_time = 15;
config.time_step = 1e-4;
config.solver = 'ode45';

%% Induction Motor Parameters (3-phase squirrel cage)
config.motor.Rs = 1.5;          % Stator resistance (Ohm)
config.motor.Rr = 1.2;          % Rotor resistance (Ohm)
config.motor.Ls = 0.15;         % Stator inductance (H)
config.motor.Lr = 0.15;         % Rotor inductance (H)
config.motor.Lm = 0.14;         % Mutual inductance (H)
config.motor.p = 2;             % Number of pole pairs
config.motor.J = 0.05;          % Motor inertia (kg.m^2)
config.motor.b = 0.001;         % Damping coefficient (Nm.s/rad)

%% V/f Controller Parameters
config.controller.base_frequency = 50;    % Base frequency (Hz)
config.controller.base_voltage = 220;     % Base voltage (V RMS line-to-line)
config.controller.boost_voltage = 10;     % Low-speed voltage boost (V)
config.controller.boost_freq = 5;         % Frequency below which boost is applied (Hz)
config.controller.max_frequency = 60;     % Maximum frequency (Hz)
config.controller.accel_time = 5;         % Acceleration time 0 to max freq (s)
config.controller.decel_time = 5;         % Deceleration time max to 0 freq (s)

%% Load Parameters
config.load.type = 'quadratic';  % Fan/pump load (torque proportional to speed^2)
config.load.torque_coeff = 0.0001;  % Torque = coeff * speed^2

%% Reference Signal (Frequency control)
config.reference.type = 'ramp';
config.reference.amplitude = 50;   % Target frequency (Hz)
config.reference.ramp_time = 10;   % Time to reach target (s)

%% Initial Conditions
config.initial.speed = 0;
config.initial.stator_flux = 0;
config.initial.rotor_flux = 0;

%% Output Configuration
config.output.save_results = true;
config.output.plot_results = true;
config.output.save_path = '../Simulations/Results/';
config.output.filename_prefix = 'induction_vf_';

%% Visualization Options
config.plot.speed = true;
config.plot.current = true;
config.plot.torque = true;
config.plot.position = false;
config.plot.voltage = true;
