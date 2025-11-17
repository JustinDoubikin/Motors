# DC Geared Motor with Encoder Setup Guide

## Overview
This guide explains how to set up and use the DC geared motor (350 RPM with encoder) in the simulation framework, and how to transition to real hardware.

## Hardware Components

### Motor
- **Model**: 12V DC Motor 350RPM with Encoder (34:1 Gear Ratio)
- **Link**: https://core-electronics.com.au/12v-dc-motor-350rpm-w-encoder-12kg-cm.html
- **Specs**:
  - Voltage: 12V
  - Gear Ratio: 34:1
  - No-load Speed: 350 RPM @ 12V
  - No-load Current: 0.23A
  - Stall Torque: 12 kg-cm (1.2 Nm)
  - Stall Current: 5.5A
  - Max Efficiency Point: 2.0 kg-cm @ 285 RPM, 0.65A, 5.0W
  - Max Power Point: 5.8 kg-cm @ 180 RPM, 1.65A, 9.0W
  - Encoder: Hall feedback, 374 counts per revolution
  - Weight: 98g

### Motor Driver
- **Model**: Toshiba TB67H420FTG Dual/Single Brushed DC Motor Driver
- **Link**: https://www.pololu.com/product/2999
- **Specs**:
  - Voltage Range: 10V to 47V
  - Dual Channel Mode:
    - Continuous Current: 1.7A per channel
    - Peak Current: 4.5A per channel
  - Single Channel Mode:
    - Continuous Current: 3.4A
    - Peak Current: 9A
  - Current Chopping: Configurable (default 4.5A dual / 9A single)
  - Reverse Voltage Protection: Up to 40V
  - Protection: Under-voltage, over-current, over-temperature, open-load detection

### Current Sensor
- **Type**: ±5A Current Sensor with 400mV/A sensitivity
- **Output**: Analog voltage proportional to current

## File Structure

### 1. Motor Parameter File
**Location**: `Motors/DC/geared_motor_350rpm_params.m`

This file contains:
- Physical motor parameters (resistance, inductance, constants)
- Encoder specifications
- Driver limitations
- Current sensor specs
- Estimated parameters marked with [ESTIMATED]

**Usage**:
```matlab
params = geared_motor_350rpm_params();
```

### 2. Configuration File
**Location**: `Simulations/Configs/example_geared_motor_encoder.m`

This file:
- Loads motor parameters
- Configures PID controller
- Sets up encoder feedback
- Defines load and reference signals
- Enables current limiting

**Usage**:
```matlab
cd Simulations
run_simulation('Configs/example_geared_motor_encoder.m')
```

## Understanding the Approach

### Why Two Files?

1. **Motor Parameters File** (`Motors/DC/geared_motor_350rpm_params.m`)
   - Contains hardware-specific parameters
   - Reusable across different control strategies
   - Easy to update when doing system identification
   - Keeps motor specs separate from simulation config

2. **Configuration File** (`Simulations/Configs/example_geared_motor_encoder.m`)
   - Loads motor parameters
   - Defines control strategy (PID gains, limits)
   - Sets up simulation scenario (load, reference)
   - Multiple configs can use the same motor

### This Approach Allows:
- Same motor with different controllers (PID, state-space, etc.)
- Same motor with different test scenarios
- Easy parameter updates after system ID
- Clean separation of hardware specs and control design

## Parameter Estimation

### What's Estimated vs. Known

**Known (from datasheet)**:
- ✓ Rated voltage: 12V
- ✓ Gear ratio: 34:1
- ✓ No-load speed: 350 RPM @ 12V
- ✓ No-load current: 0.23A
- ✓ Stall torque: 12 kg-cm (1.2 Nm)
- ✓ Stall current: 5.5A
- ✓ Max efficiency point: 2.0 kg-cm @ 285 RPM, 0.65A, 5.0W
- ✓ Max power point: 5.8 kg-cm @ 180 RPM, 1.65A, 9.0W
- ✓ Encoder resolution: 374 counts per revolution
- ✓ Driver current limits: 1.7A cont. (dual) / 3.4A cont. (single)
- ✓ Current sensor sensitivity: 400mV/A

**Calculated (from known data)**:
- ⚠ Armature resistance (Ra): ~2.18 Ω (from stall test: V/I_stall)
- ⚠ Back EMF constant (Ke): ~0.314 V/(rad/s) (from no-load test)
- ⚠ Torque constant (Kt): ~0.314 Nm/A (equals Ke in SI units)

**Estimated (need system ID)**:
- ⚠ Armature inductance (La): 0.002 H (typical value)
- ⚠ Inertia (J): 6e-6 kg.m² (estimated from weight/size)
- ⚠ Damping (b): 0.0001 Nm.s/rad (typical for geared motors)

## System Identification Process

### Test 1: Resistance Measurement (Ra)
**Method**: Locked rotor test
```
1. Prevent motor shaft from rotating
2. Apply known low voltage (e.g., 1-2V)
3. Measure steady-state current
4. Calculate: Ra = V / I
```
**Expected**: Ra ≈ 2.18 Ω (calculated from stall current: 12V / 5.5A)

