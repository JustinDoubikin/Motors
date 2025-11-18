# Quick Start Guide

## Running Your First Simulation

### Step 1: Open MATLAB
Navigate to the `Simulations` directory:
```matlab
cd Simulations
```

### Step 2: Run an Example
Try the DC motor with PID control example:
```matlab
run_simulation('Configs/example_dc_pid.m')
```

This will:
1. Load the DC motor parameters
2. Configure a PID speed controller
3. Run a 10-second simulation
4. Display plots of speed, current, torque, and voltage
5. Save results to `Results/` directory

### Step 3: Explore Other Examples

Try PMSM with Field-Oriented Control:
```matlab
run_simulation('Configs/example_pmsm_foc.m')
```

Try Induction Motor with V/f Control:
```matlab
run_simulation('Configs/example_induction_vf.m')
```

### Step 4: Create Your Own Configuration

1. Copy the template:
```matlab
copyfile('Configs/config_template.m', 'Configs/my_first_sim.m')
```

2. Open and edit `Configs/my_first_sim.m` in MATLAB editor

3. Modify parameters like:
   - `config.motor_type` - Choose your motor
   - `config.control_method` - Choose your control strategy
   - Motor parameters (resistance, inductance, etc.)
   - Controller gains (Kp, Ki, Kd)
   - Reference signal (step, ramp, sine)

4. Run your simulation:
```matlab
run_simulation('Configs/my_first_sim.m')
```

## Understanding the Results

### Plots Generated
- **Speed Plot**: Shows actual speed vs reference
- **Current Plot**: Motor current over time
- **Torque Plot**: Electromagnetic torque
- **Voltage Plot**: Applied voltage to motor

### Saved Results
Results are automatically saved to `Results/` with timestamp:
- Filename format: `sim_MotorType_ControlMethod_timestamp.mat`
- Contains both results data and configuration

## What to Try Next

1. **Experiment with Controller Gains**
   - Increase Kp for faster response
   - Add Ki to eliminate steady-state error
   - Add Kd to reduce overshoot

2. **Change Reference Signals**
   - Try ramp input for gradual acceleration
   - Try sine wave for periodic motion

3. **Add Load Disturbances**
   - Use step load to test disturbance rejection
   - Try different load types (constant, linear, quadratic)

4. **Compare Control Methods**
   - Run same motor with different controllers
   - Compare response time, overshoot, steady-state error

## Tips for Success

- Start with small simulation times (1-5 seconds) for quick iterations
- Check that time_step is appropriate (usually 1e-4 to 1e-5)
- Verify controller output doesn't saturate excessively
- Use reasonable reference values (check motor ratings)

## Common Issues

**Simulation runs too slow**
- Increase time_step (but watch for instability)
- Reduce sim_time

**Results look unstable**
- Decrease time_step
- Reduce controller gains
- Check motor parameters are realistic

**No output plots appear**
- Make sure `config.output.plot_results = true`
- Check MATLAB figure windows aren't minimized

## Next Steps

Once comfortable with basic simulations:
1. Read full documentation in `Docs/USAGE.md`
2. Implement your own motor models
3. Design custom controllers
4. Add new sensing methods
5. Integrate with Simulink for more complex systems

Happy simulating!
