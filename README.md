# MCT Assignment
This is a GUI based MATLAB app created to demonstrate a communication system model.
Just install MCT_Assignment.mlapp in MATLAB and run it.

## Features :
Input is user defined - 
1. Random bits stream
2. Text File
3. Grayscale Image
4. Audio file

Make sure the input file is in the current open MATLAB directory.

Channel coding :
1. (7,4) Hamming Code
2. BCH (127,64) Code

Modulation :
1. 16 FSK
2. 16 QAM
3. 16 PSK
4. 32 QAM

The transmitted data parameters after modulation stage can be viewed as:
1. Constellation diagram (for 16 PSK and 16 QAM)
2. Time domain graph
3. PSD

Channel transmission effects are simulated using AWGN noise added to the transmitted data obtained after modulation. The app plots the final BER curves (theoretical+simulated) for fixed SNR, but the feature to plot BER curves for different SNR values can be added. 
After demodulating received Signal (transmitted signal with AWGN added), user has the option to reconstruct the file.
