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
    
    fprintf('Starting simulation...\n');
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
        results.voltage(i-1) = simple_pi_control(error, config.controller);
        
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
            ref = config.reference.amplitude * sin(2*pi*t);
        otherwise
            ref = zeros(size(t));
    end
end

function voltage = simple_pi_control(error, controller)
    % Simple PI controller (placeholder)
    % In actual implementation, this will be replaced with proper controller
    persistent integral;
    if isempty(integral)
        integral = 0;
    end
    
    integral = integral + error;
    voltage = controller.Kp * error + controller.Ki * integral;
    
    % Saturation
    voltage = max(min(voltage, controller.output_limit), -controller.output_limit);
end

function [speed, current, torque, position] = update_motor_state(speed_prev, current_prev, voltage, config, dt)
    % Simple DC motor model (placeholder)
    % In actual implementation, this will call appropriate motor model
    
    % Simple first-order approximations
    current = current_prev + (voltage - config.motor.Ke * speed_prev - config.motor.Ra * current_prev) * dt / config.motor.La;
    torque = config.motor.Kt * current - config.load.torque;
    speed = speed_prev + (torque - config.motor.b * speed_prev) * dt / config.motor.J;
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
