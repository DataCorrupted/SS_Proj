clear
% Noise = audioDeviceReader;
% setup(Nosie);% Initialize audio device
SPF = 1024;                                 % SamplesPerFrame
Noise = dsp.AudioFileReader( ...
    'Filename','./WhiteNoise.wav', ...
    'SamplesPerFrame', SPF);
Signal = dsp.AudioFileReader(...
    'Filename', './Liberation.wav', ...
    'SamplesPerFrame', SPF);
devWriter = audioDeviceWriter;

L = 4;
e = zeros(1, L);
x = zeros(1, L);
y = zeros(1, L);
w = zeros(1, L);

P = 1;
c = 1;
alpha = 0.99;

mu = 0.003;
mimc = 0;

tic;
while toc < 20
  %[error, nOverrun] = record(devReader);
  % take noise
  signal_frame = step(Signal);
  noise_frame = step(Noise);
  
  cancel_frame = zeros(SPF, 1);
  cancel_frame(1, 1) = mimc;
  
  for samp_cnt = 1: SPF
      samp = noise_frame(samp_cnt) - mimc;  % Take the psudo sample
      e = [samp e(1: L-1)];                 % add it to history
      x = y + e;                            % calculate the estimate noise
      mimc = x * w';                        % mimc the next noise
      y = [mimc y(1: L-1)];                 % add it to mimc history
      if samp_cnt ~= SPF
          cancel_frame(samp_cnt + 1) = mimc;% add it to play frame
      end
      P = alpha * (x * x') + (1-alpha) * P; % Update P & w
      w = w - mu * samp * x / (P + c);
  end
  plot(noise_frame - cancel_frame);
  pause
  output = signal_frame;
  % play(devWriter, output);
  % step(fileWriter, output);
end

    
release(Noise);
release(Signal);
disp('Noise Canceler exited.');
