# Motor Control Simulation Framework - Documentation

## Overview
This is a MATLAB-based framework for simulating different types of motors with various control methods. The framework is designed to be modular and extensible, allowing easy addition of new motor types and control strategies.

## Directory Structure

```
Motors/
├── Motors/                    # Motor model implementations
│   ├── DC/                   # DC motor models
│   ├── BLDC/                 # Brushless DC motor models
│   ├── Stepper/              # Stepper motor models
│   ├── Induction/            # Induction motor models
│   └── PMSM/                 # Permanent Magnet Synchronous Motor models
│
├── ControlMethods/           # Control algorithm implementations
│   ├── PID/                  # PID control
│   ├── FOC/                  # Field-Oriented Control
│   ├── DTC/                  # Direct Torque Control
│   ├── VectorControl/        # Vector Control
│   └── ScalarControl/        # Scalar (V/f) Control
│
├── Simulations/              # Simulation scripts and configurations
│   ├── Configs/              # Configuration files
│   │   ├── config_template.m        # Template for new configurations
│   │   ├── example_dc_pid.m         # DC motor with PID example
│   │   ├── example_pmsm_foc.m       # PMSM with FOC example
│   │   └── example_induction_vf.m   # Induction motor with V/f example
│   ├── Results/              # Simulation results (auto-generated)
│   └── run_simulation.m      # Main simulation runner
│
├── Utils/                    # Utility functions
│   ├── clarke_transform.m
│   ├── park_transform.m
│   ├── inverse_clarke_transform.m
│   ├── inverse_park_transform.m
│   └── space_vector_modulation.m
│
└── Docs/                     # Documentation
    └── USAGE.md              # This file
```

## Getting Started

### 1. Setting Up a New Simulation

There are two ways to set up a simulation:

#### Option A: Use an Example Configuration
```matlab
cd Simulations
run_simulation('Configs/example_dc_pid.m')
```

#### Option B: Create Your Own Configuration
1. Copy the template:
   ```matlab
   copyfile('Configs/config_template.m', 'Configs/my_simulation.m')
   ```
2. Edit `my_simulation.m` with your parameters
3. Run the simulation:
   ```matlab
   run_simulation('Configs/my_simulation.m')
   ```

### 2. Configuration File Structure

A configuration file contains all parameters needed for simulation:

```matlab
% Motor Selection
config.motor_type = 'DC';  % Choose motor type

% Control Method
config.control_method = 'PID';  % Choose control method

% Simulation Parameters
config.sim_time = 10;      % Total simulation time
config.time_step = 1e-4;   % Integration time step

% Motor Parameters
config.motor.Ra = 1.0;     % Motor-specific parameters
% ... (varies by motor type)

% Controller Parameters
config.controller.Kp = 10; % Controller-specific parameters
% ... (varies by control method)

% Load and Reference Settings
config.load.type = 'constant';
config.reference.type = 'step';

% Output Options
config.output.save_results = true;
config.output.plot_results = true;
```

## Motor Types

### DC Motors
- **File Location**: `Motors/DC/`
- **Parameters**: Ra, La, Ke, Kt, J, b
- **Applications**: Simple speed/position control, servo applications

### BLDC Motors
- **File Location**: `Motors/BLDC/`
- **Parameters**: Rs, Ls, Ke, pole pairs, J, b
- **Applications**: High-efficiency applications, drones, EVs

### Stepper Motors
- **File Location**: `Motors/Stepper/`
- **Parameters**: R, L, steps per revolution, torque constants
- **Applications**: Positioning, 3D printers, CNC machines

### Induction Motors
- **File Location**: `Motors/Induction/`
- **Parameters**: Rs, Rr, Ls, Lr, Lm, pole pairs, J
- **Applications**: Industrial drives, pumps, fans

### PMSM (Permanent Magnet Synchronous Motors)
- **File Location**: `Motors/PMSM/`
- **Parameters**: Rs, Ld, Lq, flux linkage, pole pairs, J, b
- **Applications**: High-performance servo drives, EVs, robotics

