function p = predictOneVsAll(all_theta, X)

% Given parameters (all_theta) this function classifies exemples contained in X.
% Here our goal is to use the parameters contain in all_theta to compute the probability
% that exemples contained in X belong to each class, and then we will associate each exemple to 
% it's most likely class.
% Each line of the matrix all_theta correspond to a class.

%  There are K = size(all_theta, 1). 
%  p = PREDICTONEVSALL(all_theta, X) will return a vector of predictions for each example in the matrix X.

%  X contains the examples in rows.
%  p is set to a vector of values from 1..K

m = size(X, 1); % Number of lines in X, ie numer of exemples that we want to classify
num_labels = size(all_theta, 1); % Number of lines in all_theta, ie number of classes.

fprintf('\n The number of different classes that we want to classify is : %f\n\n',num_labels);

% We will return the following variables
p = zeros(size(X, 1), 1);
trash = zeros(size(X, 1), 1);

% Add ones to the X data matrix, so that we can take biais/constants/means (pick your term) into account

X = [ones(m, 1) X];

%               Using our learned logistic regression parameters (one-vs-all)
%               we set p to a vector of predictions (from 1 to
%               num_labels).

%As usual code is extremely short thanks to vectorization, but one needs time to visualize what that line is doing
%it should be written by hand for comprehension.
[trash,p] = max(X * all_theta',[],2);

% =========================================================================

end
