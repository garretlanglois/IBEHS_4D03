#!/usr/bin/env python3
import csv
import sys

def read_csv_data(filename):
    """
    Reads a CSV file with columns (e.g. 'Pixel', 'Value') and returns a list of (pixel, value) tuples.
    Modify the column names below if your CSV headers differ.
    """
    data = []
    with open(filename, newline='') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            try:
                pixel = float(row['Pixel'])
                value = float(row['Value'])
            except (ValueError, KeyError):
                # Skip invalid rows or rows missing expected headers
                continue
            data.append((pixel, value))
    return data

def calculate_modulation(min_val, max_val):
    """
    Compute modulation as (max - min) / (max + min).
    Returns None if max+min is zero or negative (which shouldn't happen in typical image data).
    """
    denom = max_val + min_val
    if denom <= 0:
        return None
    return (max_val - min_val) / denom

def main():
    if len(sys.argv) != 2:
        print("Usage: python analyze.py <data.csv>")
        sys.exit(1)

    filename = sys.argv[1]
    data = read_csv_data(filename)
    if not data:
        print("No valid data found or CSV headers mismatch.")
        sys.exit(1)

    # Define the line‐pair groups we expect, in the order they appear in the CSV:
    frequencies = [0.50, 0.67, 1.00, 1.33, 2.00, 4.00]
    # If size in mm is simply 1/frequency for your setup, you can compute on the fly;
    # or if it's exactly the table in your screenshot, just list them directly:
    sizes = [2.00, 1.50, 1.00, 0.75, 0.50, 0.25]

    # We assume the CSV is split evenly into 6 consecutive segments:
    num_groups = len(frequencies)
    chunk_size = len(data) // num_groups

    # Prepare for table output
    print("Spatial Frequency (LP/mm),Size (mm),Minimum,Maximum,Modulation")
    
    for i in range(num_groups):
        # Slice out the i‐th chunk
        start_idx = i * chunk_size
        end_idx   = (i + 1) * chunk_size if i < num_groups - 1 else len(data)
        chunk = data[start_idx:end_idx]

        # Compute min, max, and modulation for this chunk
        values = [pt[1] for pt in chunk]  # just the “Value” portion
        if not values:
            continue

        min_val = min(values)
        max_val = max(values)
        modulation = calculate_modulation(min_val, max_val)

        # Print one row matching your table layout
        print(f"{frequencies[i]:.2f},{sizes[i]:.2f},{min_val:.2f},{max_val:.2f},{modulation:.3f}")

if __name__ == "__main__":
    main()