## Control Methods

### PID Control
- **File Location**: `ControlMethods/PID/`
- **Best For**: DC motors, simple speed/position control
- **Parameters**: Kp, Ki, Kd
- **Tuning**: Ziegler-Nichols, trial-and-error

### Field-Oriented Control (FOC)
- **File Location**: `ControlMethods/FOC/`
- **Best For**: PMSM, BLDC, high-performance induction motors
- **Features**: Decoupled torque and flux control
- **Requirements**: Rotor position feedback

### Direct Torque Control (DTC)
- **File Location**: `ControlMethods/DTC/`
- **Best For**: Induction motors, PMSM
- **Features**: Fast torque response, no PWM modulator
- **Advantages**: Simple implementation, robust

### Vector Control
- **File Location**: `ControlMethods/VectorControl/`
- **Best For**: AC motors requiring precise control
- **Features**: Similar to FOC with various flux orientation options

### Scalar Control (V/f)
- **File Location**: `ControlMethods/ScalarControl/`
- **Best For**: Induction motors in simple applications
- **Features**: Open-loop, constant V/f ratio
- **Advantages**: Simple, no feedback required

## Utility Functions

### Coordinate Transformations

#### Clarke Transform (abc → αβ)
```matlab
[alpha, beta] = clarke_transform(a, b, c)
```
Converts three-phase quantities to two-phase stationary frame.

#### Park Transform (αβ → dq)
```matlab
[d, q] = park_transform(alpha, beta, theta)
```
Converts stationary frame to rotating reference frame.

#### Inverse Transforms
```matlab
[alpha, beta] = inverse_park_transform(d, q, theta)
[a, b, c] = inverse_clarke_transform(alpha, beta)
```

### Space Vector Modulation
```matlab
[Sa, Sb, Sc] = space_vector_modulation(Valpha, Vbeta, Vdc)
```
Generates PWM duty cycles using space vector modulation.

## Extending the Framework

### Adding a New Motor Type

1. Create a new directory: `Motors/NewMotorType/`
2. Create a README.md describing the motor
3. Implement motor model as MATLAB function or Simulink model
4. Add motor-specific parameters to configuration template

### Adding a New Control Method

1. Create a new directory: `ControlMethods/NewMethod/`
2. Create a README.md describing the control method
3. Implement controller as MATLAB function or Simulink model
4. Add controller-specific parameters to configuration template

### Adding Custom Analysis

Simulation results are stored in the `results` structure:
- `results.time` - Time vector
- `results.speed` - Motor speed
- `results.current` - Motor current
- `results.torque` - Motor torque
- `results.voltage` - Applied voltage
- `results.position` - Rotor position

You can add custom post-processing in the `plot_results()` or `save_results()` functions.

## Best Practices

1. **Start with examples**: Begin with provided example configurations
2. **Incremental changes**: Change one parameter at a time
3. **Save configurations**: Keep working configurations for future reference
4. **Document modifications**: Add comments to custom configurations
5. **Check stability**: Ensure time step is small enough for accuracy
6. **Validate results**: Compare with expected behavior or known data

## Troubleshooting

### Simulation is unstable
- Reduce time step (`config.time_step`)
- Check controller gains (may be too high)
- Verify motor parameters are realistic

### Results don't match expectations
- Check reference signal type and amplitude
- Verify load parameters
- Review controller saturation limits
- Ensure units are consistent

### Simulation is too slow
- Increase time step (if stability allows)
- Reduce simulation time
- Optimize MATLAB code
- Use compiled Simulink models

## References

1. Krishnan, R. (2001). *Electric Motor Drives: Modeling, Analysis, and Control*
2. Bose, B. K. (2002). *Modern Power Electronics and AC Drives*
3. Vas, P. (1998). *Sensorless Vector and Direct Torque Control*

## Support

For issues or questions:
1. Check documentation in each subdirectory
2. Review example configurations
3. Consult MATLAB documentation for specific functions
4. Check motor drive literature for control theory

---
*Last Updated: 2025*
