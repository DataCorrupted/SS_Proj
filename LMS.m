function [ w ] = LMS( x, samp, w, P, mu )
%LMS Summary of this function goes here
%   Detailed explanation goes here
c = 0.01;
w = w + mu / (P + c) * samp * wrev(x);

end

