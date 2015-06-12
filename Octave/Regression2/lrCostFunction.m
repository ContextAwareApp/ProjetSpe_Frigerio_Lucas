function [J, grad] = lrCostFunction(theta, X, y, lambda)

% Cost function and gradient computed for the logistic regression

% -------- Content :
% This file computes an "oracle" that returns two things : the value of 
% a multivariate function, and a gradient. These are typically used 
% for gradient descent which allows one to maximize a function.
% The intuitive idea is that gradient gives the direction in wich the slope
% is maximum.

% -------- Output:
%LRCOSTFUNCTION computes cost and gradient for logistic regression with 
%regularization
%   J = LRCOSTFUNCTION(theta, X, y, lambda) computes the cost of using
%   theta as the parameter for regularized logistic regression and the
%   gradient of the cost w.r.t. to the parameters. 

% Get constants
m = length(y); % number of exemples contained in the training set

% The variables that we will return
J = 0;
grad = zeros(size(theta));

% We will first compute the cost of a particular choice of theta.
% Result stored in J

% We then Compute the partial derivatives and set grad to the partial
% derivatives of the cost with respect to each parameter in theta
%
% Note that the computation of the cost function and gradients is
% vectorized. This is much more efficient than using loops. This makes for shorter code
% but one has to spend time understanding the notations.
%
% Finally one should note that we ARE using a regularization parameter here

%To check these two lines, one should write them by hand : X is a matrix, theta and y a vecto, and it is extremely easy 
%to make mistakes in the order of the product, or forgetting to transpose... and sometimes mistakes can go unnoticed.
%Also note that the regularization term is included in both the cost function and the gradient.

J = (1/m)*sum( -y .* log(sigmoid(X*theta) ) -(1 .- y) .*log(1 - sigmoid(X*theta) )) + (lambda/(2*m))*(theta'*theta - theta(1)^2);
grad = ((1/m)*( ( sigmoid(X*theta) .- y )' * X)') .+ (lambda/m).*([0;theta(2:(length(theta)))]); 

% =============================================================

%Turn grad to a vector and return
grad = grad(:);

end
