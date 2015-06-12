function W = randInitializeWeights(L_in, L_out)
%   Randomly initialize parameters
%   Note that W should be set to a matrix of size(L_out, 1 + L_in) as
%   the column row of W handles the "bias" terms
%

% You need to return the following variables correctly 
W = zeros(L_out, 1 + L_in);

%
% Note: The first row of W corresponds to the parameters for the bias units
%

% Randomly initialize the weights to small values
epsilon_init = 0.12;
W = rand(L_out, 1 + L_in) * 2 * epsilon_init - epsilon_init;









% =========================================================================

end
