% Specify the path to the HDF5 file
hdf5_file = 'C:\Users\meghn\OneDrive\Desktop\Internship\Datasets\INSAT june 2021\3RIMG_04JUN2021_2345_L2B_IMC_V01R00.h5';

% Obtain information about the HDF5 file
file_info = h5info(hdf5_file);

% Display the hierarchy of the HDF5 file
disp('Contents of the HDF5 file:');
disp(file_info);
