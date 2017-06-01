
Reader = dsp.AudioFileReader('Filename','./Liberation.wav');
Writer = dsp.AudioFileWriter('Filename', 'SigalChannelLiberation.wav');

while ~isDone(Reader)
     audio = Reader();
     Writer(audio(:, 1));   % Only write one channel.
end

release(Reader);
release(Writer);