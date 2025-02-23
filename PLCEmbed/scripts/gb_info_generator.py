import csv, os
from tqdm import tqdm
from pathlib import Path
import networkx as nx
from argparse import ArgumentParser
import glob

with open('gb_info.csv', mode='w') as gb_info:
    gb_info_writer = csv.writer(gb_info, delimiter=',', quotechar='"', quoting=csv.QUOTE_MINIMAL)
    gb_info_writer.writerow(['Program Name', 'Label', 'File Size', 'Path'])
    gbpath = "/media/NAS-temp/gnn4tp/data/"
    tqdm_bar = tqdm(list(Path(str(gbpath)).glob('**/*.st')))
    for st_file_path in tqdm_bar:
        # extract call graph and collect all the function names
        tqdm_bar.set_description(str(st_file_path))
        v3_windows_file = Path(str(st_file_path)[:-3] + '.exe')
        v3_linux_file = Path(str(st_file_path)[:-3] + '_linux')
        v2_file = Path(str(st_file_path)[:-3] + '_v2')
        #file_extension = Path(file).suffix
        if os.path.exists(v3_windows_file):
            gb_info_writer.writerow([os.path.basename(v3_windows_file), Path(v3_windows_file).suffix, os.path.getsize(v3_windows_file), Path(str(st_file_path)[:-3] + '.exe')])
        if os.path.exists(v3_linux_file):
            gb_info_writer.writerow([os.path.basename(v3_linux_file), '_linux', os.path.getsize(v3_linux_file), Path(str(st_file_path)[:-3] + '_linux')])
        if os.path.exists(v2_file):
            gb_info_writer.writerow([os.path.basename(v2_file), '_v2', os.path.getsize(v2_file), Path(str(st_file_path)[:-3] + '_v2')])
