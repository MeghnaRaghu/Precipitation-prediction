% Specify the folder path
folder_path = 'C:\Users\meghn\OneDrive\Desktop\Internship\Datasets\INSAT june 2021';

% List all files in the folder
files = dir(fullfile(folder_path, '*.h5'));

% Display information about HDF5 files
disp('HDF5 files in the folder:');
for i = 1:length(files)
    disp(files(i).name);
end
