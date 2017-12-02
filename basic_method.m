clc; clear; close all;
load('EEGdata.mat');
data = EEGdata;
Electrodes={'AF3', 'F3', 'FC5', 'FC6', 'F4', 'AF4'};
sr = 128; % Sampling frequency
num_channels = 6;
num_epochs = size(data,2)/(sr*5);  % 5 second data samples
epochs_NS = sr*5;
lowEnd_delta  = 2;  % Hz
highEnd_delta = 4;  % Hz
lowEnd_theta  = 4;  % Hz
highEnd_theta = 8;  % Hz
lowEnd_alpha  = 8;  % Hz
highEnd_alpha = 13; % Hz
lowEnd_Lbeta  = 13; % Hz
highEnd_Lbeta = 18; % Hz
lowEnd_Hbeta  = 18; % Hz
highEnd_Hbeta = 30; % Hz
lowEnd_gamma  = 30; % Hz
highEnd_gamma = 50; % Hz
filterOrder = 10; % Filter order

for index=1:num_channels
    for jndex=1:num_epochs
        %% separate trial
        if (jndex < num_epochs )
            epochs(1:epochs_NS) = data(index,((jndex-1)*epochs_NS+1):(jndex*epochs_NS));
        else
            epochs(1:epochs_NS)=0;
            % epochs = data(index,((jndex-1)*epochs_NS+1):end);
        end
        
        %% filtering and calculation of power in each band
        % delta 
        [b, a] = butter(filterOrder, [lowEnd_delta highEnd_delta]/(sr/2), 'bandpass'); % Generate filter coefficients
        data_filter_delta(1:epochs_NS) = filtfilt(b, a, epochs); % Apply filter to data using zero-phase filtering       
        delta_power = 0;
        for sample = 1:epochs_NS
            delta_power = delta_power + data_filter_delta(sample)* data_filter_delta(sample);
        end
        
        % theta
        [b, a] = butter(filterOrder, [lowEnd_theta highEnd_theta]/(sr/2), 'bandpass'); % Generate filter coefficients
        data_filter_thata(1:epochs_NS) = filtfilt(b, a, epochs); % Apply filter to data using zero-phase filtering   
        tetha_power = 0;
        for sample = 1:epochs_NS
            theta_power = tetha_power + data_filter_thata(sample)* data_filter_thata(sample);
        end
        
        % alpha
        [b, a] = butter(filterOrder, [lowEnd_alpha highEnd_alpha]/(sr/2), 'bandpass'); % Generate filter coefficients
        data_filter_alpha(1:epochs_NS) = filtfilt(b, a, epochs); % Apply filter to data using zero-phase filtering 
        alpha_power = 0;
        for sample = 1:epochs_NS
            alpha_power = alpha_power + data_filter_alpha(sample)* data_filter_alpha(sample);
        end
        
        % low beta
        [b, a] = butter(filterOrder, [lowEnd_Lbeta highEnd_Lbeta]/(sr/2), 'bandpass'); % Generate filter coefficients
        data_filter_Lbeta = filtfilt(b, a, epochs); % Apply filter to data using zero-phase filtering        
        Lbeta_power = 0;
        for sample = 1:epochs_NS
            Lbeta_power = Lbeta_power + data_filter_Lbeta(sample)* data_filter_Lbeta(sample);
        end
        
        % high beta
        [b, a] = butter(filterOrder, [lowEnd_Hbeta highEnd_Hbeta]/(sr/2), 'bandpass'); % Generate filter coefficients
        data_filter_Hbeta(1:epochs_NS) = filtfilt(b, a, epochs); % Apply filter to data using zero-phase filtering        
        Hbeta_power = 0;
        for sample = 1:epochs_NS
            Hbeta_power = Hbeta_power + data_filter_Hbeta(sample)* data_filter_Hbeta(sample);
        end
        
        % gamma
        [b, a] = butter(filterOrder, [lowEnd_gamma highEnd_gamma]/(sr/2), 'bandpass'); % Generate filter coefficients
        data_filter_gamma(1:epochs_NS) = filtfilt(b, a, epochs); % Apply filter to data using zero-phase filtering        
        gamma_power = 0;
        for sample = 1:epochs_NS
            gamma_power = gamma_power + data_filter_gamma(sample)* data_filter_gamma(sample);
        end
        
        %% form feature vector for adhd lack of attention
        % using 3 indicator. lower value for each indicator is what we aim during NF
        theta2alpha = theta_power/alpha_power;
        theta2Lbeta = theta_power/Lbeta_power;
        theta2Hbeta = theta_power/Hbeta_power;
        
    end
end


