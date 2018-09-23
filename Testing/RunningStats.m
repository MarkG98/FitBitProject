%% Time vs. Y Accel
Fs = 50; % Hz
time = accel(700:end-300,1) - min([accel(700:end-300,1)]);
x_accel = accel(700:end-300, 2);
y_accel = accel(700:end-300, 3);
z_accel = accel(700:end-300, 4);

figure;
plot(time, z_accel)
title('Acceleration in Y Direction During Running and Stopping')
xlabel('Times (s)')
ylabel('Acceleration (m/s^{2}')

%% Seperate running from still
[running_time, x_running, y_running, z_running, breathing_time, x_breathing, y_breathing, z_breathing] = splitData(time, x_accel, y_accel, z_accel, 50); 

%% GET AVERAGE BREATHING RATE OVER THE RUNNING PERIOD
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

%% sum y and z components of acceleration
summed_zy = y_running + z_running;
N = size(summed_zy, 1);
frequencies_shifted = ((linspace(-pi, pi-2/N*pi, N) + pi/N*mod(N,2))*(Fs/(2*pi)));
X = abs(fft(summed_zy));

figure;
plot(frequencies_shifted, fftshift(X))
title('FFT Plot of Summed Z and Y Accelerometer Directions');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

figure;
plot(running_time, summed_zy);
title('Summed Z and Y Accelerometer Directions');
xlabel('Time (s)');
ylabel('Acceleration (m/s^{2}');

f0 = .9804;
%% Band Pass

f1 = f0 - 0.4;
f2 = f0 + 0.4;

[b, a] = butter(4, [f1/25 f2/25]);
y = filter(b, a, summed_zy(1:300));
plot(running_time(1:300), y)
%%
N = size(y, 1);
frequencies_shifted = ((linspace(-pi, pi-2/N*pi, N) + pi/N*mod(N,2))*(Fs/(2*pi)));
X = abs(fft(y));

figure;
plot(frequencies_shifted, fftshift(X))
title('FFT Plot of Summed Z and Y Accelerometer Directions');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

%% GET AVERAGE BREATHING RATE OVER THE STILL PERIOD
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
%% sum y and z components of acceleration
summed_zy = y_breathing + z_breathing;
N = size(summed_zy(1801:2700), 1);
frequencies_shifted = ((linspace(-pi, pi-2/N*pi, N) + pi/N*mod(N,2))*(Fs/(2*pi)));
X = abs(fft(summed_zy(1801:2700)));

figure;
plot(frequencies_shifted, fftshift(X))
title('FFT Plot of Summed Z and Y Accelerometer Directions');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

figure;
plot(breathing_time, summed_zy);
title('Summed Z and Y Accelerometer Directions');
xlabel('Time (s)');
ylabel('Acceleration (m/s^{2}');

f0 = .5556;
%% Band Pass

f1 = f0 - 0.4;
f2 = f0 + 0.4;

[b, a] = butter(4, [f1/25 f2/25]);
y = filter(b, a, summed_zy(1801:2700));
plot(breathing_time(1801:2700), y)
%%
N = size(y, 1);
frequencies_shifted = ((linspace(-pi, pi-2/N*pi, N) + pi/N*mod(N,2))*(Fs/(2*pi)));
X = abs(fft(y));

figure;
plot(frequencies_shifted, fftshift(X))
title('FFT Plot of Summed Z and Y Accelerometer Directions');
xlabel('Frequency (Hz)');
ylabel('Amplitude');