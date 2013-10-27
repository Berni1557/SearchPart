%NIBLACK Adaptive thresholding
%
% t = niblack(im, k)
% t = niblack(im, k, w2)
%
% Returns t the per-pixel threshold, the binary image is
%   im > t
%
% The threshold at each pixel is a function of the mean and std
% deviation:
%   t = mean + k. std
% computed over a WxW window, where W=2*w2+1 and w2 defaults to 7.
%
% A common choice of k=-0.2
%
% The function optionally returns the per-pixel mean and standard
% deviation
%
% [t,M,S] = niblack(im, k)
%
% This is an efficient algorithm very well suited for binarizing
% text.  The window should be chosen to be of similar size to the
% characters.
%
% W. Niblack, An Introduction to Digitall Image Processing,
% Prentice-Hall, 1986.
%
% SEE ALSO: OTSU
%
function [t,M,S] = niblack(im, k, w2)

    if nargin < 3,
        w2 = 7;
    end
    w = 2*w2 + 1;

    window = ones(w, w);

    % compute sum of pixels in WxW window
    sp = conv2(double(im), double(window), 'same');
    % convert to mean
    n = w^2;            % number of pixels in window
    m = sp / n;

    if k ~= 0
        % compute sum of pixels squared in WxW window
        sp2 = conv2(double(im.^2), double(window), 'same');
        % convert to std
        var = (n*sp2 - sp.^2) / n / (n-1);
        s = sqrt(var);

        % compute Niblack threshold
        t = m + k * s;
    else
        t = m;
        s = [];
    end

    if nargout > 1
        M = m;
    end
    if nargout > 2
        S = s;
    end
