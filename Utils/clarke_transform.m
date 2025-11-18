function [alpha, beta] = clarke_transform(a, b, c)
% CLARKE_TRANSFORM - Clarke transformation (abc to αβ)
%
% Converts three-phase variables to two-phase stationary reference frame
%
% Inputs:
%   a, b, c - Three-phase variables (currents or voltages)
%
% Outputs:
%   alpha, beta - Two-phase stationary frame variables
%
% Transformation matrix:
%   [α]   2/3 * [ 1    -1/2   -1/2  ] [a]
%   [β] =       [ 0  √3/2   -√3/2  ] [b]
%                                      [c]

    alpha = (2/3) * (a - 0.5*b - 0.5*c);
    beta = (2/3) * (sqrt(3)/2 * b - sqrt(3)/2 * c);
end
