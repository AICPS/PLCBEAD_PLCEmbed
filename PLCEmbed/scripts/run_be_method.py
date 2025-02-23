import os, sys, torch
from random import random, randint, choices
sys.path.append(os.path.dirname(sys.path[0]))
import pickle
from sklearn.model_selection import train_test_split
from core.model import *
from core.trainer import *
from torch_geometric.data import DataLoader
from argparse import ArgumentParser
import warnings
warnings.filterwarnings("ignore")
 
PADDED_VAL = 256

class Config:
    '''Configuration and Argument Parser for script to train the classification.'''
    def __init__(self, args):
        self.parser = ArgumentParser(description='The parameters for training the scene graph using GCN.')
        
        ## general 
        self.parser.add_argument('--seed', default=1, type=int, help='seed for random train test split')
        self.parser.add_argument('--epochs', type=int, default=100, help='Number of epochs to train.')
        self.parser.add_argument('--batch_size', type=int, default=32, help='Number of graphs in a batch.')
        self.parser.add_argument('--device', type=str, default="cuda", help='The device to run on models (cuda or cpu) cpu in default.')
        self.parser.add_argument('--test_step', type=int, default=5, help="The interval between mini evaluation along the training process.")
        self.parser.add_argument('--precache_path', type=str, default='./rnn_data.pkl', help="Path to networkx graphs.")
        self.parser.add_argument('--test_size', type=float, default=0.2, help="Test size")
        self.parser.add_argument('--wandb_enable', action='store_true', help='Use wandb')
        self.parser.add_argument('--wandb_project', type=str, default="bi4rensic", help="wandb project name.")
        self.parser.add_argument('--wandb_entity', type=str, default="aicpslab", help="wandb project entity.")

        ## model selections
        self.parser.add_argument('--model', type=str, default="transformer", help="[transformer]")
        self.parser.add_argument('--mode', type=str, default="normal", help='[normal|random_k|none]')

        ## hyperparameters
        self.parser.add_argument('--learning_rate', default=0.0001, type=float, help='The initial learning rate for GCN.')
        self.parser.add_argument('--hidden_dim', type=int, default=32, help='Number of hidden units in RNN.')
        self.parser.add_argument('--dropout', type=float, default=0.1, help='Dropout rate (1 - keep probability).')
        self.parser.add_argument('--num_layers', type=int, default=1, help="Number of layers in the RNN.")
        self.parser.add_argument('--window_size', type=int, default=10, help="Number of bytes sampled for MalConv and Transformer model")
        self.parser.add_argument('--n_value', type=int, default=1000, help='The value of n')
        self.parser.add_argument('--k_value', type=int, default=5, help='Number of chunks of random bytes taken')
        
        args_parsed = self.parser.parse_args(args)
        
        for arg_name in vars(args_parsed):
            self.__dict__[arg_name] = getattr(args_parsed, arg_name)
        
        if self.wandb_enable:
            self.wandb_ = wandb.init(project=self.wandb_project, name="%s_pkl-%s_nValue-%d_seed-%d_hiddenDim-%d_batchSize-%d_numLayers-%d_mode-%s_window_size-%d"% (str(self.model), self.precache_path ,self.n_value, self.seed, self.hidden_dim, self.batch_size, self.num_layers, self.mode, self.window_size), entity=self.wandb_entity)
            self.wandb_config = wandb.config
        else: 
            self.wandb_ = None
            self.wandb_config = None

