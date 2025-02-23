## PLC-BEAD
### Overview:
**PLC-BEAD (PLC Binary Evaluation and Analysis Dataset)** is a comprehensive collection of over 700 unique PLC programs and 2431 binaries. Each program in for binary analysis. These binaries allow for in-depth exploration of program functionality at the machine code level, while source codes enable tracing back to the original programming intent.

### Dataset Structure
- **PLC-BEAD/Binary**: Contains binary files compiled using four different toolchains: *GEB, Codesys, OpenPLCv2, OpenPLCv3*
- **PLC-BEAD/Source**: Contains the Structured Text PLC program files that were used to compile the resulting binary files, sorted by each toolchains, along with a folder containing all files, including the uncompiled ones
- **PLC-BEAD/metadata**: Contains .csv files that have essential information about every PLC program in the dataset. This metadata encapsulates specifics like the compiler employed, the programming language, the functionality the program provides, and its application domain. The metadata facilitates efficient filtering and categorization of the dataset based on specific research requirements.

### PLC-BEAD/Source
The source code is structured into 5 folders. Since every toolchain functions within a unique development environment, source codes in the **PLC-BEAD** are specifically tailored to suit each one. As a result, besides all the PLC programs that we created using the IEC 61131-3 standard, we also included the project files for all the toolchains. 
#### Source code strucure:
- **PLC_Programs**: Contain all the PLC programs that we created in the lab build using Structured Test (ST) programming language following the IEC 61131-3 standard. 
- **Codesys**: Contains *CoDeSys* PLC project files for the structured text programs that we developed. 
- **GEB**: Contains *GEB* PLC project program files.
- **OpenPLCv2**: Contains *OpenPLC V2* Structured Text PLC program files.
- **OpenPLCv3**: Contains *OpenPLC V3* Structured Text PLC program files.

### PLC-BEAD/Binary
We processed the prepared source codes by compiling each program with the selected toolchains and acquired the corresponding binaries. However, it is crucial to note that not all ST programs can be compiled by each selected toolchain due to variations in the built-in libraries of each toolchain. For example, a simple string handling ST
program (CAPITALIZE.ST) that we derived from the OSCAT library could be compiled with CoDeSys but not with OpenPLC-V3. This is because the OpenPLC-V3 compiler does not support the primitive function, GET_CHAR(). Despite these constraints, a significant number of programs were successfully compiled. The statistics of the PLC-BEAD dataset looks like the following:
| Toolchain    | Codesys | GEB | OpenPLC-V2 | OpenPLC-V3 | All_PLC_Program_Binaries|
| ------------ | ------- | --- | ---------- | ---------- | ------------------------|
| **# of binaries** | 553     | 617 | 619        | 640        | 2431 |

### PLC-BEAD/metadata
Supplementing the binary files and source code
are metadata elements, providing essential information about every PLC program in the dataset. This metadata encapsulates specifics like the compiler employed, the programming language, the functionality the program provides, and its application domain. The metadata facilitates efficient filtering and categorization of the
dataset based on specific research requirements.
We have provided 5 metadata:

1. **metadata.csv**:  consists of 10 columns. Here's a breakdown of each:

    - **Program File Name**: The first column that holds the name of the program file.
    - **Toolchain/Compilers**: Columns 2-5 specify if a program is compiled using the mentioned toolchain.  A value of "1" means it does, while "0" means it doesn't.
        - **OpenPLCv2**: Indicates if the program file has a binary compiled using the OpenPLCv2 toolchain.
        - **OpenPLCv3**: Same as above, but for the OpenPLCv3 toolchain.
        - **Codesys**: Represents the presence of a binary compiled using the Codesys toolchain.    
        - **GEB**: Represents the presence of a binary compiled using the GEB toolchain.
    - **Functional Label**: Denotes the functional category of the program. In total, there are 22 distinct functional labels that are used for predicting functionality.
    - **Programming Language**: Specifies the language in which the program file was written.
    - **Application Domain**: Last three columns. These columns detail the domain of the application, for instance, basic network or building. An example would be "networking," which implies that the PLC program file automates communication network functionalities.

2. **openplc_v3.csv**
3. **openplc_v2.csv**
4. **geb.csv**
5. **codesys.csv** 
    - The four files contain metadata about the PLC programs compiled with the respective toolchains. Each file provides the following details:
        - *Program File Name* 
        - *Functional Label*
        - *Programming Language*
        - *Application Domain*   

### Possible Applications
- *Machine Learning*: The dataset is essential for training models to recognize PLC-specific patterns and vulnerabilities.
- *Algorithm Development*: It facilitates precise algorithm crafting for PLC binaries and provides a benchmark for tool optimization in real-world scenarios.
- *Research & Infrastructure Security*: Offering insights into PLC systems, the dataset aids in identifying vulnerabilities and bolstering security for critical infrastructure.



