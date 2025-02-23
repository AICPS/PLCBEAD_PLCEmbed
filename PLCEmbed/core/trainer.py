import torch, wandb, pprint

from sklearn.metrics import accuracy_score, confusion_matrix, recall_score, precision_score, f1_score, cohen_kappa_score, matthews_corrcoef
from tqdm import tqdm

import seaborn as sns
import torch.nn as nn
import matplotlib.pyplot as plt
import numpy as np
import seaborn as sn
import pandas as pd

class Trainer:
    def __init__(self, cfg, model, test_table, label2idx):
        self.cfg = cfg
        self.model = model
        
        self.wandb_enable = cfg.wandb_enable
        self.index = cfg.n_value
        self.label2idx = label2idx

        if self.wandb_enable:
            self.wandb = cfg.wandb_
            self.wandb_config = cfg.wandb_config
            self.wandb.watch(self.model, log="all")
            self.test_table = test_table

    def train(self, train_dataloader, test_dataloader, class_weights=[]):
        min_loss = float('inf')
        best_result = dict()
        
        self.optimizer = torch.optim.Adam(self.model.parameters(), lr = self.cfg.learning_rate)
        self.loss_func = nn.CrossEntropyLoss(weight=torch.FloatTensor(class_weights).to(self.cfg.device))

        tqdm_bar = tqdm(range(self.cfg.epochs))
        for epoch_idx in tqdm_bar:
            final_loss = 0
            self.model.train()

            for batch in train_dataloader:
                torch.cuda.empty_cache()
                self.optimizer.zero_grad()
                tp_data = batch[0].to(self.cfg.device)
                tp_labels = batch[1].to(self.cfg.device)
                try:
                    output = self.model(tp_data)
                except:
                    import pdb; pdb.set_trace()
                loss = self.loss_func(output, tp_labels)
                loss.backward()
                self.optimizer.step()
                final_loss += loss.detach().cpu().item()          
            tqdm_bar.set_description('Epoch: {:04d}, loss: {:.4f}'.format(epoch_idx, final_loss/len(train_dataloader)))

            if (epoch_idx == 0) or ((epoch_idx + 1) % self.cfg.test_step == 0):
                train_result  = self.evaluate(train_dataloader, epoch_idx, "train")
                test_result = self.evaluate(test_dataloader, epoch_idx)
                
                result = {} 
                result.update(train_result)
                result.update(test_result)
                
                if result['test/final_loss'] < min_loss:
                    min_loss = result['test/final_loss']
                    best_result['epoch_index'] = epoch_idx
                    best_result['test_precision'] = result['test/precision']
                    best_result['test_recall'] = result['test/recall']
                    best_result['test_f1'] = result['test/f1']
                    best_result['test_confusion_mtx'] = result['test/confusion_matrix/epoch_%d'%(epoch_idx)]     
                    best_result['test_test_acc'] = result['test/accuracy']     

                    best_result['train_precision'] = result['train/precision']
                    best_result['train_recall'] = result['train/recall']
                    best_result['train_f1'] = result['train/f1']
                    best_result['train_confusion_mtx'] = result['train/confusion_matrix/epoch_%d'%(epoch_idx)]     
                    best_result['train_acc'] = result['train/accuracy']                   
                self.log_result(result, epoch_idx)

        return best_result
   
    def evaluate(self, data, epoch_idx, task="test"):
        with torch.no_grad():
            self.model.eval()
            
            labels = []
            outputs = []
            final_loss = 0

            for batch in data:
                tp_data = batch[0].to(self.cfg.device)
                tp_labels = batch[1].to(self.cfg.device)
                output = self.model(tp_data)
                # import pdb; pdb.set_trace()
                loss = self.loss_func(output, tp_labels)
                final_loss += loss.detach().cpu().item()
                outputs.append(output.cpu())
                labels.append(tp_labels.cpu())
                
                if self.wandb_enable:
                    self.test_table.add_data(output.reshape(-1, self.model.output_size).max(1)[1].detach().cpu().numpy(), tp_labels.cpu().detach().numpy())

            
            outputs = torch.cat(outputs).reshape(-1, self.model.output_size).detach()
            labels_tensor = torch.cat(labels).detach()
            preds = outputs.max(1)[1].detach()
            
            confusion_mtx = confusion_matrix(labels_tensor, preds)
            acc = accuracy_score(labels_tensor, preds)
            recall = recall_score(labels_tensor, preds, average='weighted')
            precision = precision_score(labels_tensor, preds, average='weighted')
            f1 = f1_score(labels_tensor, preds, average='weighted')
            cohen_kap = cohen_kappa_score(labels_tensor, preds)
            mat_cor = matthews_corrcoef(labels_tensor, preds)

            result = {}
            result['%s/confusion_matrix/epoch_%d'%(task, epoch_idx)] = confusion_mtx
            result['%s/accuracy'%(task)] = acc
            result['%s/final_loss'%(task)] = final_loss
            result['%s/recall'%(task)] = recall
            result['%s/f1'%(task)] = f1
            result['%s/precision'%(task)] = precision
            result['%s/cohen_kappa_score'%(task)] = cohen_kap
            result['%s/matthews_corrcoef'%(task)] = mat_cor
                            
            return result
    
    def log_result (self, result, epoch_idx):
        if self.wandb_enable:              
            cm_id = "obsolete/cm/Confusion_Matrix/"+"epoch_" + str(epoch_idx) + ".png"
            # import pdb; pdb.set_trace()
            df_cm = pd.DataFrame(result['test/confusion_matrix/epoch_%d'%(epoch_idx)], index = [i for i in list(self.label2idx.keys())],columns = [i for i in list(self.label2idx.keys())])
            plt.figure(figsize = (14,11))
            sn.heatmap(df_cm, annot=True)
            #plt.savefig(cm_id)
            plt.show()
            result.update({cm_id[12:]: wandb.Image(plt)})
            plt.clf()
            result.update({"test_predictions_" + str(self.index) + "epoch" + str(epoch_idx) : self.test_table})
            
            # do not record these data on wandb
            result.pop('test/confusion_matrix/epoch_%d'%(epoch_idx), None)
            result.pop('score', None)
            # result.pop('confidence_score', None)

            self.wandb.log(result)

        else:
            pprint.pprint(result)
