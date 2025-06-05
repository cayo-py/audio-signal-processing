% === 1. Load and Preprocessing ===
[audio, fs] = audioread('original_audio.wav'); 
audio = audio(:,1);
t = (0:length(audio)-1)/fs;

% === 2. Time Domain Plot of Original Signal (Plot 1) ===
figure;
plot(t, audio);
xlabel('Time (s)');
ylabel('Amplitude');
title('Plot 1: Original Signal with Noise (Time Domain)');

% === 3. Fourier Transform (FFT) ===
N = length(audio);
Y = fft(audio);
f = (0:N-1)*(fs/N); % Frequency Vector

% === 4. Frequency Spectrum Plot (Plot 2) ===
figure;
plot(f, abs(Y)/N);
xlim([0 fs/2]); % Focus up to Nyquist frequency
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Plot 2: Original Signal Frequency Spectrum');

% === 5. IIR Filter Design ===
cutoff_freq = 1000; % Cutoff at 1000 Hz
[b, a] = butter(4, cutoff_freq/(fs/2), 'low'); % Butterworth Filter orde 4

% === 6. Filtering in the Time Domain ===
audio_filtered = filter(b, a, audio);

% === 7. FFT Filter Result (for frequency domain) ===
Y_filtered = fft(audio_filtered);

% === 8. Frequency Plot After Filtering (Plot 3) ===
figure;
plot(f, abs(Y_filtered)/N);
xlim([0 fs/2]);
xlabel('Frekuensi (Hz)');
ylabel('Magnitudo');
title('Plot 3: Frequency Spectrum After IIR Filtering');

% === 9. Inverse Fourier to Time Domain ===
audio_ifft = real(ifft(Y_filtered));

% === 10. Final Result Time Domain Plot (Plot 4) ===
figure;
plot(t, audio_ifft);
xlabel('Waktu (s)');
ylabel('Amplitudo');
title('Plot 4: Signal After Filtering (Time Domain)');

% === 11. Play Audio ===
sound(audio, fs); % Original
disp('play original audio');
pause(length(audio)/fs);
sound(audio_filtered, fs); % after filtering
disp('play the filtered audio');
pause(length(audio_filtered)/fs);

% === 12. Save Filtered Audio ===
audiowrite('iir_result.wav', audio_filtered, fs);
disp('Audio file saved successfully');
