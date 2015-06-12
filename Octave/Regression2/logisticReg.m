%%  One-vs-all logistic regression Classifier.

%  Octave : This code has been run on Octave. It has never been tested on Matlab but should work with only minor modifications.
%  (Octave is OpenSource, Matlab is not). This could also be simply adapted to work in R, all the functions are available.

% -------- Content :
%  This file contains code that trains a one-vs-all classifier using logistic regression.
%  The point is the following : given data we want to predict if an exemple belongs or
%  not to a class. If there are many classes, a classifier will be computed for each of them.
%  Each classifier will return a probability of belonging to the corresponding class, and the 
%  most probable class will be chosen.

% -------- Architecture :
%  This code makes use of the following files:
%     lrCostFunction.m (compute the logistic regression cost function and it's gradient in a given spot).
%     oneVsAll.m (Regresses all the parameters for each classifier using the cost function and gradient descent).
%     predictOneVsAll.m (Uses parameters given to predict the class to which a vector belongs)
%     predict.m
%
% -------- Constants that must be modified :
%	Before running the script one has to know :
%	- The number of feature (input_layer_size)
%	- The number of classes to be discriminated (num_labels)
%


%% Initialization of Octave
clear ; close all; clc

%Welcome the user, tell him what we are doing
fprintf(' 같같같같� Running script : Logistic Regression 같같같같같� \n\n\n\n');
fprintf('---- Welcome, user ! -----  \n\n');
fprintf('This script will run logistic regression to solve a classification problem.\n\n');

%More comments
%fprintf('To do so it will aproximate optimal parameters to be used in a logistic Regression.\n\n');
%fprintf('Here is how to use this script : \n\n');

%
fprintf('Your data should be stored in a file called data.txt, or divided in different documents depending on the code for loading data, go check the code'\n);
fprintf('all features of an example should be stored on a single line and seperated by comas. \n\n');
fprintf('The last number of the line should be the number of the class to which the exemple belongs.\n');
fprintf('Start at 1 (and do not use 0, because in Octave arrays start at 1)\n\n');
%fprintf('This is not a detail, if numbers are not written done well there is no hope of getting the script to work. See documentation for a VIM macro on how to add numbers at the end of each line \n\n\n');
fprintf('Program paused,  Press enter to continue (Next step can take minutes).\n');
pause;


%% Setup of the parameters that we will use for one-vs-all classification 
input_layer_size  = 768;  % Number of features we will use for the regression, this has to be determined before running the script
num_labels = 2;           % Number of classes to be used. Labels start at 1, not at 0

%% =========== Loading Data =============
% When possible, we like to visualize the data. Here no simple visualization is relevant.

%% Load our Data from a file.
% Each line corresponds to one experiment (with a number of feature), the last column classifies the exemple.
fprintf('Loading Data ...\n')


%loading the data.
%If the data is separated in different files

%data_sStill contains simple data, data_sumStill contains summarized data.
data1 = load('data_sStill.txt'); % training data stored in arrays X, y
data2 = load('data_sWalk.txt'); % training data stored in arrays X, y
experiment_data = load('test.txt'); % in test you can put your own data, the "test.txt" file is the one recorded by M Alphand during the presentation.

data = [data1(1:600,:);data2(1:1300,:); % Dividing in learning/test set. 
test_data = [data1(601:720,:);data2(1301:1660,:); 

%If there is only one file;
%data = load('data_sall.txt');

% Arrange the data to fit our needs:
X = data(:, 1:(end-1)); %Each line of X contains the features for one experiment in the data set.
y = data(:, end); % Each line contains the true class of the corresponding experiment.
X_test = test_data(:,1:(end-1));
y_test = test_data(:,end);
X_experiment = experiment_data(:,1:(end-1));
y_experiment = experiment_data(:, end);

%y_test(1:10) = 3*ones(10,1);



%fprintf(' In our learning set we have %f exemples for 1 and %f examples for 2 \n\n',sum(y==1),sum(y==2));
%fprintf(' In our test set we have %f exemples for 1 and %f examples for 2 \n\n',sum(y_test==1),sum(y_test==2));

m = size(X, 1);%Number of exemples in the training set.

fprintf('Program paused. Data has been loaded, Press enter to continue.\n');
pause;

%% ============ Vectorized Logistic Regression ============
%

fprintf('\nTraining One-vs-All Logistic Regression...\n')


lambda = 0.1; %Regularization parameter. Increase when the model is over-fitting.
[all_theta] = oneVsAll(X, y, num_labels, lambda); %Train the parameters using cost-function and gradient descent
%At this point all_theta is a matrix containing all the parameters learned by oneVsAll.
%Each line corresponds to the parameters for a classifier

fprintf('Program paused. We have learned all the parameters. Enter to press onwards.\n');
pause;


%% ================ Prediction ================
% We now use the parameters that we have learned.
fprintf('We will test prediction accuracy on the learning set (this is NOT an accurate estimation of how well the classifier will work in real life, as it is biaised towards its learning set \n\n');
pred = predictOneVsAll(all_theta, X);

% Note that judging according to training set accuracy is BAD PRACTICE (it is optimist as
% the model is biaised towards the training set)

fprintf('\n Our training Set Accuracy is: %f\n', mean(double(pred == y)) * 100);

fprintf('We will now test prediction accuracy on the test set (this good practice) \n\n');
pred_test = predictOneVsAll(all_theta, X_test);
fprintf('\n Our test Set Accuracy is: %f\n', mean(double(pred_test == y_test)) * 100);

experiment_test = predictOneVsAll(all_theta, X_experiment);
printf('\n On our test experiment , the accuracy is :  %f\n', mean(double(experiment_test == y_experiment)) * 100);



