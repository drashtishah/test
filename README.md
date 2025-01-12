# Bioinformatics Challenge

Research often includes simple modifications on different datasets and a ton of iterations again and again. This code is designed to be flexible. You can change input file names and number of CpG sites in 'config.py' file and re-run analysis as needed.

## How to run the analysis

1. Make sure that all the data is in a folder called 'data'. This folder must be in the same directory as 'data_analysis' and 'ngs' Jupyter notebooks.
2. Ensure that the filenames you used match those in the 'config.py' file
3. Open a terminal
4. Run 'ls' and check if you have the following file: 'Makefile'
5. Enter 'make run' in the terminal
6. You will soon see a confirmation that the analysis has ran
7. You can access the charts and processed datasets in the 'results' folder.

If you see an error message, run 'make validate' in the terminal. If there is an issue with accessing input files, you will see it here.

If you do not want to use the terminal, you can manually open the following files and run them from start to finish:
1. data_analysis.ipynb
2. ngs.ipynb

## Applicant's note
This is a simple template. The template can be extended to help researchers automate and validate workflows.
