clc; clear; close all;
load('EEGdata.mat');
data = EEGdata;

Electrodes={'AF3', 'F3', 'FC5', 'FC6', 'F4', 'AF4'};
sr = 128; % Sampling frequency
num_channels = 6;
num_epochs = 5*size(data,2)/sr;  % 5 second data samples

%% trialization
epochs(num_channels,num_epochs,sr)=0;
sigma(num_channels)=0;
for index=1:num_channels
    for jndex=1:num_epochs
        epochs(index,jndex,:) = data(index,((jndex-1)*sr+1):(jndex*sr));
    end
end
%% filtering
lowEnd = 4; % Hz
highEnd = 8; % Hz
filterOrder = 10; % Filter order (e.g., 2 for a second-order Butterworth filter). Try other values too
[b, a] = butter(filterOrder, [lowEnd highEnd]/(sr/2), 'bandpass'); % Generate filter coefficients
for index=1:num_channels
    for jndex=1:num_epochs
        data_filter_thata(index,jndex,:) = filtfilt(b, a, epochs(index,jndex,:)); % Apply filter to data using zero-phase filtering        
    end
end
temp(:) = epochs(1,1,:);
figure;
plot(temp(:));
temp(:) = data_filter_thata(1,1,:);
figure;
plot(temp(:));

lowEnd = 8; % Hz
highEnd = 13; % Hz
[b, a] = butter(filterOrder, [lowEnd highEnd]/(sr/2), 'bandpass'); % Generate filter coefficients
data_filter_alpha = filtfilt(b, a, data); % Apply filter to data using zero-phase filtering

lowEnd = 13; % Hz
highEnd = 18; % Hz
[b, a] = butter(filterOrder, [lowEnd highEnd]/(sr/2), 'bandpass'); % Generate filter coefficients
data_filter_low_beta = filtfilt(b, a, data); % Apply filter to data using zero-phase filtering

lowEnd = 18; % Hz
highEnd = 30; % Hz
[b, a] = butter(filterOrder, [lowEnd highEnd]/(sr/2), 'bandpass'); % Generate filter coefficients
data_filter_high_beta = filtfilt(b, a, data); % Apply filter to data using zero-phase filtering
