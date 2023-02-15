function y = gaussmf(x, params) %#codegen
%GAUSSMF Gaussian curve membership function.
%   GAUSSMF(X, PARAMS) returns a matrix which is the Gaussian
%   membership function evaluated at X. PARAMS is a 2-element vector
%   that determines the shape and position of this membership function.
%   Specifically, the formula for this membership function is:
%
%   GAUSSMF(X, [SIGMA, C]) = EXP(-(X - C).^2/(2*SIGMA^2));
%
%   For example:
%
%       x = (0:0.1:10)';
%       y1 = gaussmf(x, [0.5 5]);
%       y2 = gaussmf(x, [1 5]);
%       y3 = gaussmf(x, [2 5]);
%       y4 = gaussmf(x, [3 5]);
%       subplot(211); plot(x, [y1 y2 y3 y4]);
%       y1 = gaussmf(x, [1 2]);
%       y2 = gaussmf(x, [1 4]);
%       y3 = gaussmf(x, [1 6]);
%       y4 = gaussmf(x, [1 8]);
%       subplot(212); plot(x, [y1 y2 y3 y4]);
%       set(gcf, 'name', 'gaussmf', 'numbertitle', 'off');
%
%   See also DSIGMF,EVALMF, GAUSS2MF, GBELLMF, PIMF, PSIGMF, SIGMF,
%   SMF, TRAPMF, TRIMF, ZMF.

%   Copyright 1994-2018 The MathWorks, Inc.

fuzzy.internal.utility.validateGaussMFParameterValues(params)

sigma = cast(params(1),'like',x); 
c = cast(params(2),'like',x);
y = exp(-(x - c).^2/(2*sigma^2));

end