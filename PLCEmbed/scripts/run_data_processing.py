import os, sys, pickle
sys.path.append(os.path.dirname(sys.path[0]))
from pathlib import Path
from argparse import ArgumentParser
from core.dataProcessor import *


class Config:
    '''Configuration and Argument Parser for script to train the classification.'''
    def __init__(self, args):
        self.parser = ArgumentParser(description='parameters')
        self.parser.add_argument('--data_dir', type=str, default='../dataset', help="Path to the compiled data.")
        self.parser.add_argument('--pkl_path', type=str, default='./4_toolchains_dataset.pkl', help="Path to networkx graphs.")
        self.parser.add_argument('--dataset_type', type=str, default='tp', help="Select which dataset to generate")
        self.parser.add_argument('--csv_path', type=str, default='./dataset/labels.csv', help="Select which dataset to generate")

        args_parsed = self.parser.parse_args(args)

        for arg_name in vars(args_parsed):
            self.__dict__[arg_name] = getattr(args_parsed, arg_name)

        self.binary_data_path = Path(self.data_dir).resolve()


if __name__ == "__main__":
    cfg = Config(sys.argv[1:])
    data_processor = BinaryDataProcessor(cfg)
    data_processor.get_dataset()
    pickle.dump(data_processor, open(cfg.pkl_path, 'wb'))
    data_processor.print_stats()