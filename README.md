# PLC-BEAD & PLCEmbed: Dataset and Binary Embedding Framework for PLC Systems

## Introduction
Binary analysis is a crucial technique for examining Programmable Logic Controllers (PLCs) binaries, though it remains an underdeveloped field due to the proprietary nature and diversity in system designs of PLCs. To advance research in this domain, this repository introduces two significant contributions to the field: PLC-BEAD dataset and PLCEmbed Framework.


## PLC-BEAD Dataset
### Overview
PLC-BEAD is a meticulously curated dataset comprising over 800 unique PLC programs and 2431 binaries. This comprehensive collection is essential for conducting in-depth binary analysis, exploring program functionalities at the machine code level, and tracing back to the original programming intents using source codes.

### Key Features
- Over 700 PLC programs accompanied by their source codes and binaries.
- Binaries compiled using four different PLC compilers: GEB, CoDeSys, OpenPLC-V3, and OpenPLC-V2, reflecting the diversity encountered in real-world scenarios.
- Enables the study of unique, compiler-specific patterns in binaries, crucial for developing a universal binary analysis tool.

### Usage
The dataset is open for academic and research purposes. Users can explore the dataset to understand different PLC binaries, identify vulnerabilities, and develop tools and techniques for binary analysis.

## PLCEmbed Framework
### Overview
PLCEmbed is a transformer-based binary embedding framework designed to translate PLC binary sequences into vector representations. This approach facilitates advanced analysis techniques such as classification, clustering, and toolchain provenance.

### Usage
Researchers and practitioners can utilize the PLCEmbed framework to extract high-level forensic artifacts from PLC binaries, with demonstrated potential in toolchain provenance with accuracy rates up to 93.11%.

## Getting Started

### Installation
1. Clone the repository:

```sh
git clone https://github.com/AICPS/PLCEmbed_PLC-BEAD.git
```

2. Navigate to the cloned directory and install the required dependencies.

### Usage Example
- Detailed usage instructions can be found in the respective directories of the dataset and framework.
