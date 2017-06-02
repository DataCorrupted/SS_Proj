clear
SPF = 1024;                                 % SamplesPerFrame
Noise = dsp.AudioFileReader( ...
    'Filename','./WhiteNoise.wav', ...
    'SamplesPerFrame', SPF);
Signal = dsp.AudioFileReader(...
    'Filename', './Liberation.wav', ...
    'SamplesPerFrame', SPF);
devWriter = audioDeviceWriter;

NLMS = dsp.LMSFilter('Length', 16, ...
   'Method', 'Normalized LMS',...
   'AdaptInputPort', true, ...
   'StepSizeSource', 'Input port', ...
   'WeightsOutputPort', false);
FIR = dsp.FIRFilter('Numerator', fir1(8,[.25, .75]));

a = 1;      % adaptation control
mu = 0.3;   % step size

tic;
while toc < 60
  signal_frame = step(Signal);
  noise_frame = step(Noise);
  
  mixture_left = FIR(noise_frame) + signal_frame(:, 1); % Noise + Signal
  [ ~ , result_left] = NLMS(noise_frame, mixture_left, mu, a);
  
  mixture_right = FIR(noise_frame) + signal_frame(:, 2); % Noise + Signal
  [ ~ , result_right] = NLMS(noise_frame, mixture_right, mu, a);
  
  output = [result_left result_right];
  play(devWriter, output);
end

release(Noise);
release(Signal);
disp('Noise Canceler exited.');
