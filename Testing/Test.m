%%
getAverageBreath(running_time, y_running, z_running, Fs, 9)

getAverageBreath(breathing_time, y_breathing, z_breathing, Fs, 14)
%%

N = size(y_breathing, 1);
frequencies_shifted = ((linspace(-pi, pi-2/N*pi, N) + pi/N*mod(N,2))*(Fs/(2*pi)));

figure;
plot(frequencies_shifted, fftshift(abs(fft(y_breathing))))
title('FFT Plot of Y Axes of Accelerometer - Breathing');
xlabel('Frequency (Hz)');
ylabel('Amplitude');