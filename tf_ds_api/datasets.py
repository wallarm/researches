x_ph = tf.placeholder(tf.int32, [None]+list(train_x.shape[1:]), name="x")
y_ph = tf.placeholder(tf.int32, [None]+list(train_y.shape[1:]), name="y")

train_dataset = tf.data.Dataset.from_tensor_slices((x_ph, y_ph)).shuffle(buffer_size=10000).batch(BATCH_SIZE)
valid_dataset = tf.data.Dataset.from_tensor_slices((x_ph, y_ph)).batch(BATCH_SIZE)

