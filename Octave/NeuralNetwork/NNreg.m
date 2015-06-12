%%  Statistical model for activity recognition : Neural Network 

%  Octave : This code has been run on Octave. It has never been tested on Matlab but should work with only minor modifications.
%  (Octave is OpenSource, Matlab is not). This could also be simply adapted to work in R, all the functions are available.

% -------- Content :
%  This file contains code that trains a one-vs-all classifier using a neural network.
%  The point is the following : given data we want to predict if an exemple belongs or
%  not to a class. If there are more than one class, a classifier will be computed for each of them
%  as was the case with OneVsAll classification. Here the probability for each class will be given by
%  each neuron of the last layer of our neural network.

% -------- Architecture :
%  This code makes use of the following files:
%     sigmoidGradient.m  (compute the gradient for the sigmoid).
%     randInitializeWeights.m (initializes weights at random)
%     nnCostFunction.m (compute the cost function for the neural network and it's gradient in a given spot).

% -------- Constants that must be modified :
%	Before running the script one has to know :
%	- The number of feature (input_layer_size)
%	- The number of classes to be discriminated (num_labels)

%

% ------- Interest :
%  The main interest of neural networks is that they "build" their own features, conversly to logistic regression which
%  is dependant on the way you build your features.


%% Initialization
clear ; close all; clc

%% Setup of the parameters we will use to learn parameters 
input_layer_size  = 189;  % should to be replaced by our number of inputs 
hidden_layer_size = 25;   % should be replaced by the number of neurons we want to try out
num_labels = 2;          % should be replaced by the number of class we have   

fprintf(' 같같같같� Running script : Neural Network 같같같같같� \n\n\n\n');
fprintf('---- Welcome, user ! -----  \n\n');
fprintf('This script will propose you with a solution for your supervised classification problem.\n\n');
fprintf('To do so it will aproximate optimal parameters to be used in a Neural Network.\n\n');
fprintf('Here is how to use this script : \n\n');
fprintf('Your data should be stored in a file called data.txt, all features of an example should be stored on a single line and seperated by comas. \n\n');
fprintf('The last number of the line should be the number of the class to which the exemple belongs. Start at 1 (and do not use 0, because in Octave arrays start at 1)\n\n');
fprintf('This is not a detail, if numbers are not written done well there is no hope of getting the script to work. See documentation for a VIM macro on how to add numbers at the end of each line \n\n\n');
fprintf('Starting the neural network, press enter to continue ... (Next step can take minutes).\n');
pause;

%data = load('data.txt');
data1 = load('data_sumStill.txt'); % training data stored in arrays X, y
data2 = load('data_sumWalk.txt'); % training data stored in arrays X, y

data = [data1(1:600,:);data2(1:1300,:)];
test_data = [data1(601:720,:);data2(1301:1660,:)];

fprintf('Data has been loaded, press enter start learning the parameters...\n');

X = data(:, 1:(end-1));
y = data(:, end);

m = size(X, 1); %Number of lines in X ie number of exemples in the data set 

%% ================  Initializing Pameters ================
%  We start by initializing the weights of the neural network randomly, using
%  randInitializeWeights.m

fprintf('\n Randomly initializing Neural Network Parameters ...\n');

initial_Theta1 = randInitializeWeights(input_layer_size, hidden_layer_size);
initial_Theta2 = randInitializeWeights(hidden_layer_size, num_labels);

% Unroll parameters
initial_nn_params = [initial_Theta1(:) ; initial_Theta2(:)];


fprintf('\nPerforming Backpropagation to train our neural network... \n');

%% =================== Training NN ===================
%  Our goal is to minimize a cost function wich measures the amount of mistakes our model is doing.
%  Here again we make use of an advanced optimizer which is able to minimize our cost functions efficiently as
%  long as we provide them with the gradient computations. Note that other optimizers exist,
%  for exemple optimizers which use the Hessian matrix (second order differentials)
%

% Settings some options
options = optimset('MaxIter', 50); % The maximum number of loops allowed to train the neural network (depends on how much computing power you have,
  				   % Since this is done offline these step could be done with a very powerfull computer.

% This parameter is used to fight over-fitting : if your model suffers from over-fitting, increasing this parameter is
% one of the steps you can take to decrease over-fitting.
lambda = 0.1;

% "short hand" for the cost function to be minimized
costFunction = @(p) nnCostFunction(p, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, X, y, lambda);

% Now, costFunction is a function that takes in only one argument (the
% neural network parameters)
[nn_params, cost] = fmincg(costFunction, initial_nn_params, options);

% We now obtain Theta1 and Theta2 from nn_params by reshaping it with te right parameters.
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

fprintf('Program paused : the neurons have been train. Press enter to continue.\n');
pause;

%% ================= Predict =================
%  We will now use the "predict" function to use the
%  neural network to predict the labels of the training set. This lets
%  us compute the training set accuracy.

pred = predict(Theta1, Theta2, X);

fprintf('\nTraining Set Accuracy: %f\n', mean(double(pred == y)) * 100);


