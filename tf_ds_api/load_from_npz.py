with np.load(os.path.join(dataset_path, "train.npz")) as data:
    train_x=data['x']
    train_y=data['y']

with np.load(os.path.join(dataset_path, "test.npz")) as data:
    train_x=data['x']
    train_y=data['y']