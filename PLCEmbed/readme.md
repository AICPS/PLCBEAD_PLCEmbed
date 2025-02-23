# PLCEmbed: PLC Embedding Framework
In this project, we aim to develop **PLCEmbed** $-$ a transformer-based binary embedding framework. PLCEmbed translates binary sequences into vector representations, enabling enhanced analysis techniques such as classification, clustering, and toolchain provenance. This approach allows for a detailed examination of PLC binaries, aiding in the discovery of hidden vulnerabilities and informing future security enhancement efforts for PLC systems.

## PLCEmbed Structure
- **PLCEmbed/core**: all the essential functionalities used in our methods (e.g., model, trainer, evaluator, data processor).
- **PLCEmbed/scripts**: store all executable scripts (e.g., experiments, data processing, and utilities).

## To Setup the Environment
Please use [Anaconda](https://www.anaconda.com/) for virtual environment management ([install guide](https://www.anaconda.com/products/individual-d)).
Then, run the command to initialize/activate a conda env: 
```
$ conda create --name [env_name] python=3.7
$ conda activate [env_name]
```
To install requirements, run the following commands: 
```
$ sudo apt-get install graphviz libgraphviz-dev pkg-config (ask your system manager to do so).
$ conda install pytorch==1.9.0 torchvision==0.10.0 torchaudio==0.9.0 cudatoolkit=10.2 -c pytorch
$ conda install pyg -c pyg -c conda-forge
$ conda install pydot
$ python -m pip install angr r2pipe wandb seaborn pygraphviz
```

## Usages
### 1. Setup wandb integration for visualizing the results
Our project incoporates Weight & Bias ([wandb](https://wandb.ai/site)) that allows users to visualize and track machine learning training in real-time. It can be easily integrated with Python programs that leverage popular deep learning frameworks like Pytorch, Tensorflow, or Keras. Go through the following steps: 

1. Sign up for a free account on [wandb website](https://wandb.ai/site).
2. Verify if wandb is properly installed in your work environment.
    ```
    $ wandb --version
    ```
3. Login into your wandb account
    ```
    $ wandb login
    ```
    It will ask you to provide an API from your wandb profile, click on the link and copy the API and paste it here.

4. We parameterize the wandb usage, so make sure you pass the correct arguments when using wandb in our scripts. 
- `--wandb_enable` - use this to enable wandb. It doesn't need a value. \
- `--wandb_project` - this is the name of the project where you are sending the new run. You should first create the project using the [Quickstart guide](https://docs.wandb.ai/quickstart).
- `--wandb_entity` - this specifies the username or team name where you're sending runs. This entity must exist before you can send runs there, so make sure to create your account or team in the UI before starting to log runs.
    
*NB*: *Wandb is enabled in our project by default, but users can disable it by passing a command line argument when they trian/evaluate our models. Please refer to step 4.*

### 2. Perform data processing 
- Users can perform data processing for the using `scripts/run_data_processing.py`. `scripts/run_data_processing.py` script can take 5 command line arguments. Here are the command line arguments that users can use when running the script. 

`--data_dir` - specifies the path to the compiled binary file. The default value is `../PLC-BEAD/Binary/All_PLC_Program_Binaries`.\
`--pkl_path` - specifies the path where the packed NX file should be saved. 

. **Perform data processing for Toolchain Provenance Task**: This will read the raw binary in a chuck and pack it with the compiler toolchain provenance labels and save the packed binary as a pkl file that would be used later as an input to the byte embedding model. 

Path to the General binary files `../PLC-BEAD/All_PLC_Program_Binaries`

    ```
    $ cd scripts
    $ python run_data_processing.py --data_dir [Path to the compiled binary files] --pkl_path [path to packed file]
    # Example
    python run_data_processing.py --data_dir ../../PLC-BEAD/All_PLC_Program_Binaries/ --pkl_path transformer_data.pkl
    ```
### 3. Run Byte-Embedding approach for Identifying Compiler Provenance from Binaries
- Since the data processing is done already above, we will feed that dataset to our model by specifying `precache_path` with the packed binary file you get from data processing. 

    ```
    $ cd scripts
    $ python run_be_method.py --precache_path [path to packed binary] 
                            --wandb_enable --wandb_project [wandb project name] 
                            --wandb_entity [wandb project entity]
                            --batch_size [batch_size]
    # Example: 
    $ python scripts/run_be_method.py --precache_path transformer_data.pkl --wandb_enable --batch_size 4
    ```
    Users can adjust other parameters as well. You may found the complete list of command line arguments here.

    `learning_rate` # The initial learning rate for GCN.\
    `epochs` # Number of epochs to train.\
    `layers` # Number of hidden units.\
    `dropout` # Dropout rate (1 - keep probability).\
    `batch_size` # batch size .\
    `device` # The device to run on models (cuda or cpu) cpu in default.\
    `test_step` # The interval between mini evaluation along the training process.\
    `num_classes` # number of classes. 3 while using cfg, 4 while using cg
    `precache_path` # Path to packed dataset file.\
    `wandb_enable`\
    `wandb_project` # wandb project name.\
    `wandb_entity` # wandb project entity.