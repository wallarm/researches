iterator = tf.data.Iterator.from_structure(train_dataset.output_types,
                                           train_dataset.output_shapes)
next_elements = iterator.get_next()

training_init_op = iterator.make_initializer(train_dataset, name="training_init_op")
validation_init_op = iterator.make_initializer(valid_dataset, name="validation_init_op")

x, y = next_elements