function run_simulation(config_file)
% RUN_SIMULATION - Main function to run motor control simulations
%
% Syntax: run_simulation(config_file)
%
% Inputs:
%    config_file - String path to configuration file (optional)
%                  If not provided, uses config_template.m
%
% Example:
%    run_simulation('Configs/my_dc_motor_config.m')
%    run_simulation()  % Uses default template
%
% This function:
% 1. Loads the configuration
% 2. Initializes the motor model
% 3. Initializes the controller
% 4. Runs the simulation
% 5. Plots and saves results

    %% Load Configuration
    if nargin < 1
        config_file = 'Configs/config_template.m';
    end
    
    % Add paths
    addpath(genpath('../Motors'));
    addpath(genpath('../ControlMethods'));
    addpath(genpath('../Utils'));
    
    % Run config file to load parameters
    run(config_file);
    
    % Clear persistent variables in controller
    clear simple_pi_control;
    
    fprintf('Starting simulation... \n');
    fprintf('Motor Type: %s\n', config.motor_type);
    fprintf('Control Method: %s\n', config.control_method);
    fprintf('Simulation Time: %.2f seconds\n', config.sim_time);
    
    %% Initialize Time Vector
    t = 0:config.time_step:config.sim_time;
    
    %% Generate Reference Signal
    reference = generate_reference(t, config);
    
    %% Initialize Storage Arrays
    results.time = t;
    results.reference = reference;
    results.speed = zeros(size(t));
    results.current = zeros(size(t));
    results.torque = zeros(size(t));
    results.voltage = zeros(size(t));
    results.position = zeros(size(t));
    
    %% Set Initial Conditions
    results.speed(1) = config.initial.speed;
    results.current(1) = config.initial.current;
    results.position(1) = config.initial.position;
    
    %% Simulation Loop
    fprintf('Running simulation...\n');
    for i = 2:length(t)
        % Calculate control error
        error = reference(i-1) - results.speed(i-1);
        
        % Call controller (placeholder - will be replaced with actual controller)
        results.voltage(i-1) = simple_pi_control(error, config.controller, config.time_step);
        
        % Update motor state (placeholder - will be replaced with actual motor model)
        [results.speed(i), results.current(i), results.torque(i), results.position(i)] = ...
            update_motor_state(results.speed(i-1), results.current(i-1), ...
                              results.voltage(i-1), config, config.time_step);
    end
    
    fprintf('Simulation complete!\n');
    
    %% Plot Results
    if config.output.plot_results
        plot_results(results, config);
    end
    
    %% Save Results
    if config.output.save_results
        save_results(results, config);
    end
end

%% Helper Functions

function ref = generate_reference(t, config)
    % Generate reference signal based on configuration
    switch config.reference.type
        case 'step'
            ref = config.reference.amplitude * (t >= config.reference.step_time);
        case 'ramp'
            ref = config.reference.amplitude * t / max(t);
        case 'sine'
            % Use specified frequency if present, otherwise default to 1 Hz
            if isfield(config.reference, 'frequency') && ~isempty(config.reference.frequency)
            f = config.reference.frequency;
            else
            f = 1; % default frequency (Hz)
            end
            ref = config.reference.amplitude * sin(2*pi*f.*t);
        otherwise
            ref = zeros(size(t));
    end
end

function voltage = simple_pi_control(error, controller, dt)
    % Simple PI controller with proper integral scaling
    % Inputs:
    %   error - Control error (reference - actual)
    %   controller - Struct with Kp, Ki, output_limit
    %   dt - Time step for integral calculation
    % Output:
    %   voltage - Control signal with saturation
    
    persistent integral;
    if isempty(integral)
        integral = 0;
    end
    
    % Proper discrete integral with dt scaling
    integral = integral + error * dt;
    voltage = controller.Kp * error + controller.Ki * integral;
    
    % Saturation
    voltage = max(min(voltage, controller.output_limit), -controller.output_limit);
end

function [speed, current, torque, position] = update_motor_state(speed_prev, current_prev, voltage, config, dt)
    % Enhanced DC motor model with current saturation and nonlinear friction
    % Inputs:
    %   speed_prev, current_prev - Previous states
    %   voltage - Applied voltage
    %   config - Configuration struct
    %   dt - Time step
    % Outputs:
    %   speed, current, torque, position - Updated states
    
    % Electrical dynamics: di/dt = (V - Ke*omega - Ra*i) / La
    current = current_prev + (voltage - config.motor.Ke * speed_prev - config.motor.Ra * current_prev) * dt / config.motor.La;
    
    % Current saturation (if defined in config)
    if isfield(config.motor, 'I_max')
        current = max(min(current, config.motor.I_max), -config.motor.I_max);
    end
    
    % Electromagnetic torque
    torque_em = config.motor.Kt * current;
    
    % Nonlinear friction: viscous (b*omega) + Coulomb (constant, direction-dependent)
    friction_viscous = config.motor.b * speed_prev;
    
    if isfield(config.motor, 'Tc')
        % Coulomb friction (opposes motion)
        if abs(speed_prev) > 1e-3  % Threshold to avoid chattering at zero speed
            friction_coulomb = config.motor.Tc * sign(speed_prev);
        else
            friction_coulomb = 0;
        end
    else
        friction_coulomb = 0;
    end
    
    % Net torque
    torque = torque_em - friction_viscous - friction_coulomb - config.load.torque;
    
    % Mechanical dynamics: domega/dt = torque_net / J
    speed = speed_prev + torque * dt / config.motor.J;
    
    % Position integration (simple forward Euler)
    position = 0;  % Not implemented in this simple example
end

function plot_results(results, config)
    % Plot simulation results
    figure('Name', 'Simulation Results', 'Position', [100, 100, 1200, 800]);
    
    plot_count = sum([config.plot.speed, config.plot.current, config.plot.torque, config.plot.voltage]);
    current_plot = 1;
    
    if config.plot.speed
        subplot(plot_count, 1, current_plot);
        plot(results.time, results.speed, 'b', 'LineWidth', 1.5);
        hold on;
        plot(results.time, results.reference, 'r--', 'LineWidth', 1.5);
        ylabel('Speed (rad/s)');
        legend('Actual', 'Reference');
        grid on;
        title('Motor Speed');
        current_plot = current_plot + 1;
    end
    
    if config.plot.current
        subplot(plot_count, 1, current_plot);
        plot(results.time, results.current, 'g', 'LineWidth', 1.5);
        ylabel('Current (A)');
        grid on;
        title('Motor Current');
        current_plot = current_plot + 1;
    end
    
    if config.plot.torque
        subplot(plot_count, 1, current_plot);
        plot(results.time, results.torque, 'm', 'LineWidth', 1.5);
        ylabel('Torque (Nm)');
        grid on;
        title('Motor Torque');
        current_plot = current_plot + 1;
    end
    
    if config.plot.voltage
        subplot(plot_count, 1, current_plot);
        plot(results.time, results.voltage, 'k', 'LineWidth', 1.5);
        ylabel('Voltage (V)');
        xlabel('Time (s)');
        grid on;
        title('Applied Voltage');
    end
end

function save_results(results, config)
    % Save simulation results to file
    if ~exist(config.output.save_path, 'dir')
        mkdir(config.output.save_path);
    end
    
    timestamp = datestr(now, 'yyyymmdd_HHMMSS');
    filename = sprintf('%s%s%s_%s_%s.mat', config.output.save_path, ...
                      config.output.filename_prefix, config.motor_type, ...
                      config.control_method, timestamp);
    
    save(filename, 'results', 'config');
    fprintf('Results saved to: %s\n', filename);
end
