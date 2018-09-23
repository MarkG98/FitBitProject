function [avgBreathRate] = getAverageBreath(time, y_accel, z_accel, Fs, sec)
    avgBreathRate = [];
    for o = 1:sec*Fs:(size(time, 1) - mod(size(time, 1), sec*Fs))
        
        % sum y and z accel
        summed_zy = y_accel(o:o + sec*Fs - 1) + z_accel(o:o + sec*Fs - 1);

        % get size of data
        N = size(summed_zy, 1);

        % make x axis in Hz for zero centered FFT
        frequencies_shifted = ((linspace(-pi, pi-2/N*pi, N) + pi/N*mod(N,2))*(Fs/(2*pi)));
        X = abs(fft(summed_zy));
        X_shifted = fftshift(X);
        
        figure;
        plot(frequencies_shifted, fftshift(X))
        title('FFT Plot of Summed Z and Y Accelerometer Directions');
        xlabel('Frequency (Hz)');
        ylabel('Amplitude');
        
        [~, bottom] = min(abs(frequencies_shifted-0.36));
        [~, top] = min(abs(frequencies_shifted-1));
        
        offset = (size(frequencies_shifted(1:bottom), 2)) - 1;
        
        [~, I] = max(X_shifted(bottom:top));
        f0 = frequencies_shifted(offset + I);
        
        f1 = max(0.1, f0 - 0.4);
        f2 = f0 + 0.4;
        
        
        [b, a] = butter(4, [f1/Fs f2/Fs]);
        y = filter(b, a, summed_zy);
        
        figure;
        plot(frequencies_shifted, fftshift(abs(fft(y))))
        title('FFT Plot of Summed Z and Y Accelerometer Directions');
        xlabel('Frequency (Hz)');
        ylabel('Amplitude');

        filtFFT_shifted = fftshift(abs(fft(y)));
        [~, I] = max(filtFFT_shifted(bottom:top));
        breathe = frequencies_shifted(offset + I);
        
        avgBreathRate = [avgBreathRate; o/Fs, o/Fs + sec, breathe*60];
    end
end