import pprint
import pandas as pd


class BinaryDataProcessor:
    def __init__(self, cfg): 
        self.binary_data_path = cfg.binary_data_path / "bins"
        self.labels_info = pd.read_csv(cfg.csv_path)
        self.dataset_type = cfg.dataset_type
        self.data = []
        
        if self.dataset_type == "tp":
            self.labels = set(self.labels_info.loc[:,"ToolchainName"].tolist())
            
        elif self.dataset_type == "func":
            self.labels = set(self.labels_info.loc[:,"FuncLabels"].tolist())

        else:
            raise Exception("Not supported dataset_type.")

        self.stats = {label:0 for label in self.labels}
        self.label2idx = {label:i for i, label in enumerate(self.labels)}
        self.idx2label = {i:label for i, label in enumerate(self.labels)}
        self.num_of_classes = len(self.label2idx)
        
        self.binname2idx  = {name:i for i, name in enumerate(self.labels_info.loc[:, "BinaryName"].tolist())}
        self.idx2binname  = {i:name for i, name in enumerate(self.labels_info.loc[:, "BinaryName"].tolist())}
        self.progname2idx  = {name:i for i, name in enumerate(self.labels_info.loc[:, "ProgramName"].tolist())}
        self.idx2progname  = {i:name for i, name in enumerate(self.labels_info.loc[:, "ProgramName"].tolist())}

    def print_stats(self):
        print("label index mappings:")
        pprint.pprint(self.idx2label)
        print("=====================")
        print("data stats:")
        pprint.pprint(self.stats)
        print("=====================")
        print('# of classes: ' + str(len(self.stats)))

    def read_binary(self, binary_data_path):
        if not binary_data_path.exists():
            raise Exception("%s does not exist." % binary_data_path)
        return open(str(binary_data_path), "rb").read()

    def get_dataset(self):
        self.data = [[self.read_binary(self.binary_data_path/x) for x in self.labels_info.loc[:,"BinaryName"].tolist()]]
        if self.dataset_type == "tp":
            self.data.append([self.label2idx[x] for x in self.labels_info.loc[:,"ToolchainName"].tolist()])
            for toolchain_name in self.labels_info.loc[:,"ToolchainName"].tolist():
                self.stats[toolchain_name] += 1
        
        elif self.dataset_type == "func":
            self.data.append([self.label2idx[x] for x in self.labels_info.loc[:,"FuncLabels"].tolist()])
            for func_name in self.labels_info.loc[:,"FuncLabels"].tolist():
                self.stats[func_name] += 1

        self.data.append([self.binname2idx[x] for x in self.labels_info.loc[:,"BinaryName"].tolist()])
        self.data.append([self.progname2idx[x] for x in self.labels_info.loc[:,"ProgramName"].tolist()])