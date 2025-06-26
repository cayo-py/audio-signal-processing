# audio-signal-processing

This repository contains a MATLAB script that demonstrates a fundamental audio signal processing workflow: filtering high-frequency noise from an audio signal using a digital low-pass IIR (Infinite Impulse Response) Butterworth filter.
The script visualizes the signal in both the time and frequency domains before and after filtering, allowing for a clear comparison of the results.

## Key Concepts Demonstrated

- **Audio I/O:** Reading from and writing to `.wav` files.
Time-Domain Analysis: Plotting signal amplitude over time.
- **Frequency-Domain Analysis:** Using the Fast Fourier Transform (FFT) to analyze the signal's frequency spectrum.
- **Digital Filter Design:** Designing a 4th-order low-pass Butterworth IIR filter.
- **Signal Filtering:** Applying the designed filter to the audio signal.
- **Audio Playback:** Listening to the original and filtered audio directly within MATLAB.

## Requirements

- **MATLAB**
- **Signal Processing Toolbox™:** Required for the `butter` and `filter` functions.

## How to Use

1. **Clone the repository:**

    ```bash
    git clone https://github.com/cayo-py/audio-signal-processing.git
    cd audio-signal-processing
    ```

2. **Add an audio file:**

    Place an audio file named `original_audio.wav` in the root directory of the project. The script is designed to process this specific file.

3. **Run the script:**

    Open the `.m` script in MATLAB and run it.

4. **Check the output**, the script will:

    - Generate four plot figures showing the signal at different stages.
    - Play the original audio, followed by the filtered audio.
    - Save the processed audio as `iir_result.wav` in the same directory.

## Code Breakdown

The script is divided into several logical sections.

1. **Load and Preprocessing**

    First, the script loads the audio file `original_audio.wav` using `audioread`. It ensures the audio is mono by taking only the first channel. A time vector `t` is also created for plotting purposes.

    ```matlab
    [audio, fs] = audioread('original_audio.wav'); 
    audio = audio(:,1);
    t = (0:length(audio)-1)/fs;
    ```

2. **Time and Frequency Analysis of Original Signal**

    The script visualizes the original noisy signal in the time domain (**Plot 1**). It then computes the Fast Fourier Transform (FFT) to move the signal into the frequency domain. The magnitude of the frequency spectrum is plotted (**Plot 2**), showing the distribution of frequencies in the original signal.

    ```matlab
    % Time Domain Plot (Plot 1)
    figure;
    plot(t, audio);
    title('Plot 1: Original Signal with Noise (Time Domain)');

    % Fourier Transform and Frequency Spectrum Plot (Plot 2)
    N = length(audio);
    Y = fft(audio);
    f = (0:N-1)*(fs/N);
    figure;
    plot(f, abs(Y)/N);
    xlim([0 fs/2]); % Focus on the spectrum up to the Nyquist frequency
    title('Plot 2: Original Signal Frequency Spectrum');
    ```

3. **IIR Low-Pass Filter Design**

    A 4th-order Butterworth low-pass filter is designed using the `butter` function. The cutoff frequency is set to `1000 Hz`. The function returns the filter's numerator (`b`) and denominator (`a`) coefficients. The cutoff frequency is normalized by the Nyquist frequency ($f_{s}/2$).

    ```matlab
    cutoff_freq = 1000; % Cutoff at 1000 Hz
    [b, a] = butter(4, cutoff_freq/(fs/2), 'low');
    ```

4. **Filtering and Post-Filtering Analysis**

    The designed filter is applied to the original audio signal in the time domain using the `filter` function.

    To verify the filter's effect, the FFT of the filtered signal is computed and its frequency spectrum is plotted (**Plot 3**). This plot should show significant attenuation of frequencies above the 1000 *Hz* cutoff.

    Finally, the filtered signal is converted back to the time domain and plotted (**Plot 4**) to show the final waveform.

    ```matlab
    % Apply the filter
    audio_filtered = filter(b, a, audio);

    % Analyze filtered signal in frequency domain (Plot 3)
    Y_filtered = fft(audio_filtered);
    figure;
    plot(f, abs(Y_filtered)/N);
    xlim([0 fs/2]);
    title('Plot 3: Frequency Spectrum After IIR Filtering');

    % Plot filtered signal in time domain (Plot 4)
    audio_ifft = real(ifft(Y_filtered)); % Equivalent to audio_filtered
    figure;
    plot(t, audio_ifft);
    title('Plot 4: Signal After Filtering (Time Domain)');
    ```

5. **Playback and Save**

    For auditory comparison, the script plays the original audio and the filtered audio sequentially. The resulting clean audio is then saved as a new file named `iir_result.wav`.

    ```matlab
    % Play Audio
    sound(audio, fs); % Original
    pause(length(audio)/fs);
    sound(audio_filtered, fs); % Filtered

    % Save Filtered Audio
    audiowrite('iir_result.wav', audio_filtered, fs);
    ```

## Generated Plots

- **Plot 1: Original Signal with Noise (Time Domain)**

    Shows the amplitude of the original audio signal over time. Noise is often visible as rapid, high-amplitude fluctuations.

- **Plot 2: Original Signal Frequency Spectrum**

    Shows the magnitude of each frequency component in the original signal. High-frequency noise will appear as significant magnitudes in the higher frequency range.

- **Plot 3: Frequency Spectrum After IIR Filtering**

    Shows the frequency spectrum of the signal after the low-pass filter has been applied. Note the sharp drop in magnitude for frequencies above the 1000 *Hz* cutoff.

- **Plot 4: Signal After Filtering (Time Domain)**

    Shows the amplitude of the filtered audio signal over time. The waveform should appear smoother compared to Plot 1, as the high-frequency noise has been removed.
