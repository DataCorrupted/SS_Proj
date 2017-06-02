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
  % stimulation signal
  signal_frame = step(Signal);
  noise_frame_sim = step(Noise);
  % duplicate noise frame to get two channel
  noise_sim_two = [noise_frame_sim noise_frame_sim];
  
  % sampling
  mixture = signal_frame + noise_sim_two;
  % duplicate noise frame to get two channel
  mixture = signal_frame + [noise_frame_sim noise_frame_sim];
  noise_frame = mixture - signal_frame;
  
  
  mixture_left = FIR(noise_frame(:,1)) + signal_frame(:, 1); % Noise + Signal
  [ ~ , result_left] = NLMS(noise_frame(:,1), mixture_left, mu, a);
  
  mixture_right = FIR(noise_frame(:,2)) + signal_frame(:, 2); % Noise + Signal
  [ ~ , result_right] = NLMS(noise_frame(:,2), mixture_right, mu, a);
  
  output = [result_left result_right];
  play(devWriter, output);
end

release(Noise);
release(Signal);
disp('Noise Canceler exited.');
