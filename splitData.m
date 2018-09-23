function [running_time, x_running, y_running, z_running, breathing_time, x_breathing, y_breathing, z_breathing] = splitData(time, x_accel, y_accel, z_accel, Fs)    
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
            running_time = time(1:m-299) - min(time(1:m-299));
            x_running = x_accel(1:m-299);
            y_running = y_accel(1:m-299);
            z_running = z_accel(1:m-299);

            breathing_time = time(m+450:end) - min(time(m+450:end));
            x_breathing = x_accel(m+450:end);
            y_breathing = y_accel(m+450:end);
            z_breathing = z_accel(m+450:end);
            break;
        end 
    end
end