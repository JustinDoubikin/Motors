# Scalar Control (V/f Control)

This directory contains Scalar Control implementations for motor control.

## Applications
- Simple induction motor speed control
- Open-loop control applications

## Controller Files
Place your Scalar Control implementations (.m, .slx) here.

## Principle
- Maintains constant voltage-to-frequency ratio (V/f)
- Open-loop speed control
- No rotor position feedback required

## Parameters
- Base frequency
- Base voltage
- Boost voltage (for low speed)
- Acceleration/deceleration ramps

## Limitations
- Limited torque at low speeds
- No precise speed regulation
- Slower dynamic response
