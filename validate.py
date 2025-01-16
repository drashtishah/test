from config import DATA_FOLDER, NORMAL_R1, NORMAL_R2, TUMOR_R1, TUMOR_R2, REFERENCE_CSV_FILE, METHYLATION_CSV_FILE
import os

# Check if files exist in the right location
all_files = [REFERENCE_CSV_FILE, METHYLATION_CSV_FILE, NORMAL_R1, NORMAL_R2, TUMOR_R1, TUMOR_R2]

failed_tests = 0

for file in all_files:
    if os.path.exists(f'{DATA_FOLDER}/{file}'):
        pass
    else:
        failed_tests += 1
        print(f'{file} is not available inside {DATA_FOLDER} folder')
        

# In a real project, this file can check for other common mistakes
if failed_tests == 0:
    print('Great! All validation checks passed.')