from utils import create_or_clean_folder
from config import RESULTS_FOLDER
import nbformat
import os
import subprocess
from nbconvert.preprocessors import ExecutePreprocessor

def execute_notebook(notebook_filename):
    with open(notebook_filename) as f:
        nb = nbformat.read(f, as_version=4)
        ep = ExecutePreprocessor(timeout=None, kernel_name='python3')  # No timeout
        try:
            ep.preprocess(nb, {'metadata': {'path': '.'}})  # Execute the notebook
            print(f"Successfully executed {notebook_filename}")
        except Exception as e:
            print(f"Error executing {notebook_filename}: {e}")
            raise  # Re-raise the exception to stop execution
    return None

notebooks = ['data_analysis.ipynb','ngs.ipynb']

create_or_clean_folder(RESULTS_FOLDER)

for notebook in notebooks:
    print(f'Running {notebook} notebook')
    execute_notebook(notebook)