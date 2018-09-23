function [strideFreq, distCalc] = getRunningPace(time, y_accel, z_accel, Fs, lenStride)
    % gives foot impact frequency, takes in arrays of acceleration while running, time array, sampling 
    %frequency and measured length of time
    yz_accel = y_accel + z_accel; 
    N = size(yz_accel, 1);
    frequencies_shifted = ((linspace(-pi, pi-2/N*pi, N) + pi/N*mod(N,2))*(Fs/(2*pi)));
    X = abs(fft(yz_accel));
    plot(frequencies_shifted, fftshift(X)); 
    
    [~, ind] = max(fftshift(X)); 
    freq = abs(frequencies_shifted(:,ind));
    strideFreq = freq;
    distCalc = (time(end)-time(1))*strideFreq*lenStride; 
    
end 