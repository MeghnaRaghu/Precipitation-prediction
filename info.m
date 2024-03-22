% Specify the path to the HDF5 file
hdf5_file = 'C:\Users\meghn\OneDrive\Desktop\Internship\Datasets\INSAT june 2021';

% Obtain information about the contents of the HDF5 file
file_info = h5info(hdf5_file);

% Display the hierarchy of the HDF5 file
disp('Contents of the HDF5 file:');
disp(file_info);

% Navigate through the groups and datasets in the HDF5 file
for i = 1:length(file_info.Groups)
    group_name = file_info.Groups(i).Name;
    disp(['Group: ', group_name]);
    
    group_info = file_info.Groups(i);
    for j = 1:length(group_info.Datasets)
        dataset_name = group_info.Datasets(j).Name;
        dataset_info = group_info.Datasets(j);
        
        % Read the data from the dataset
        data = h5read(hdf5_file, dataset_info.Name);
        
        % Display dataset information
        disp(['Dataset: ', dataset_name]);
        disp(['Size: ', num2str(size(data))]);
        disp(['Data:']);
        disp(data); % Display the data
        
        % Optionally, you can visualize or process the data further here
        
    end
end