### Test 2: Back EMF Constant (Ke)
**Method**: No-load coast-down or no-load measurement
```
Option A - Coast-down:
1. Spin motor to known speed (use encoder)
2. Disconnect power, measure back EMF voltage
3. Calculate: Ke = V_emf / omega

Option B - No-load running:
1. Apply rated voltage (12V)
2. Measure no-load speed (encoder): should be ~350 RPM
3. Measure no-load current: should be ~0.23A
4. Calculate: Ke = (V - I_nl * Ra) / omega
```
**Expected**: Ke ≈ 0.314 V/(rad/s)

### Test 3: Inductance (La)
**Method**: Step voltage response
```
1. Apply voltage step
2. Measure current rise time
3. Use: La = V * Δt / ΔI (during initial rise)
```

### Test 4: Inertia and Damping (J, b)
**Method**: Free acceleration test
```
1. Apply constant voltage
2. Record speed vs time (encoder)
3. Fit to motor equations to extract J and b
```

### Test 5: Torque Constant (Kt)
**Method**: Loaded test
```
1. Apply known mechanical load
2. Measure steady-state current
3. Calculate: Kt = Torque_load / I_armature
```
Or verify: Kt = Ke (in SI units)

### Test 6: Encoder Verification
```
1. Rotate motor shaft exactly N full revolutions
2. Count encoder pulses
3. Verify: pulses = N * 374 (not 1336 as with typical quadrature)
```
**Note**: This encoder provides 374 counts per revolution (from Hall effect sensors),
not the typical quadrature encoding that gives 4x the base PPR.

### Test 7: Current Sensor Calibration
```
1. Zero current: Measure offset voltage
2. Known currents: Apply and measure output
3. Verify sensitivity: 400mV/A
```

## Using in Simulation

### Step 1: Run with Estimated Parameters
```matlab
cd Simulations
run_simulation('Configs/example_geared_motor_encoder.m')
```

This will:
- Simulate motor response with estimated parameters
- Show speed tracking, current draw, torque
- Display encoder counts
- Calculate performance metrics

### Step 2: Tune PID Controller
Adjust gains in config file:
```matlab
config.controller.Kp = 0.8;   % Increase for faster response
config.controller.Ki = 3.0;   % Increase to eliminate steady-state error
config.controller.Kd = 0.02;  % Increase to reduce overshoot
```

### Step 3: Test Different Scenarios
Modify reference and load:
```matlab
% Speed reference
config.reference.amplitude = motor_params.speed_rated * 0.5;  % 50% speed

% Load disturbance
config.load.type = 'step';
config.load.step_torque = 0.8;  % Heavy load
```

## Updating Parameters After System ID

Once you've performed system identification on the real hardware:

1. **Edit motor parameter file**: `Motors/DC/geared_motor_350rpm_params.m`
2. **Update estimated values** with measured ones
3. **Remove [ESTIMATED] tags** for verified parameters
4. **Re-run simulation** to validate

Example:
```matlab
% Before system ID:
params.Ra = 2.0;  % [ESTIMATED] Armature resistance (Ohm)

% After system ID (measured 2.3 Ω):
params.Ra = 2.3;  % Armature resistance (Ohm) - measured
```

## Creating Additional Configurations

### Example: Position Control
Create `Simulations/Configs/geared_motor_position.m`:
```matlab
motor_params = geared_motor_350rpm_params();
config.motor_type = 'DC';
config.control_method = 'PID';
% ... configure for position control instead of speed
config.reference.type = 'step';
config.reference.amplitude = 10 * 2*pi;  % 10 revolutions
```

### Example: Different PID Tuning
Create `Simulations/Configs/geared_motor_aggressive.m`:
```matlab
motor_params = geared_motor_350rpm_params();
% ... use more aggressive PID gains
config.controller.Kp = 1.5;
config.controller.Ki = 5.0;
config.controller.Kd = 0.05;
```

## Hardware Implementation Tips

### Encoder Reading
- Use quadrature decoding for 4x resolution (1336 CPR)
- Implement in hardware timer/counter for accuracy
- Check for noise on encoder signals

### Current Sensing
- Calibrate offset at zero current
- Use filtering for noisy measurements
- Implement over-current protection

### PWM Generation
- Typical frequency: 20-25 kHz
- Match simulation time step to control loop rate
- TB67H420FTG has built-in current chopping
- No dead-time needed (driver handles this)

### Safety Features
- Current limiting (1.7A continuous in dual mode, 3.4A in single mode)
- Peak current handling (4.5A dual, 9A single) for short durations
- Voltage limiting (up to 47V supported by driver)
- Thermal protection (driver will disable if overheating)
- Emergency stop
- Driver has built-in under-voltage, over-current, over-temperature protection

## Troubleshooting

### Simulation doesn't run
- Check MATLAB path includes all directories
- Verify motor_params function is accessible
- Check for syntax errors in config file

### Poor performance in simulation
- Tune PID gains using Ziegler-Nichols or manual tuning
- Check reference signal is achievable
- Verify load torque is within motor capability

### Parameters seem wrong
- Run system identification tests
- Update parameter file with measured values
- Compare simulation to real hardware response

## Summary

**For simulation**: Use the configuration file to test control strategies with estimated parameters.

**For hardware**: Perform system identification, update the motor parameter file, then use the same configuration files with real parameters.

**Best practice**: Keep motor parameters separate from simulation configs to enable reuse and easy updates.
