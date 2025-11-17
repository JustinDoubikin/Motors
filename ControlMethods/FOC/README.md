# Field-Oriented Control (FOC)

This directory contains Field-Oriented Control implementations for AC motor control.

## Applications
- PMSM control
- Induction motor control
- BLDC motor control

## Controller Files
Place your FOC controller implementations (.m, .slx) here.

## Components
- Clarke transformation (abc to αβ)
- Park transformation (αβ to dq)
- Current controllers (PI for id and iq)
- Space vector modulation (SVM)
- PWM generation

## Requirements
- Rotor position feedback (encoder/resolver)
- Current sensing (2 or 3 phase)