if __name__ == "__main__":
    """ 
        $ python scripts/run_be_method.py --model  [rnn|gru|lstm|malconv] --precache_path [path to packed binary] 
                            --wandb_enable  --wandb_project [wandb project name] 
                            --wandb_entity [wandb project entity]

        $ python scripts/run_be_method.py --model  rnn --precache_path  rnn_data.pkl
                            --wandb_enable --batch_size 4
    """

    cfg = Config(sys.argv[1:])
    with open(cfg.precache_path, 'rb') as pkl:
        data_preprocessor = pickle.load(pkl)
        
    dataset = []
    normal_dataset = []
    data = data_preprocessor.data
    label2idx = data_preprocessor.label2idx

    for sequence, label, bin_name, program_name in zip(data[0], data[1], data[2], data[3]):
        dataset.append((torch.ByteTensor(list(sequence)), label, bin_name, program_name))
        normal_dataset.append ((torch.ByteTensor(list(sequence)), label))

    labels = [label for _, label in zip(data[0], data[1])]
    train_dataset, test_dataset = train_test_split(normal_dataset, test_size=cfg.test_size, shuffle=True, stratify=labels, random_state=cfg.seed)
    class_weights = [ 1 - (count / sum(data_preprocessor.stats.values())) for label, count in data_preprocessor.stats.items()]
    model_length = 0

    if cfg.mode == 'normal':
        model_length = cfg.n_value
        rand_train_dataset = []
        for sequence, label in train_dataset:

            n = len(sequence)//cfg.n_value
            for i in range(n):
                tmp = sequence[i*cfg.n_value: (i+1)*cfg.n_value]
                sequence_ = torch.cat([tmp,torch.ByteTensor([PADDED_VAL]*(cfg.n_value - len(tmp)))], 0)
                rand_train_dataset.append((sequence_, label))
        rand_test_dataset = []
        for sequence, label in test_dataset:
            n = len(sequence)//cfg.n_value
            for i in range(n):
                tmp = sequence[i*cfg.n_value: (i+1)*cfg.n_value]
                sequence_ = torch.cat([tmp,torch.ByteTensor([PADDED_VAL]*(cfg.n_value - len(tmp)))], 0)
                rand_test_dataset.append((sequence_, label))
    
    elif cfg.mode == 'random_k':
        model_length = cfg.n_value
        rand_train_dataset = []
        for sequence, label in train_dataset:

            n = len(sequence)//cfg.n_value
            for i in choices(range(n), k=cfg.k_value):
                tmp = sequence[i*cfg.n_value: (i+1)*cfg.n_value]
                sequence_ = torch.cat([tmp,torch.ByteTensor([PADDED_VAL]*(cfg.n_value - len(tmp)))], 0)
                rand_train_dataset.append((sequence_, label))
        rand_test_dataset = []
        for sequence, label in test_dataset:
            n = len(sequence)//cfg.n_value
            for i in choices(range(n), k=cfg.k_value):
                tmp = sequence[i*cfg.n_value: (i+1)*cfg.n_value]
                sequence_ = torch.cat([tmp,torch.ByteTensor([PADDED_VAL]*(cfg.n_value - len(tmp)))], 0)
                rand_test_dataset.append((sequence_, label))
        
    elif cfg.mode == 'none':
        model_length = max([len(seq) for seq, label in train_dataset] + [len(seq) for seq, label in test_dataset])
        rand_train_dataset = []
        for seq, label in train_dataset:
            padded_seq = torch.cat([seq, torch.ByteTensor([PADDED_VAL]*(model_length - len(seq)))], 0)
            rand_train_dataset.append((padded_seq, label))
        rand_test_dataset = []
        for seq, label in test_dataset:
            padded_seq = torch.cat([seq,torch.ByteTensor([PADDED_VAL]*(model_length - len(seq)))], 0)
            rand_test_dataset.append((padded_seq, label))

    elif cfg.mode == 'first_k':
        model_length = cfg.n_value
        rand_train_dataset = []
        for seq, label in train_dataset:
            tmp = seq[0: cfg.n_value]
            padded_seq = torch.cat([tmp, torch.ByteTensor([PADDED_VAL]*(model_length - len(tmp)))], 0)
            rand_train_dataset.append((padded_seq, label))
        rand_test_dataset = []
        for seq, label in test_dataset:
            tmp = seq[0: cfg.n_value]
            padded_seq = torch.cat([tmp,torch.ByteTensor([PADDED_VAL]*(model_length - len(tmp)))], 0)
            rand_test_dataset.append((padded_seq, label))
    
    elif cfg.mode == 'last_k':
        model_length = cfg.n_value
        rand_train_dataset = []
        for seq, label in train_dataset:
            if len(seq) < model_length:
                tmp = seq[0: cfg.n_value]
                padded_seq = torch.cat([tmp, torch.ByteTensor([PADDED_VAL]*(model_length - len(tmp)))], 0)
            else:
                padded_seq = seq[-cfg.n_value:-1]
            rand_train_dataset.append((padded_seq, label))
        rand_test_dataset = []
        for seq, label in test_dataset:
            if len(seq) < model_length:
                tmp = seq[0: cfg.n_value]
                padded_seq = torch.cat([tmp,torch.ByteTensor([PADDED_VAL]*(model_length - len(tmp)))], 0)
            else:
                padded_seq = seq[-cfg.n_value:-1]
            rand_test_dataset.append((padded_seq, label))

    batched_train_dataset = DataLoader(rand_train_dataset, batch_size=cfg.batch_size, shuffle=True)
    batched_test_dataset  = DataLoader(rand_test_dataset,  batch_size=cfg.batch_size, shuffle=True)

    if cfg.model == "transformer":
        model = BeTransformer(cfg.dropout, cfg.hidden_dim, cfg.num_layers, cfg.window_size, cfg.k_value, data_preprocessor.num_of_classes, model_length) # 5, 10, 20, 50, 
    else:
        raise Exception("No specific model is chosen.")
    model = model.to(cfg.device)
    print('Total params: ', sum(p.numel() for p in model.parameters() if p.requires_grad))

    test_table = wandb.Table(columns=["prediction", "truth"], allow_mixed_types=True)
    trainer = Trainer(cfg, model, test_table, label2idx)
    best_results = trainer.train(batched_train_dataset, batched_test_dataset, class_weights=class_weights)
    print("Performance for testing set.")
    pprint.pprint(best_results)