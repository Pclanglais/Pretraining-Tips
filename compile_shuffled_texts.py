import pandas as pd
import numpy as np
import os, glob

master_directory = "/lustre/fsn1/projects/rech/fmr/uft12cr/final_set_shuffle/set_3"

# Create the output directory if it doesn't exist
os.makedirs(master_directory, exist_ok=True)

for current_directory in glob.glob(master_directory + "/*"):
    final_file = current_directory.replace("/final_set_shuffle/", "/final_set_compiled/")

    print(f"Preparing {final_file}")

    try:
        compilation = pd.read_parquet(current_directory).sample(frac=1)

    except:

        print("There has been an error, attempting a slower way")
        compilation = []
        for file in glob.glob(current_directory + "/*parquet"):
            try:
                compilation_add = pd.read_parquet(file)
                compilation.append(compilation_add)
            except:
                print("issue with file " + file)
        
        compilation = pd.concat(compilation).sample(frac=1)

        print(compilation)
            

    # Split the DataFrame into 10 parts
    split_dfs = np.array_split(compilation, 10)

    # Save each part as a separate parquet file
    for i, df in enumerate(split_dfs):
        output_file = final_file + f"_{i+1}.parquet"

        df.to_parquet(output_file, index=False)

    print(f"Split and saved 10 parquet files in {final_file}")
