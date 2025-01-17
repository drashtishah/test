#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Number of threads to use
THREADS=4

if [ $# -lt 7 ]; then
    echo "Usage: $0 NORMAL_R1 NORMAL_R2 TUMOR_R1 TUMOR_R2 REFERENCE_FA OUTPUT_DIR INPUT_DIR"
    exit 1
fi

NORMAL_SAMPLE_NAME="normal"
TUMOR_SAMPLE_NAME="tumor"

NORMAL_FASTQ_R1=$1
NORMAL_FASTQ_R2=$2
TUMOR_FASTQ_R1=$3
TUMOR_FASTQ_R2=$4
REFERENCE_FA=$5
OUTPUT_DIR=$6
INPUT_DIR=$7

# Index the reference genome
bwa index $REFERENCE_FA
samtools faidx $REFERENCE_FA

REFERENCE_DICT="${REFERENCE_FA%.fa}.dict"
gatk CreateSequenceDictionary -R $REFERENCE_FA -O $REFERENCE_DICT

# Function to process each sample
process_sample() {
  SAMPLE_NAME=$1
  FASTQ_R1=$2
  FASTQ_R2=$3

  echo "Aligning reads for $SAMPLE_NAME sample"
  
  bwa mem -t $THREADS -R "@RG\tID:$SAMPLE_NAME\tSM:$SAMPLE_NAME\tPL:ILLUMINA" $REFERENCE_FA \
    $FASTQ_R1 $FASTQ_R2 > $OUTPUT_DIR/${SAMPLE_NAME}_aligned.sam
    
  samtools view -Sb $OUTPUT_DIR/${SAMPLE_NAME}_aligned.sam > $OUTPUT_DIR/${SAMPLE_NAME}_aligned.bam

  echo "Sorting BAM file"
  samtools sort -@ $THREADS -o $OUTPUT_DIR/${SAMPLE_NAME}_sorted.bam $OUTPUT_DIR/${SAMPLE_NAME}_aligned.bam

  echo "Marking duplicates"

  gatk MarkDuplicates \
    -I $OUTPUT_DIR/${SAMPLE_NAME}_sorted.bam \
    -O $OUTPUT_DIR/${SAMPLE_NAME}_dedup.bam \
    -M $OUTPUT_DIR/${SAMPLE_NAME}_dedup_metrics.txt

  echo "Indexing BAM file"
  samtools index $OUTPUT_DIR/${SAMPLE_NAME}_dedup.bam

  echo "Preprocessing complete for $SAMPLE_NAME. Output: $OUTPUT_DIR/${SAMPLE_NAME}_dedup.bam"
}

# Process Normal Sample
process_sample $NORMAL_SAMPLE_NAME $NORMAL_FASTQ_R1 $NORMAL_FASTQ_R2

# Process Tumor Sample
process_sample $TUMOR_SAMPLE_NAME $TUMOR_FASTQ_R1 $TUMOR_FASTQ_R2

# echo "Calculating contamination"

# gatk GetPileupSummaries \
#   -I $OUTPUT_DIR/${TUMOR_SAMPLE_NAME}_dedup.bam \
#   -V $INPUT_DIR/af-only-gnomad.hg38.vcf.gz \
#   -L $INPUT_DIR/af-only-gnomad.hg38.vcf.gz \
#   -O $OUTPUT_DIR/tumor_pileups.table

# gatk GetPileupSummaries \
#   -I $OUTPUT_DIR/${NORMAL_SAMPLE_NAME}_dedup.bam \
#   -V $INPUT_DIR/af-only-gnomad.hg38.vcf.gz \
#   -L $INPUT_DIR/af-only-gnomad.hg38.vcf.gz \
#   -O $OUTPUT_DIR/normal_pileups.table

# gatk CalculateContamination \
#   -I $OUTPUT_DIR/tumor_pileups.table \
#   -matched $OUTPUT_DIR/normal_pileups.table \
#   -O $OUTPUT_DIR/contamination.table \
#   --tumor-segmentation $OUTPUT_DIR/tumor_segments.table


echo "Running Mutect2 for somatic variant calling"
#--contamination-table $OUTPUT_DIR/contamination.table \
#--germline-resource $INPUT_DIR/af-only-gnomad.hg38.vcf.gz \

gatk Mutect2 \
  -R $REFERENCE_FA \
  -I $OUTPUT_DIR/${TUMOR_SAMPLE_NAME}_dedup.bam -tumor $TUMOR_SAMPLE_NAME \
  -I $OUTPUT_DIR/${NORMAL_SAMPLE_NAME}_dedup.bam -normal $NORMAL_SAMPLE_NAME \
  -O $OUTPUT_DIR/unfiltered_variants.vcf.gz
 
echo "Filtering Mutect2 calls"

gatk FilterMutectCalls \
  -V $OUTPUT_DIR/unfiltered_variants.vcf.gz \
  -R $REFERENCE_FA \
  -O $OUTPUT_DIR/filtered_variants.vcf.gz

echo "Somatic variant calling pipeline completed. Results are in $OUTPUT_DIR folder."