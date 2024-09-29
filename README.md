# RNA-Seq Pipeline for Lu Lab in 2020 summer

This Bash script automates the RNA sequencing analysis using the Trimmomatic-STAR-featureCounts pipeline, designed for gene expression analysis in the Lu Lab. The pipeline handles quality control, alignment, and quantification of gene expression.

## Pipeline Overview

1. **Quality Control**: Uses `fastp` for trimming and quality filtering of raw sequencing data.
2. **Alignment**: Utilizes `STAR` for mapping reads to a reference genome.
3. **Quantification**: Employs `featureCounts` for counting the number of reads mapped to genes.

## Prerequisites

Ensure the following tools are installed and accessible:
- `fastp`
- `STAR`
- `featureCounts`

## Directory Structure

Before running the script, make sure to:
1. Create a list of filenames: Run `ls > file.txt` and modify `file.txt` as needed to list the sequencing files.
2. Move original sequencing files to a directory named `./ori`.

The script, `file.txt`, and sequencing data must all be located in the same directory.

## Running the Pipeline

1. **Set up environment paths**:
   ```bash
   export PATH=/home/your_path/bin:$PATH
