% Define the directory containing .h5 files
directory = 'C:\Users\meghn\OneDrive\Desktop\Internship\Datasets\INSAT june 2021';

% Get a list of .h5 files in the directory
file_list = dir(fullfile(directory, '*.h5'));
num_files = numel(file_list);

% Preallocate arrays to store mean IMR values and time
mean_IMR = zeros(num_files, 1);
time = 1:num_files;

% Iterate through each file
for n = 1:num_files
    FILENAME = fullfile(directory, file_list(n).name);
    IMC = h5read(FILENAME, '/IMC');

    % Exclude fill values (-999.000000) before calculating the mean
    valid_indices = IMC(:) ~= -999.000000;
    mean_IMC(n) = mean(IMC(valid_indices), 'omitnan');
end

% Plot the 2D plot
figure;
plot(time, mean_IMC, 'bo-', 'LineWidth', 2);
xlabel('Time');
ylabel('Mean IMC');
title('Mean IMC vs Time');
grid on;