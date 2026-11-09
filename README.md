# DC Motor Speed Control System

## Project Overview

This project focuses on the experimental characterization, modelling and speed control of a DC motor, developed as part of the Systems and Control course at the University of Aveiro.

The work involved determining the input voltage required to achieve specific motor speeds, analysing the motor's dynamic response to input perturbations, and identifying a mathematical transfer function to approximate its behaviour.

## Project Objectives

- Determine the voltage required to achieve reference speeds of 600 rpm and 1200 rpm.
- Analyse the motor's dynamic response around an operating point of approximately 900 rpm.
- Apply sinusoidal and step input perturbations.
- Identify a third-order transfer function model based on the experimental response.
- Validate the mathematical model by comparing simulated and experimental results.

## Experimental Setup

The experimental setup consisted of a DC motor speed control system, including:

- DC motor and rotational shaft.
- Slotted disk.
- DC generator.
- Optical speed sensor.
- Safety cover.

The optical sensor was used to measure the motor's rotational speed during the experiments.

## Experimental Procedure and Results

### 1. Steady-State Speed Control

An iterative voltage adjustment algorithm was implemented to determine the voltage required to reach the reference speeds.

The algorithm measured the motor speed after allowing the system to stabilize and adjusted the input voltage until the speed error was within ±5 rpm.

| Reference Speed | Experimental Voltage | Measured Speed |
|---|---:|---:|
| 600 rpm | 1.060 V | 600.0 rpm |
| 1200 rpm | 1.735 V | 1200.9 rpm |

### 2. Dynamic Response Analysis

The motor was analysed around an operating point of approximately 900 rpm, using an input voltage of approximately 1.45 V.

A sinusoidal voltage perturbation was applied:

\[
\Delta V(t)=0.32\sin(2\pi \cdot 0.05t)
\]

The experimental response showed amplitude attenuation and a phase lag relative to the input signal.

A step perturbation of 0.25 V was also applied after 5 seconds, allowing the transient response of the motor to be analysed.

### 3. Transfer Function Identification

A third-order transfer function was developed to approximate the motor's dynamic behaviour:

\[
G(s)=\frac{K}{(\tau_e^2s^2+2\tau_es+1)(\tau_ms+1)}
\]

The identified parameters were:

| Parameter | Value |
|---|---:|
| Gain (K) | 903.0210 |
| Electrical time constant (\(\tau_e\)) | 0.0100 s |
| Mechanical time constant (\(\tau_m\)) | 0.0500 s |

The model contains a repeated electrical pole at -100 and a mechanical pole at -20.

### 4. Model Validation

The identified transfer function was used to simulate the motor's response to sinusoidal and step input perturbations.

The simulated responses were compared with the experimental measurements to evaluate how well the mathematical model represented the real motor dynamics.

## Tools and Technologies

- MATLAB
- System Identification
- Transfer Functions
- Dynamic System Modelling
- Experimental Data Analysis
- DC Motor Control

## Project Files

- MATLAB script containing the implementation and experimental analysis.
- Project presentation (PDF).

## Project Information

- **Project:** RT050 – Speed Control System of a Motor
- **Course:** Systems and Control
- **Institution:** University of Aveiro – DETI
- **Academic Year:** 2025/2026

## Authors

- Adriana Pires (113223)
- Inês Ferreira (114164)
