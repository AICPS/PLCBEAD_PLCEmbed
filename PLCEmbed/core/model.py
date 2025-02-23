import torch
import torch.nn as nn
import torch.nn.functional as F
from torch_geometric.nn import GCNConv, global_mean_pool
from torch.nn import Sequential
import math

class PositionalEncoding(nn.Module):
    """
    https://pytorch.org/tutorials/beginner/transformer_tutorial.html
    """

    def __init__(self, d_model, vocab_size=5000, dropout=0.1):
        super().__init__()
        self.dropout = nn.Dropout(p=dropout)

        pe = torch.zeros(vocab_size, d_model)
        position = torch.arange(0, vocab_size, dtype=torch.float).unsqueeze(1)
        div_term = torch.exp(
            torch.arange(0, d_model, 2).float()
            * (-math.log(10000.0) / d_model)
        )
        pe[:, 0::2] = torch.sin(position * div_term)
        pe[:, 1::2] = torch.cos(position * div_term)
        pe = pe.unsqueeze(0)
        self.register_buffer("pe", pe)

    def forward(self, x):
        x = x + self.pe[:, : x.size(1), :]
        return self.dropout(x)


class BeTransformer(nn.Module):
    def __init__(self, dropout, hidden_dim, num_layers, window_size, k_value, output_size=4, input_length=2000000):
        super(BeTransformer, self).__init__()
        self.output_size = output_size
        #TODO: to be refactored.
        dim_feedforward = 32
        nhead = 4
        dim_byte = 8
        self.k_value = k_value
        self.dropout = dropout
        self.hidden_dim = hidden_dim
        self.num_layers = num_layers
        self.window_size = window_size
        self.dim_byte = dim_byte
        
        
        self.embed = nn.Embedding(257, dim_byte, padding_idx=0)
        self.conv_1 = nn.Conv1d(int(dim_byte/2), hidden_dim, window_size, stride=window_size, bias=True)
        self.conv_2 = nn.Conv1d(int(dim_byte/2), hidden_dim, window_size, stride=window_size, bias=True)
        self.sigmoid = nn.Sigmoid()
        self.pos_encoder = PositionalEncoding(d_model=hidden_dim, dropout=dropout, vocab_size=int(input_length/window_size))
        encoder_layer = nn.TransformerEncoderLayer(d_model=hidden_dim, nhead=nhead, dim_feedforward=dim_feedforward, dropout=dropout, batch_first=True)
        self.transformer_encoder = nn.TransformerEncoder(encoder_layer,num_layers=num_layers)
        self.classifier = nn.Linear(hidden_dim, output_size)
        self.pooling = nn.MaxPool1d(int(input_length/window_size))

    def forward(self, x):
        x = self.embed(x.long())
        x = torch.transpose(x,-1,-2)
        cnn_value = self.conv_1(x.narrow(-2, 0, int(self.dim_byte/2)))
        gating_weight = self.sigmoid(self.conv_2(x.narrow(-2, int(self.dim_byte/2), int(self.dim_byte/2))))
        x = cnn_value * gating_weight
        x = x*math.sqrt(self.hidden_dim )
        x = x.permute([0,2,1])
        x = self.pos_encoder(x)
        x = self.transformer_encoder(x)
        x = self.pooling(x.permute([0,2,1])).squeeze()
        x = self.classifier(x)
        return x