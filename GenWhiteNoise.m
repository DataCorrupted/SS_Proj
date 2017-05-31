i = 0;
y0 = [];        % the noise
while(i < 300000)
    y0 = [y0 0];
    i = i + 1;
    if (mod(i,10000) == 0 )
        i
    end
end

y0 = y0';
y1 = awgn(y0,10);
plot(y1(1:500));

devWriter = audioDeviceWriter;
%fileWriter = dsp.AudioFileWriter('noise.wav','FileFormat','WAV');
tic;
audiowrite('noise.wav',y1,44100);
% while(toc < 20)
%     toc
%     step(fileWriter, output);
%     % play(devWriter, y1);
% end

release(devWriter);     % close the audio output device
%release(fileWriter);    % close the output file