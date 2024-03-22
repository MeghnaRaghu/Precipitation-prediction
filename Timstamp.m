% Specify the directory containing the dataset files
directory = 'C:\Users\meghn\OneDrive\Desktop\Internship\Datasets\INSAT june all 2021';
lat_grid = 8:0.5:13;
lon_grid = 74:0.5:79;
% Get a list of .h5 files in the directory
file_list = dir(fullfile(directory, '*.h5'));
num_files = numel(file_list);

% Preallocate arrays to store mean IMR values, GMT time, and date information
mean_IMC  = NaN(length(lon_grid)-1, length(lat_grid)-1, num_files);
gmt_time = zeros(num_files, 1);
date_info = cell(num_files, 1);

% Iterate through each file
for file = 1:num_files
    FILENAME = fullfile(directory, file_list(file).name);
    IMC = double(h5read(FILENAME, '/IMC'));
    Longitude = double(h5read(FILENAME,'/Longitude'))* 0.010000;
    Latitude = double(h5read(FILENAME,'/Latitude'))*  0.010000;

   

    % Extract GMT time from the filename
    filename = file_list(file).name;
    split_filename = strsplit(filename, '_');
    gmt_str = split_filename{3}; % Extract the GMT string
    gmt_time(file) = str2double(gmt_str) / 100; % Convert to hours
    
    % Extract date information from the file name
    [~, filename, ~] = fileparts(FILENAME);
    date_str = filename(7:15); % Extract the substring representing the date
    date_info{file} = date_str;
    
    % Exclude fill values (-999.000000) before calculating the mean
    % Remove fill values (-999)
    IMC(IMC == -999) = NaN;
    for k = 1:length(lon_grid)-1
        for j = 1:length(lat_grid)-1
            % Find indices of Longitude and Latitude within the grid cell
            indices = Longitude >= lon_grid(k) & Longitude < lon_grid(k+1) & ...
                      Latitude >= lat_grid(j) & Latitude < lat_grid(j+1);
            
            % Extract IMR values within the grid cell
            IMC_subset = IMC(indices);
            
            % Calculate the mean IMR within the grid cell
            mean_IMC(k,j,file) = mean(IMC_subset, 'omitnan');
        end
    end
end

% Identify unique dates from the date information
unique_dates = unique(date_info);
nDay=[];
for l=1:length(unique_dates)
    nDay(l)=str2double(unique_dates{l}(1:2));
end


% Calculate mean IMR for each unique date
num_days = numel(unique_dates);
mean_imc_per_day_june = zeros(num_days, 1);
for day = 1:num_days
    % Find indices corresponding to the current date
    date_indices = strcmp(date_info, unique_dates{day});
    
    % Initialize the daily mean IMR
    daily_mean_IMC = [];
    
    % Iterate through each file corresponding to the current day
    for file = find(date_indices)'
        % Append mean IMR values for the current day
        daily_mean_IMC = [daily_mean_IMC; mean_IMC(:,:,file)];
    end
    
    % Calculate the mean IMR for the current day
    mean_imc_per_day_june(day) = mean(daily_mean_IMC(:), 'omitnan');
end

% Now, you have mean_imr_per_day_june, which contains mean IMR values for each day.
% You can further process or visualize this data as needed.

figure;
plot(nDay, mean_imc_per_day_june, 'o-', 'LineWidth', 2);
xlabel('Day of June');
ylabel('Mean IMC(mm)');
ylim([0,0.5]);
title('Mean Precipitation for Each Day of June 2023');
grid on;