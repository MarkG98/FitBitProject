function [strideFreq, speedCalc] = getRunPace(y_accel, Fs, lenStride)
    % gives foot impact frequency, takes in arrays of acceleration while running, time array, sampling 
    %frequency and measured length of time

    N = size(y_accel, 1);
    frequencies_shifted = ((linspace(-pi, pi-2/N*pi, N) + pi/N*mod(N,2))*(Fs/(2*pi)));
    X = abs(fft(y_accel));
%     plot(frequencies_shifted, fftshift(X)); 
    
    [~, ind] = max(fftshift(X)); 
    freq = abs(frequencies_shifted(:,ind));
    
    speedCalc = freq*lenStride *(.68181); %convert feet per second into MPH
    strideFreq = freq;
end 