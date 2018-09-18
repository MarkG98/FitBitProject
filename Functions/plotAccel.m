function plotAccel(data, Fs)
    % This function assumes it is taking in accelerometer
    % data provided by the MATLAB mobile app as well as
    % the sample rate it is taken at.

    % calculate time in seconds
    
    time = [0:size(data, 1) - 1]./Fs;

    % plot acceleration in direction of all three axes
    figure;
    plot(time, data(:, 1))
    xlabel('Time (s)');
    ylabel('Acceleration (m/s^{2}');
    title('Acceleration in X Direction');
    
    figure;
    plot(time, data(:, 2))
    xlabel('Time (s)');
    ylabel('Acceleration (m/s^{2}');
    title('Acceleration in Y Direction');
    
    figure;
    plot(time, data(:, 3))
    xlabel('Time (s)');
    ylabel('Acceleration (m/s^{2}');
    title('Acceleration in Z Direction');
end