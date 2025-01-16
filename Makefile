# Variables

PYTHON := python

# Commands

install:
	@echo "Installing required packages"
	pip install --upgrade pip
	pip install -r requirements.txt
    
validate:
	@echo "Validating the data"
	$(PYTHON) validate.py

run:
	@echo "Validating the data"
	$(PYTHON) validate.py
	@echo "Running the notebooks"
	$(PYTHON) run.py