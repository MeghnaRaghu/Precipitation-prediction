folder = dir("*.h5");
lat_grid = 6:2:16;
lon_grid = 70:2:80;

% Initialize grid_mat to store the mean values of IMC
grid_mat = NaN(length(lon_grid)-1, length(lat_grid)-1, length(folder));

for n = 1:length(folder)
    FILENAME = folder(n).name;
    Longitude = double(h5read(FILENAME,'/Longitude'));
    Latitude = double(h5read(FILENAME,'/Latitude'));
    IMC = h5read(FILENAME,'/IMC');
    
    % Ensure Longitude and Latitude are column vectors
    Longitude = Longitude(:);
    Latitude = Latitude(:);
    
    % Create a grid for IMC
    [Longitude_grid, Latitude_grid] = meshgrid(Longitude, Latitude);
    
    for k = 1:length(lon_grid)-1
        for j = 1:length(lat_grid)-1
            % Find indices of Longitude and Latitude within the grid cell
            indices = Longitude_grid >= lon_grid(k) & Longitude_grid < lon_grid(k+1) & ...
                      Latitude_grid >= lat_grid(j) & Latitude_grid < lat_grid(j+1);
            
            % Extract IMC values within the grid cell
            IMC_subset = IMC(indices);
            
            % Check if any valid data points exist
            if ~isempty(IMC_subset)
                % Calculate the mean IMC within the grid cell
                grid_mat(k,j,n) = mean(IMC_subset, 'omitnan');
            end
        end
    end
end

grid_mat_transposed = permute(grid_mat, [2, 1, 3]);

% Plot the transposed grid_mat
figure;
pcolor(lon_grid(2:end), lat_grid(2:end), grid_mat(:,:,1)); % Assuming you want to plot the first dataset
shading interp;
xlabel('Longitude');
ylabel('Latitude');
title('Precipitaion Data(IMC)');
colorbar;