% Define latitude and longitude ranges for Kerala
lat_min = 8.0;
lat_max = 12.5;
lon_min = 74.0;
lon_max = 77.5;

% Define latitude and longitude grid for Kerala
lat_grid_kerala = lat_min:0.1:lat_max; % Adjust the resolution as needed
lon_grid_kerala = lon_min:0.1:lon_max; % Adjust the resolution as needed

% Initialize the grid_mat for Kerala
grid_mat_kerala = zeros(length(lon_grid_kerala)-1, length(lat_grid_kerala)-1);

% Loop through the longitude and latitude grid for Kerala
for j = 1:length(lon_grid_kerala)-1
    for k = 1:length(lat_grid_kerala)-1
        % Find indices within the specified latitude and longitude range
        lon_indices = find(Longitude > lon_grid_kerala(j) & Longitude <= lon_grid_kerala(j+1));
        lat_indices = find(Latitude > lat_grid_kerala(k) & Latitude <= lat_grid_kerala(k+1));
        
        % Check if any indices are found
        if ~isempty(lon_indices) && ~isempty(lat_indices)
            % Calculate the mean of the data within the current grid cell
            grid_mat_kerala(j,k) = mean(mean(IMC(lat_indices,lon_indices), 'omitnan'),'omitnan');
           % grid_mat_kerala(j,k) = mean(mean(HQprecipitation(lon_indices, lat_indices), 'omitnan'), 'omitnan');
        end
    end
end

% Plot the gridded data for Kerala
figure;
pcolor(lon_grid_kerala(2:end), lat_grid_kerala(2:end), grid_mat_kerala')
shading interp;
xlabel('Longitude');
ylabel('Latitude');
title('Mean Gridded Precipitation for Kerala');
colorbar;

% Overlay coastline
geoshow(coast.lat, coast.long, 'Color', 'k', 'linewidth', 1.5);
