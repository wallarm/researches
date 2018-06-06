class Model(object):
    def __init__(self, x, y,
                learning_rate=1e-4, optimizer=tf.train.AdamOptimizer, run_dir="./run"):
        hidden_layer_0 = tf.layers.dense(x, 1024, activation=tf.nn.relu)
        hidden_layer_1 = tf.layers.dense(hidden_layer_0, 784, activation=tf.nn.relu)
        hidden_layer_2 = tf.layers.dense(hidden_layer_1, 512, activation=tf.nn.relu)
        logits = tf.layers.dense(hidden_layer_2, 10, activation=tf.nn.softmax)
        self._loss = tf.losses.softmax_cross_entropy(tf.one_hot(y, 10), logits)
        self._global_step = tf.Variable(0, trainable=False, name="global_step")
        
        self._train_op = tf.contrib.layers.optimize_loss(loss=self._loss, 
                                                    optimizer=optimizer, 
                                                    global_step=self._global_step, 
                                                    learning_rate=learning_rate, 
                                                    name="train_op",
                                                    summaries=['loss'])
        
        self._summaries = tf.summary.merge_all()
        
        if not os.path.exists(run_dir):
            os.mkdir(run_dir)
        if not os.path.exists(os.path.join(run_dir, "checkpoints")):
            os.mkdir(os.path.join(run_dir, "checkpoints"))
        self._run_dir = run_dir
        self._saver = tf.train.Saver(max_to_keep=1)