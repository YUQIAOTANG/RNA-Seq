#!/bin/bash

# RNA-SEQ script from Sun for lu lab：Trimmomatic-STAR-featurecount pipeline
# First, "ls > file.txt" for generation of file.txt file, which will be used for read in of sequencing file; modifiy the file.txt as request.
# Second, move original sequencing files to ./ori folder;
# Thrid, execute the RNA-seq.sh pipeline for basic gene expression analysis.
# Finally, the script, file.txt and sequencing data must be located in same folder.

export PATH=/yourpath/bin:$PATH
mkdir fastp
mkdir star
mkdir featureCounts
#index
ref_genome_indices_dir="/home/oil15/software/STAR-2.7.5c/bin/star_index/bnapusv6_index"
#reference genome
ref_genome_fa="/home/oil15/genome/brassica_napus/Bna_darmor_v4.1/Brassica_napus_v4.1.chromosomes.fa"
#reference genome gff，
ref_genome_gtf="/home/oil15/genome/brassica_napus/Bna_darmor_v4.1/Bna.118804.v6.gtf"
#featureCounts
for filename in $(cat file.txt)
do
fastp -f 15 -F 15 -5 -3 -W 3 -M 20 -l 80 -c -w 15 -i ./"$filename"_1.fastq.gz -I ./"$filename"_2.fastq.gz -o $filename.s1.out.fq.gz -O $filename.s2.out.fq.gz -h $filename.html -j $filename.json
done

mv *.out.fq.gz fastp
mv *.html fastp

#make index
#alignment
STAR --runMode genomeGenerate --genomeDir ${ref_genome_indices_dir} --genomeFastaFiles ${ref_genome_fa} --runThreadN 20 --sjdbGTFfile ${ref_genome_gtf} --sjdbOverhang 125 --genomeSAindexNbases 13

cd star
for filename in $(cat ../file.txt)
do
nohup STAR --runThreadN 10 --genomeDir ${ref_genome_indices_dir} --readFilesIn ../fastp/$filename.s1.out.fq.gz ../fastp/$filename.s2.out.fq.gz --readFilesCommand zcat --outFileNamePrefix ./"$filename" --outSAMstrandField intronMotif --outSAMtype BAM SortedByCoordinate --limitBAMsortRAM 1600000000
done
#alignment and featureCounts
cd ../featureCounts
for filename in $(cat ../file.txt)
do
featureCounts -t exon -g gene_id -p -a ${ref_genome_gtf} -o $filename.counts.txt ../star/"$filename"Aligned.sortedByCoord.out.bam
done
