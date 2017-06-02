devReader = audioDeviceReader;
devWriter = audioDeviceWriter;
fileWriter = dsp.AudioFileWriter('commit_log.wav','FileFormat','WAV');
fileReader = dsp.AudioFileReader('Filename', ...
                                    'E:\CloudMusic\Liberation.mp3');
SPF = 1024;
devReader.SamplesPerFrame = SPF;
fileReader.SamplesPerFrame = SPF;
setup(devReader);% Initialize audio device

tic;
cnt = 0;
plot(cnt);
while toc < 60
  toc
  [error, nOverrun] = record(devReader);
  signal = step(fileReader);
  output = error + signal / 2;
  step(fileWriter, output);
  play(devWriter, output);
  plot(error)
end

release(devReader);     % release the audio device
release(devWriter);     % close the audio output device
release(fileWriter);    % close the output file
release(fileReader);    % close the input file
disp('Recording complete');
