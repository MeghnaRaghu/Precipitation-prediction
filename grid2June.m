% Specify the folder where your files are stored
folder_path = 'C:\Users\meghn\OneDrive\Desktop\Internship\Datasets\INSAT june 2021'; % Replace 'path_to_your_folder' with the actual path

% List all files in the folder
file_list = dir(fullfile(folder_path, '*.h5'));

% Initialize variables for gridding
lat_grid = 5:0.5:20;
lon_grid = 70:0.5:85;
mean_grid_mat = zeros(length(lon_grid)-1, length(lat_grid)-1);

% Loop through each file and compute mean grid
for i = 1:numel(file_list)
    file_name = fullfile(folder_path, file_list(i).name);
    
    % Read latitude, longitude, and precipitation data from the current file
    Longitude = double(h5read(file_name, '/Longitude'));
    Latitude = double(h5read(file_name, '/Latitude'));
    IMC = h5read(file_name, '/IMC');
    
    % Compute the mean grid for the current file
    grid_mat = zeros(length(lon_grid)-1, length(lat_grid)-1);
    for j = 1:length(lon_grid)-1
        for k = 1:length(lat_grid)-1
            grid_mat(j,k) = mean(mean(IMC(Latitude > lat_grid(k) & Latitude <= lat_grid(k+1), Longitude > lon_grid(j) & Longitude <= lon_grid(j+1)),'omitnan'),'omitnan');
        end
    end
    
    % Accumulate the mean grid from the current file to calculate the overall mean
    mean_grid_mat = mean_grid_mat + grid_mat;
end

% Compute the mean of the accumulated mean grids from all files
mean_grid_mat = mean_grid_mat / numel(file_list);

% Plot the mean gridded data
figure;
pcolor(lon_grid(2:end), lat_grid(2:end), mean_grid_mat');
shading interp;
geoshow(coast.lat, coast.long, 'Color', 'k', 'linewidth', 1.5);
caxis([0 50]); % Set color axis to match the range of precipitation values
colorbar;
title('Mean Gridded Precipitation');
