function Zs = convSmooth(Z,N,sigma)
% CONVSMOOTH 2-dimensional convolution smoother using an N-point guassian
% kernel
% 
%   Zs = convSmooth(Z,N,sigma) smooths the data Z by convolving with a
%   Guassian kernal of size NxN and standard deviation sigma.  If N or
%   sigma are omitted (or empty), default values of N=9 and sigma=1 will be
%   used.
%
%   For more information (and possibly corrections),see:    
%       https://www.mathworks.com/help/matlab/data_analysis/convolution-filter-to-smooth-data.html
%       https://homepages.inf.ed.ac.uk/rbf/HIPR2/gsmooth.htm
%   This may also be a poor-man's version of imgaussfilt ?
%
%   S.D.Brenner, 2019

%% Parse inputs

% Set default values:
if nargin < 3 || isempty(sigma); sigma =1; end
if nargin < 2 || isempty(N); N = 9; end

% Note: I think that there is supposed to be some relationship such that
% sigma and N are not independant variables in order to conserve /some/
% quantity. That has not been implemented here.



%% Smooth

% Build N-point Gaussian smoothing Kernal:
x = linspace( -3*sigma, 3*sigma, N);
[X,Y] = meshgrid( x , x );
K = exp( -(X.^2 + Y.^2) / sqrt(2) );
K = exp( -(X.^2 + Y.^2) / (2*sigma^2) );
K = K./sum(K(:)); % normalize weights to sum to 1

% To reduce boundary effects, mirror the input matrix across all bondaries
Zcent = [fliplr(Z), Z, fliplr(Z)];
Ztopbot = flipud(Zcent);
Zfull = [Ztopbot; Zcent; Ztopbot];

% Apply convolution
Zconv = conv2(Zfull,K,'same');

% Extract original matrix subset
[numRow,numCol] = size(Z);
extractRows = (1:numRow) + numRow;
extractCols = (1:numCol) + numCol;
Zs = Zconv( extractRows, extractCols);

end

