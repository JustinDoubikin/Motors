# Project File Index

## Overview
This document provides a complete index of all files in the Motor Control Simulation Framework.

## Documentation Files (4 files)

### Root Documentation
- `README.md` - Main project overview and quick start
- `.gitignore` - Git ignore patterns for MATLAB and temporary files

### Docs Directory
- `Docs/QUICKSTART.md` - Step-by-step guide for first simulation
- `Docs/USAGE.md` - Comprehensive usage documentation
- `Docs/ARCHITECTURE.md` - System architecture and design philosophy

## Motor Models (5 directories)

Each motor type has a dedicated directory with README documentation:

- `Motors/DC/README.md` - DC motor models and parameters
- `Motors/BLDC/README.md` - Brushless DC motor models
- `Motors/Stepper/README.md` - Stepper motor models
- `Motors/Induction/README.md` - Induction motor models
- `Motors/PMSM/README.md` - Permanent Magnet Synchronous Motor models

## Control Methods (5 directories)

Each control strategy has documentation:

- `ControlMethods/PID/README.md` - PID control implementation
- `ControlMethods/FOC/README.md` - Field-Oriented Control
- `ControlMethods/DTC/README.md` - Direct Torque Control
- `ControlMethods/VectorControl/README.md` - Vector control methods
- `ControlMethods/ScalarControl/README.md` - Scalar V/f control

## Simulation Files (5 files)

### Main Simulation Engine
- `Simulations/run_simulation.m` - Main simulation runner function

### Configuration Files
- `Simulations/Configs/config_template.m` - Template for new simulations
- `Simulations/Configs/example_dc_pid.m` - DC motor with PID example
- `Simulations/Configs/example_pmsm_foc.m` - PMSM with FOC example
- `Simulations/Configs/example_induction_vf.m` - Induction with V/f example

### Results Directory
- `Simulations/Results/` - Auto-generated simulation results (.mat, .fig, .png)

## Utility Functions (5 files)

### Coordinate Transformations
- `Utils/clarke_transform.m` - abc to αβ transformation
- `Utils/park_transform.m` - αβ to dq transformation
- `Utils/inverse_park_transform.m` - dq to αβ transformation
- `Utils/inverse_clarke_transform.m` - αβ to abc transformation

### PWM Generation
- `Utils/space_vector_modulation.m` - Space vector modulation for inverters

## File Count Summary

- **Total Directories**: 18
  - Motor types: 5
  - Control methods: 5
  - Simulation: 2 (Configs, Results)
  - Utils: 1
  - Docs: 1

- **Total Files**: 24
  - Documentation (README.md): 12
  - MATLAB Code (.m): 9
  - Configuration files (.m): 4
  - Root files: 2 (README.md, .gitignore)
  - Documentation guides (.md): 3

## Usage Workflow

1. **Start Here**: `README.md`
2. **Learn**: `Docs/QUICKSTART.md`
3. **Run**: `Simulations/run_simulation.m`
4. **Configure**: `Simulations/Configs/config_template.m`
5. **Explore**: Motor and Control method READMEs
6. **Extend**: `Docs/ARCHITECTURE.md`

## Quick Access Paths

### For Users
- Quick start: `Docs/QUICKSTART.md`
- Run first simulation: `Simulations/run_simulation.m`
- Example configs: `Simulations/Configs/example_*.m`

### For Developers
- Architecture: `Docs/ARCHITECTURE.md`
- Add motor: `Motors/[NewType]/`
- Add controller: `ControlMethods/[NewMethod]/`
- Utilities: `Utils/`

### For Learning
- Motor theory: `Motors/[MotorType]/README.md`
- Control theory: `ControlMethods/[Method]/README.md`
- Complete guide: `Docs/USAGE.md`

## File Dependencies

```
run_simulation.m
├── Requires: config file from Configs/
├── Uses: Motor models from Motors/
├── Uses: Controllers from ControlMethods/
└── Uses: Utilities from Utils/
```

## Version Information

- **Created**: 2025-11-17
- **Framework Version**: 1.0
- **MATLAB Compatibility**: R2018a or later
- **Status**: Initial release - Ready for use and extension

---

*This index is automatically generated based on the current project structure*
