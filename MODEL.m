% Specify the folder containing the .h5 files
folder_path = 'C:\Users\meghn\OneDrive\Desktop\Internship\Datasets\INSAT june 2021';  % Update with your folder path

% Get a list of all .h5 files in the folder
file_list = dir(fullfile(folder_path, '*.h5'));

% Initialize variables to store data from all files
all_data = cell(90, 1); % Assuming you have 90 files

% Loop through each file
for file_index = 1:numel(file_list)
    % Load data from the current file
    filename = fullfile(folder_path, file_list(file_index).name);
    data = h5read(filename, '/IMC'); % Assuming dataset is named '/IMC'
    
    % Preprocess the data if needed
    % For example, handle missing values or normalize the data
    
    % Store the data in the cell array
    all_data{file_index} = data;
end

% Combine data from adjacent files into two-day datasets
two_day_data = cell(45, 1);
for i = 1:45
    two_day_data{i} = [all_data{2*i-1}; all_data{2*i}];
end

% Concatenate data from all two-day datasets into a single array
concatenated_data = cat(1, two_day_data{:});

% Split the concatenated data into features (IMC values) and target
X = concatenated_data(:, 1:end-1); % Features (all except the last column)
y = concatenated_data(:, end); % Target (last column)

% Split the data into training and testing sets
rng(1); % For reproducibility
cv = cvpartition(size(X, 1), 'HoldOut', 0.2);
idx_train = cv.training;
idx_test = cv.test;
X_train = X(idx_train, :);
y_train = y(idx_train, :);
X_test = X(idx_test, :);
y_test = y(idx_test, :);

% Train a decision tree model
tree = fitrtree(X_train, y_train);

% Evaluate the model
y_pred = predict(tree, X_test);

% Evaluate the accuracy (you may use different evaluation metrics)
mse = mean((y_pred - y_test).^2);

disp(['Mean Squared Error: ' num2str(mse)]);

% Predict next day precipitation
% Assuming you want to predict the next day's precipitation based on the last day's data
last_day_data = concatenated_data(end, :); % Get data for the last day
X_new = last_day_data(1:end-1); % Features for the last day
next_day_precipitation = predict(tree, X_new);

disp(['Next day precipitation prediction: ' num2str(next_day_precipitation)]);
