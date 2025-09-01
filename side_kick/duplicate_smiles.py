import os
from collections import defaultdict

def find_duplicates_in_folder(folder_path):
    # Initialize dictionaries to store SMILES and compound ID information
    smiles_dict = defaultdict(list)  # {smiles: [file1, file2, ...]}
    compound_id_dict = defaultdict(list)  # {compound_id: [file1, file2, ...]}
    
    # List of all txt files in the folder
    txt_files = [f for f in os.listdir(folder_path) if f.endswith('.txt')]
    
    total_files = len(txt_files)
    total_smiles = 0
    total_compound_ids = 0
    
    # Process each file
    for file_name in txt_files:
        file_path = os.path.join(folder_path, file_name)
        with open(file_path, 'r') as file:
            lines = file.readlines()
            for line in lines:
                # Split SMILES and compound ID (assumes space separation)
                parts = line.strip().split()
                if len(parts) > 1:
                    smiles = " ".join(parts[:-1])  # SMILES part
                    compound_id = parts[-1]  # Compound ID part
                    
                    # Track SMILES and compound IDs
                    smiles_dict[smiles].append(file_name)
                    compound_id_dict[compound_id].append(file_name)
                    
                    total_smiles += 1
                    total_compound_ids += 1

    # Identify duplicates
    duplicate_smiles = {k: v for k, v in smiles_dict.items() if len(v) > 1}
    duplicate_compound_ids = {k: v for k, v in compound_id_dict.items() if len(v) > 1}

    # Print out the statistics in the requested format
    print(f"Total files processed: {total_files}")
    print(f"Total SMILES entries: {total_smiles}")
    print(f"Total compound ID entries: {total_compound_ids}\n")
    
    print(f"Duplicate SMILES found: {len(duplicate_smiles)}")
    print(f"Duplicate compound ID's found: {len(duplicate_compound_ids)}\n")
    
    if duplicate_compound_ids:
        print("Duplicated ID's:")
        for compound_id, files in duplicate_compound_ids.items():
            print(f"Compound ID: {compound_id} found in files: {', '.join(files)}")
    
    if duplicate_smiles:
        print("\nDuplicated SMILES:")
        for smiles, files in duplicate_smiles.items():
            print(f"SMILES: {smiles} found in files: {', '.join(files)}")
    
    # Return the results if needed for further processing
    return {
        "total_files": total_files,
        "total_smiles": total_smiles,
        "total_compound_ids": total_compound_ids,
        "duplicate_smiles": duplicate_smiles,
        "duplicate_compound_ids": duplicate_compound_ids
    }

# Example usage:
folder_path = "/home/jrf-2/jrf/dd/new_run/run_september/dd/library_prepared"  # Replace with your folder path
find_duplicates_in_folder(folder_path)
