function g = sigmoidGradient(z)
%SIGMOIDGRADIENT returns the gradient of the sigmoid function
%evaluated at z
%   g = SIGMOIDGRADIENT(z) computes the gradient of the sigmoid function
%   evaluated at z. This works regardless of wether z is a matrix or a
%   vector. If z is a vector or matrix, we return
%   the gradient for each element.

g = zeros(size(z));

% Instructions: Compute the gradient of the sigmoid function evaluated at
%               each value of z (z can be a matrix, vector or scalar).
a = sigmoid(z);
g = a.*(1.-a);
% =============================================================
end
