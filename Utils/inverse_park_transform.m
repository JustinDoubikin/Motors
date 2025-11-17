function [alpha, beta] = inverse_park_transform(d, q, theta)
% INVERSE_PARK_TRANSFORM - Inverse Park transformation (dq to αβ)
%
% Converts two-phase rotating frame back to stationary reference frame
%
% Inputs:
%   d, q - Two-phase rotating frame variables
%   theta - Rotor electrical angle (radians)
%
% Outputs:
%   alpha, beta - Two-phase stationary frame variables
%
% Transformation matrix:
%   [α]   [cos(θ)  -sin(θ)] [d]
%   [β] = [sin(θ)   cos(θ)] [q]

    alpha = d * cos(theta) - q * sin(theta);
    beta = d * sin(theta) + q * cos(theta);
end
