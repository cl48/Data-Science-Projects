The solution works as follows:

1. Import libraries 

import os
import tarfile
import json
import pandas as pd
from datetime import date
import argparse

2. Create a function called process_tar_file that will take three arguments (directory location, number of best selling products and output location).  It ingests tar file, extracts relevant information then puts together into a DataFrame then calculates and ranks the best-selling products.

3. The main function being created is to allow command prompt argument parsing to go into the Python script by using argparse that requires the user to input receipt files (-d), number of best selling products (-n) and output the location (-o).

4. Calls the process_tar_file function with parsed command-line arguments.

5. Python script is executed as a standalone program by checking if __name__ is __main__ and calling the main function.