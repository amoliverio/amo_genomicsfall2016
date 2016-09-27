
# Specify variable
raw_data=$1
reference=$2
output_file=$3

# Index the fasta file
bwa index ${reference}.fa

# Start the bwa mem alignment
bwa mem ${reference}.fa ${raw_data}.fastq > ${raw_data}.sam

# Convert to binary
samtools view -b -o ${raw_data}.bam -S ${raw_data}.sam

# sort reads
samtools sort ${raw_data}.bam ${raw_data}.sorted

# Index my sorted .bam
samtools index ${raw_data}.sorted.bam

# Index the reference
samtools faidx ${reference}.fa

echo "starting variant calling."

# Create vcf
samtools mpileup -gf ${reference}.fa ${raw_data}.sorted.bam | bcftools view -vcg - > ${output_file}snps_indels.vcf

echo "We have now aligned our reads to the $reference reference."



