clc
% Learning step.
a = 0.03;
% Basic information listed here.
Ts = 0.001;                  % Sample rate.
% Duration time.
dur_time = 1;
sample_cnt = dur_time / Ts;
% Signal 
t = Ts: Ts: dur_time;
hist_cnt = 100;             % Number of history data.
T = hist_cnt * Ts;          % Period.
omega = 2 * pi / T;         % w required by that period.
ts = omega * t * 1000;
signal = 3* (sin(ts) + cos(ts * 0.23) + ...
    sin(ts * 0.51) + sin( ts * 2 ));
% History. We take the first couple samples out.
history = signal(1:hist_cnt)';

N = 15;
feature_cnt = N * 2 + 1;
% Feathres. We use 4 stage fourier series to simulate the signal.
% Theta(1) is a0.
% Theta(2) is a1, Theta(3) is a2, so on so forth.
% Theta(N+2) is b1, Theta(N+3) is b2, so on so forth.
Theta = Train(zeros( feature_cnt, 1 ), ...    % initial state is all zeros.
    history, a, (0: Ts: T-Ts), N, omega, 50);
Output = zeros(sample_cnt, 1);
for i= hist_cnt+1: dur_time / Ts
    % Use this time to predict the next noise.
    Output(i) = Calculate(Theta, t(i), N, omega);
    % Refresh our history
    history = [history(2:hist_cnt); signal(i)];
    % ans re-train our theta.
    Theta = Train(Theta, history, a, (t(i)-T + Ts: Ts: t(i)), N, omega, 10);
    h = Calculate(Theta, t(i-hist_cnt+1: i), N, omega);
end
subplot(211)
plot(t, signal'- Output);
subplot(212)
plot(t, signal');