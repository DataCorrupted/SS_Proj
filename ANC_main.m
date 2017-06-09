clear
SPF = 1024;                                 % SamplesPerFrame
Noise = dsp.AudioFileReader( ...
    'Filename','./Source/WhiteNoise.wav', ...
    'SamplesPerFrame', SPF);
Signal = dsp.AudioFileReader(...
    'Filename', './Source/Liberation.wav', ...
    'SamplesPerFrame', SPF);
devWriter = audioDeviceWriter;

NLMS_left = dsp.LMSFilter('Length', 16, ...
   'Method', 'Normalized LMS',...
   'AdaptInputPort', true, ...
   'StepSizeSource', 'Input port', ...
   'WeightsOutputPort', false);

NLMS_right = NLMS_left.clone();

FIR = dsp.FIRFilter('Numerator', fir1(8, [.25, .75]));

a = 1;      % adaptation control
mu = 0.3;   % step size

tic;
while toc < 60
  % stimulation signal
  signal_frame = step(Signal);
  noise_frame_sim = step(Noise);
  
  % sampling mixture from microphone
  mixture = signal_frame + noise_frame_sim;
  noise_frame = mixture - signal_frame;
  
  
  mixture_left = FIR(noise_frame(:,1)) + signal_frame(:, 1); % Noise + Signal
  [ ~ , result_left] = NLMS_left(noise_frame(:,1), mixture_left, mu, a);
  
  mixture_right = FIR(noise_frame(:,2)) + signal_frame(:, 2); % Noise + Signal
  [ ~ , result_right] = NLMS_right(noise_frame(:,2), mixture_right, mu, a);
  % result_right = FIR(result_right);
  output = [ result_left result_right ];
  play(devWriter, output);
end

release(Noise);
release(Signal);
disp('Noise Canceler exited.');
