# Motors - Motor Control Simulation Framework

This repository contains a MATLAB-based framework for simulating different types of motors with various control methods. The goal is to build confidence and expertise in setting up control systems for any motor type with different sensing methods.

## Quick Start

```matlab
cd Simulations
run_simulation('Configs/example_dc_pid.m')
```

## Features

- **Multiple Motor Types**: DC, BLDC, Stepper, Induction, PMSM
- **Various Control Methods**: PID, FOC, DTC, Vector Control, Scalar V/f Control
- **Modular Design**: Easy to add new motors and control strategies
- **Utility Functions**: Coordinate transformations, PWM generation, and more
- **Example Configurations**: Ready-to-use simulation setups

## Project Structure

```
Motors/
├── Motors/              # Motor model implementations (DC, BLDC, Stepper, Induction, PMSM)
├── ControlMethods/      # Control algorithms (PID, FOC, DTC, Vector, Scalar)
├── Simulations/         # Simulation scripts and configurations
│   ├── Configs/        # Configuration files and examples
│   ├── Results/        # Simulation results (auto-generated)
│   └── run_simulation.m # Main simulation runner
├── Utils/              # Utility functions (transformations, modulation, etc.)
└── Docs/               # Documentation
```

## Supported Motor Types

1. **DC Motors** - Brushed DC motors with armature control
2. **BLDC Motors** - Brushless DC motors for high-efficiency applications
3. **Stepper Motors** - Precise positioning applications
4. **Induction Motors** - Industrial workhorse motors
5. **PMSM** - Permanent Magnet Synchronous Motors for servo drives

## Supported Control Methods

1. **PID Control** - Classic proportional-integral-derivative control
2. **Field-Oriented Control (FOC)** - Advanced control for AC motors
3. **Direct Torque Control (DTC)** - Fast torque response control
4. **Vector Control** - Decoupled flux and torque control
5. **Scalar Control (V/f)** - Simple open-loop speed control

## Getting Started

1. Navigate to the Simulations directory
2. Choose an example configuration or create your own based on `config_template.m`
3. Run the simulation using `run_simulation('Configs/your_config.m')`
4. View results in plots and saved MAT files

### Example Simulations

- **DC Motor with PID**: `example_dc_pid.m` - Speed control of brushed DC motor
- **PMSM with FOC**: `example_pmsm_foc.m` - Field-oriented control of PMSM
- **Induction Motor with V/f**: `example_induction_vf.m` - Scalar control of induction motor

## Documentation

For detailed documentation, see [Docs/USAGE.md](Docs/USAGE.md)

- Configuration file structure
- Motor parameters
- Controller tuning
- Extending the framework
- Troubleshooting

## Requirements

- MATLAB (R2018a or later recommended)
- Control System Toolbox (optional, for advanced features)
- Simulink (optional, for block diagram models)

## Next Steps

This framework provides a foundation for:
- Learning motor control principles
- Testing control algorithms
- Comparing different control strategies
- Developing custom motor models
- Prototyping control systems before hardware implementation

## License

This project is for educational and research purposes. 
