function [a, b, c] = inverse_clarke_transform(alpha, beta)
% INVERSE_CLARKE_TRANSFORM - Inverse Clarke transformation (αβ to abc)
%
% Converts two-phase stationary frame back to three-phase variables
%
% Inputs:
%   alpha, beta - Two-phase stationary frame variables
%
% Outputs:
%   a, b, c - Three-phase variables
%
% Transformation matrix:
%   [a]   [    1         0    ] [α]
%   [b] = [ -1/2      √3/2    ] [β]
%   [c]   [ -1/2     -√3/2    ]

    a = alpha;
    b = -0.5 * alpha + (sqrt(3)/2) * beta;
    c = -0.5 * alpha - (sqrt(3)/2) * beta;
end
