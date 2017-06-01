% Currently we will working on 
% Noise = audioDeviceReader;
% setup(Nosie);% Initialize audio device
SPF = 1024;
Noise = dsp.AudioFileReader( ...
    'Filename','./WhiteNoise.wav', ...
    'SamplesPerFrame', SPF);
Signal = dsp.AudioFileReader(...
    'Filename', './Liberation.mp3', ...
    'SamplesPerFrame', SPF);
devWriter = audioDeviceWriter;

L = 8;
tic;
e = zeros(1, L);
x = zeros(1, L);
y = zeros(1, L);
w = zeros(1, L);
P = 0;
alpha = 0.99;
mu = 0.1;
mimc = 0;
%while toc < 0.01
  %[error, nOverrun] = record(devReader);
  % take noise
  signal_frame = step(Signal);
  noise_frame = step(Noise);
  
  cancel_frame = zeros(SPF, 1);
  cancel_frame(1, 1) = mimc;
  
  for samp_cnt = 1: SPF
      samp = noise_frame(samp_cnt) - y(L)
      e = [e(2: L) samp];
      x = y + e;
      P = alpha * x(L).^2 + (1-alpha) * P;
      w = LMS(x, samp, w, P, mu);
      mimc = w * wrev(x');
      y = [y(2: L) mimc];
      if samp_cnt ~= SPF
          cancel_frame(samp_cnt + 1) = mimc;
      end
  end
  output = cancel_frame;
  play(devWriter, output);
  % step(fileWriter, output);
%end

    
release(Noise);
release(Signal);
% release(devReader);     % release the audio device
% release(devWriter);     % close the audio output device
% release(fileWriter);    % close the output file
% release(fileReader);    % close the input file
disp('Noise Canceler exited.');
