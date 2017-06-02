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
mu = 0.05;  % step size

tic;
while toc < 30
  signal_frame = step(Signal);
  noise_frame = step(Noise);
  
  mixture_frame = FIR(noise_frame) + signal_frame; % Noise + Signal
  [ ~ , result_frame] = NLMS(noise_frame, mixture_frame, mu, a);
  output = result_frame;
  play(devWriter, output);
end

release(Noise);
release(Signal);
disp('Noise Canceler exited.');
