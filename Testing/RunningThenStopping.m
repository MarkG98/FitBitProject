%% Time vs. Sum of Y and Z accel
Fs = 50; % Hz
time = accel(200:end-100,1) - min([accel(200:end-100,1)]);
summed_zy = accel(200:end-100, 4); %+ accel(200:end-100, 4);

figure;
plot(time, summed_zy)
title('Summed Antero-Posterior and Gravitational Oriented Accelerometer Values')
xlabel('Times (s)')
ylabel('Acceleration (m/s^{2}')