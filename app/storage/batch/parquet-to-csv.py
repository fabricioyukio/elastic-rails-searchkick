import os
import sys

import pandas as pd

if len(sys.argv) > 2 and (sys.argv[1] != "" and sys.argv[2] != ""):
    from_filename = sys.argv[1] + ".parquet"
    to_filename = sys.argv[2] + ".csv"
    if os.path.exists(from_filename):
        df = pd.read_parquet(from_filename)
        df.index.name = 'index'
        df.rename(columns={df.columns[0]: 'content'}, inplace=True)

        df.to_csv(to_filename)
    else:
        print(
            f"Failed to convert {from_filename} to {to_filename}.\nFile {from_filename} does not exist.")
        exit(1)

    try:
        if os.path.exists(to_filename):
            print(f"Successfully converted {from_filename} to {to_filename}")
            print(f"Deleting {from_filename}...")
            try:
                os.remove(from_filename) if os.path.exists(from_filename) else None
            except:
                print(f"Failed to deleted {from_filename}") if os.path.exists(from_filename) else None
        else:
            print(f"Failed to convert {from_filename} to {to_filename}")
    except:
        print(f"Failed to convert {from_filename} to {to_filename}")

else:
    print("Please provide a filename for the parquet file to convert") if sys.argv[1] == "" else print(
        "Please provide a filename for the csv file to be convert to")
    exit(1)

exit(0)