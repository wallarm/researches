train_x, train_y = preprocessing_as_np(train_data)
test_x, test_y = preprocessing_as_np(test_data)

np.savez(os.path.join(dataset_path, "train"), 
    x=train_x,
    y=train_y)

np.savez(os.path.join(dataset_path, "test"), 
    x=test_x,
    y=test_y)