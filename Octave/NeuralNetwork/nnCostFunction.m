function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)

% What does this file contain?
% This file computes an "oracle" that returns two things : the value of 
% a multivariate function, and a gradient. These are typically used 
% for gradient descent which allows one to maximize a function.
% The intuitive idea is that gradient gives the direction in wich the slope
% is maximum, so to minimize the function one should follow the opposite direction.

% This is usefull to solve our problem because given a model, we are trying to learn the parameters that best predict
% classification. Once we have chosen a cost function that measures how wrong our predictions are, we will minimize it and
% will choose the corresponding parameters. Gradient descent allows just that.

%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification

%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network.
%   Cost is computed using the resulting predictions one gets when applying the model.
%   Output :
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad is also an "unrolled" vector.
%

% As in classical OneVsAll classification, we decide to store parameters in matrices.
% Here we will create one matrix for each layer of our network.
% Each line of a given matrix will be the parameters used by one neuron. (Same as with different classifiers in 
% OneVsAll classification.


% First, we reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network.
% Reshape takes : a vector, number of lines in the reshaped matrix, number of elements per line
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1)); %so we have hidden_layer_size lines (number of neurons in hidden layer)
		 %with input_layer_size + 1 elements per line (number of features + bias)

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1)); %On the last layer, each neuron computes a score for a class, so num_labels neurons

% Setup constants
m = size(X, 1);
         
% These are the parameters returned by the program.
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% Computation of the cost
% 	  The Thetas given to this function are used to Feedforward 
%	  the neural network and return the cost in the
%         variable J. 
%
% Computation of the gradient
% 	  Theta1_grad and Theta2_grad are computed using the backpropagation algorithm. 
%         Partial derivatives of the cost function with respect to Theta1 are returned in Theta1_grad
%         Those with respect to Theta2 are returned in Theta2_grad. 
%
%         NB : Vector y passed into the function is a vector of labels
%               containing values from 1..K. It is mapped into a 
%               binary vector of 1's and 0's to compute the cost function.
%
%         	We implemented backpropagation using a for-loop
%               over the training examples. Usually we prefer vectorizing computations
%		but here this would be more complicated than usual.
%
%	  NB : These computations include a regularization term (Which is used to avoid overfitting)
%	       For the gradient, the regularization term is computed separately (gradient of a sum is the sum of gradients)
%


%Mapping of Y, old version
%Y = zeros(length(y),10);
%for i=1:length(y)
%	Y(i,:) = [1:10];
%endfor
%Y = (Y==y); %This maps Y

%Mapping of Y, new version : 
Y = eye(num_labels)(y,:);
Y2 = eye(num_labels)(y,:);

X = [ones(m, 1) X];
H = sigmoid([ones(m,1) sigmoid(X * Theta1')] * Theta2');
H = H(:);
Y = Y(:);
J= (1/m)*(- log(H')*Y -log(1.-H')*(1.-Y)) + (lambda/(2*m))*(sum(sumsq(Theta1')) + sum(sumsq(Theta2')) - sumsq(Theta2'(1,:)) -sumsq(Theta1'(1,:)) );
%[trash,p]=max( sigmoid((sigmoid([ones(m,1) (X * Theta1')]) * Theta2')), [],2);


%BackwardsPropagation
DELTA2 =zeros(num_labels,hidden_layer_size +1);
DELTA =zeros(hidden_layer_size,input_layer_size+1);
for t=1:m %We iterate on all the training set.
	a = X(t,:);
	a = a';
	z2 = Theta1 * a;
	a2 = [1;sigmoid(z2)];
	z3 = Theta2 * a2;
	a3 = sigmoid(z3);

	delta3 = a3 - Y2(t,:)';
	delta2 = (Theta2(:,2:end)'*delta3) .* sigmoidGradient(z2); 
	%delta1 = (Theta1'*delta2) .* sigmoidGradient(z2); 
	%delta2 = delta2(2:end);
	DELTA = DELTA + delta2*(a');
	DELTA2 = DELTA2 + delta3*(a2');
	%H = sigmoid([ones(m,1) sigmoid(X * Theta1')] * Theta2');
endfor

% normalize, add the gradient
Theta1_grad = (1/m)*DELTA;
Theta2_grad = (1/m)*DELTA2;
Theta1_grad = Theta1_grad + (lambda/m)*([zeros(length(Theta1(:,1)),1) Theta1(:,2:(end)) ])  ;
Theta2_grad = Theta2_grad + (lambda/m)*([zeros(length(Theta2(:,1)),1) Theta2(:,2:(end)) ])  ;


% =========================================================================

% Unroll gradients and return
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
