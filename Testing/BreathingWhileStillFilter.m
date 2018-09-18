%% Time vs. Sum of Y and Z accel
Fs = 50; % Hz
time = accel(200:1200,1) - min([accel(200:1200,1)]);
summed_zy = accel(200:1200, 3) + accel(200:1200, 4);

figure;
plot(time, summed_zy)
title('Summed Antero-Posterior and Gravitational Oriented Accelerometer Values')
xlabel('Times (s)')
ylabel('Acceleration (m/s^{2}')

%% Compute Dominant Frequency in the Range [0.1, 1]Hz based on the fact that the number of breaths per minute is observed to be between 6 and 60 cycles per minute
N = size(summed_zy, 1);
frequencies_shifted = ((linspace(-pi, pi-2/N*pi, N) + pi/N*mod(N,2))*(Fs/(2*pi)));
X = abs(fft(summed_zy));

figure;
plot(frequencies_shifted, fftshift(X))
title('FFT Plot of Summed Z and Y Accelerometer Directions');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

f0 = 0.6494; % Hz

%% Filter
f1 = f0/25;
f2 = (f0 + 0.4)./25;

[b, a] = butter(4, [f1 f2]);
y = filter(b, a, summed_zy);

% This plot reveals a breathing freqnency of about 1.69 Hz which makes
% sense because this was measured after Hadleigh sprinted
figure;
plot(time, y)
title('Filtered Sum of Y and Z Filter')
xlabel('Time (s)');
ylabel('Magnitude');
