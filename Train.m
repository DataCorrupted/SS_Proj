function [ Theta ] = Train( Theta, history, a, t, N, omega, most_step )
%Calculate Summary of this function goes here
%   Train a Theta from the history data. both Theta of input and output is
%   the coff of the series. history saves the history data. a is the
%   learning step. t is the time column. N is the number of series. omega
%   is connected to T. most_step states the most steps a training process
%   are going to take.

m = N;
len = size(t, 2);
T = t' * (2.^(1:N)) * omega;
% I was trying to use fft, but failed here. Reasons unknown, Theta just
% became very low.
% J = sum((history - h) .^ 2) / 2 / m;
for i= 1: most_step
    h = Calculate(Theta, t, N, omega);
    plot(t, h);
    Theta = Theta + a * [ones(len,1) cos(T) sin(T)]' * (history - h)/ m;
end

end

