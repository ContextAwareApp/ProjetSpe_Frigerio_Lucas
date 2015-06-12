function [all_theta] = oneVsAll(X, y, num_labels, lambda)

% Training the parameters to be used in logistic regression using a data set.

% Our objective here is to create as many classifiers as we have classes.
% Each classifier will then detect one activity and associate to an exemple the probability that he might belong to 
% the class. We then decide that an exemple belongs to the most likely class.

% Therefor ONEVSALL trains multiple logistic regression classifiers.
% It returns all the classifiers in a matrix (called all_theta, here a classifier is identified to its parameters) 

% Each row of all_theta contains the parameters of one classifier, used to compute the result.
% the i-th row corresponds too the i-th classifier.


% size of our data.
m = size(X, 1); %number of lines ie number of exemple in the training set.
fprintf('\nYour training set contains %f exemples \n\n',m);
n = size(X, 2); %number of colums ie number of features describing the experiment.
fprintf('\nThere are %f features describing each exemple in your training set\n\n',n);

CLASS_NUMBER = 2;

% all_will contain the parameters that the regression will determine.
% each line corresponds to a classifier, so there are num_labels lines (the number of classes)
% there are n+1 colums : number of features + 1 (for the bias/intercept/mean/constant, call it what you like)
all_theta = zeros(num_labels, n + 1); 

% Add ones to the X data matrix. This allows us to include the biais in the formula.
X = [ones(m, 1) X];

%               Here we are using logistic regression classifiers with regularization
%               parameter lambda. 
%
% Note that  theta(:) transforms theta into a column vector.
%
% Note that  y == c gives us a vector of 1's and 0's that tells us 
%       whether the ground truth is true/false for this class.
%
% Note that we will use fmincg to optimize the cost
%       function. We may also use a for-loop (for c = 1:num_labels) to
%       loop over the different classes. We usually vectorize code but
%	here there is not too many classes and this will be much clearer than making 3D matrix/ 
%	faking 3D matrix with complicated indexes.
%       fmincg works similarly to fminunc, but is more efficient when we
%       are dealing with large number of parameters, code is included 
%       (Open-source Copyright by Carl Edward Rasmussen)
%

initial_theta = zeros(n + 1, 1);
options = optimset('GradObj', 'on', 'MaxIter', 100); %just to make the call to fmincg easier to read
for i=1:CLASS_NUMBER
	[theta] = ...
	fmincg (@(t)(lrCostFunction(t, X, (y == i), lambda)), ...
		initial_theta, options);
	all_theta(i,:) = theta;
endfor	
% =========================================================================


end
