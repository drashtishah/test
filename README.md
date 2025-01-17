# Bioinformatics Challenge

Research often includes simple modifications on different datasets and a ton of iterations again and again. This code is designed to be flexible. You can change input file names and number of CpG sites in 'config.py' file and re-run analysis as needed.

## Setup before running the analysis
- The code uses FastQC, Samtools, Bamtools, BWA, and GATK4.
- It is recommended that you run jupyter lab from a conda environment (not base). Samtools might not work if run from base environment.
- You can run "make install" in the terminal to install the required Python packages.
- Make sure that all the data is in a folder called 'data'. This folder must be in the same directory as 'data_analysis' and 'ngs' Jupyter notebooks. Ensure that the filenames you used match those in the 'config.py' file.

## How to run the analysis
 
1. Open a terminal (in the same directory as the makefile)
2. Enter 'make run' in the terminal
3. You will see results from basic data validation first. When the notebooks finish running, you will see results in a 'results' folder.

If you do not want to use the terminal, you can manually open the following files and run them from start to finish:
1. data_analysis.ipynb
2. ngs.ipynb

## Applicant's note
- This is a simple template. The template can be extended to help researchers automate and validate workflows. 
