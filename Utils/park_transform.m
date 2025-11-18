function [d, q] = park_transform(alpha, beta, theta)
% PARK_TRANSFORM - Park transformation (αβ to dq)
%
% Converts two-phase stationary frame to two-phase rotating reference frame
%
% Inputs:
%   alpha, beta - Two-phase stationary frame variables
%   theta - Rotor electrical angle (radians)
%
% Outputs:
%   d, q - Two-phase rotating frame variables (direct and quadrature)
%
% Transformation matrix:
%   [d]   [ cos(θ)   sin(θ) ] [α]
%   [q] = [-sin(θ)   cos(θ) ] [β]

    d = alpha * cos(theta) + beta * sin(theta);
    q = -alpha * sin(theta) + beta * cos(theta);
end
