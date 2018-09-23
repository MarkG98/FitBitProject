%% Time vs. Y Accel
Fs = 50; % Hz
time = accel(700:end-300,1) - min([accel(380:end-300,1)]);
x_accel = accel(700:end-300, 2);
y_accel = accel(700:end-300, 3);
z_accel = accel(700:end-300, 4);

figure;
plot(time, z_accel)
title('Acceleration in Y Direction During Running and Stopping')
xlabel('Times (s)')
ylabel('Acceleration (m/s^{2}')

%% FFT of only running data
N = size(y_accel, 1);
frequencies_shifted = ((linspace(-pi, pi-2/N*pi, N) + pi/N*mod(N,2))*(Fs/(2*pi)));
X = abs(fft(y_accel));

figure;
plot(frequencies_shifted, fftshift(X))
title('FFT Plot of Summed Z and Y Accelerometer Directions');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

%% Seperate running from still
for m = 1:250:size(y_accel, 1) - mod(size(y_accel, 1), 250)
    
    % create snippet of 6 seconds of data
    snippet = y_accel(m:m + 249);
    
    % create 0 centered x axis
    N = size(snippet, 1);
    frequencies_shifted = ((linspace(-pi, pi-2/N*pi, N) + pi/N*mod(N,2))*(Fs/(2*pi)));
    
    % take the fft
    Y = abs(fft(snippet));
    
    % get the most prominent frequency
    [M, I] = max(fftshift(Y));
    prominent_freq = abs(frequencies_shifted(I));
    
    % check if promonent frequency indicates still running
    if (prominent_freq > 2.75)
        continue;
    else
        running_time = time(1:m-299);
        x_running = x_accel(1:m-299);
        y_running = y_accel(1:m-299);
        z_running = z_accel(1:m-299);
        roll_running = roll_vel(1:m-299);
        pitch_running = pitch_vel(1:m-299);
        yaw_running = yaw_vel(1:m-299);
        
        breathing_time = time(m+350:end) - min(time(m+299:end));
        x_breathing = x_accel(m+350:end);
        y_breathing = y_accel(m+350:end);
        z_breathing = z_accel(m+350:end);
        break;
    end 
end

%% Processs the still portion for breathing rate
% ::::::::::::::::::::::::::::::::::::::::::::::::::::
% ::::::::::::::::::::::::::::::::::::::::::::::::::::
%% Compute Dominant Frequency in the Range [0.1, 1]Hz based on the fact that the number of breaths per minute is observed to be between 6 and 60 cycles per minute
summed_zy = y_breathing + z_breathing;

N = size(summed_zy, 1);
frequencies_shifted = ((linspace(-pi, pi-2/N*pi, N) + pi/N*mod(N,2))*(Fs/(2*pi)));
X = abs(fft(summed_zy));

figure;
plot(frequencies_shifted, fftshift(X))
title('FFT Plot of Summed Z and Y Accelerometer Directions');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

f0 = 0.9451; % Hz

%% Filter
f1 = (f0 - 0.4)./25;
f2 = (f0 + 0.4)./25;

[b, a] = butter(4, [f1 f2]);
y = filter(b, a, summed_zy);

% This plot reveals a breathing freqnency of about 1.69 Hz which makes
% sense because this was measured after Hadleigh sprinted
figure;
plot(breathing_time, y)
title('Filtered Sum of Y and Z Filter')
xlabel('Time (s)');
ylabel('Magnitude');

%% Filtered FFT
N = size(y, 1);
frequencies_shifted = ((linspace(-pi, pi-2/N*pi, N) + pi/N*mod(N,2))*(Fs/(2*pi)));
X = abs(fft(y));

figure;
plot(frequencies_shifted, fftshift(X))
title('FFT Plot of Summed Z and Y Accelerometer Directions');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

%% Get breathing from running
% ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
% ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
summed_zy = y_running + z_running;
N = size(summed_zy, 1);
frequencies_shifted = ((linspace(-pi, pi-2/N*pi, N) + pi/N*mod(N,2))*(Fs/(2*pi)));
X = abs(fft(summed_zy));

figure;
plot(frequencies_shifted, fftshift(X))
title('FFT Plot of Summed Z and Y Accelerometer Directions');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
%%
plot(running_time, summed_zy);
%%
[b, a] = butter(5, [0.1/25 1.2/25]);
y = filter(b, a, summed_zy(100:end));
plot(running_time(100:end), y)
%%
N = size(y, 1);
frequencies_shifted = ((linspace(-pi, pi-2/N*pi, N) + pi/N*mod(N,2))*(Fs/(2*pi)));
X = abs(fft(y));

figure;
plot(frequencies_shifted, fftshift(X))
title('FFT Plot of Summed Z and Y Accelerometer Directions');
xlabel('Frequency (Hz)');
ylabel('Amplitude');

%% Get Heart Rate
% :::::::::::::::::::::::::::::::::::::::::::::
% :::::::::::::::::::::::::::::::::::::::::::::
figure;
plot(breathing_time, z_breathing + y_breathing)
title('Acceleration in Y Direction During Running and Stopping')
xlabel('Times (s)')
ylabel('Acceleration (m/s^{2}')

%% Band Pass
[b, a] = butter(4, [0.16/25 24/25]);
filt = filter(b, a, y_breathing(1:600) + z_breathing(1:600));
plot(breathing_time(1:600), filt)
%% Hilbert transform
res = hilbert(filt);
A = abs(res);
plot(breathing_time(1:600), A,breathing_time(1:600),filt)

%% FFT
N = size(A, 1);
frequencies_shifted = ((linspace(-pi, pi-2/N*pi, N) + pi/N*mod(N,2))*(Fs/(2*pi)));
X = abs(fft(A));

figure;
plot(frequencies_shifted, fftshift(X))
title('FFT Plot of Summed Z and Y Accelerometer Directions');
xlabel('Frequency (Hz)');
ylabel('Amplitude');