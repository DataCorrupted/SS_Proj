function [ h ] = Calculate( Theta, t, N, omega )
%Calculate Summary of this function goes here
%   calculate the result of a fourier series and save the result in a
%   column. Theta is the coff of the series. 1 + 2 * N is the number of
%   series, N coses, N sines and 1 const. t is the time column containing
%   the input time. omega is connected to T.

len = size(t, 2);
T = t' * (2.^(1:N)) * omega;
h = [ones(len,1) cos(T) sin(T)] * Theta;
end

