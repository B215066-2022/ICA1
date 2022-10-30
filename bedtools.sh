#!/bin/bash

# Import the T. congolense bedfile
cp -r /localdisk/data/BPSM/ICA1/TriTrypDB-46_TcongolenseIL3000_2019.bed /home/$USER/ICA1/Mapping
mv TriTrypDB-46_TcongolenseIL3000_2019.bed Tco-genome3000.bed # As usual, we don't like long, complicated names
ls *.bed # The bedfile should have been renamed by now

# Convert bam files to bed first - this format is useful when we use BEDTOOLS INTERSECT
for o in $(ls /home/$USER/ICA1/Mapping/*.bam);
do 
	bedtools bamtobed -i ${o} > ${o/.bam}.bed
done | sed ':a;N;$!ba;s/\n/ /g' # Remove the annoying .bam.bed filenames
ls *.bed

# Find overlap counts between the read sequences in bed format and the BEDfile using BEDTOOLS INTERSECT and generate the counts in text file
for p in $(ls /home/$USER/ICA1/Mapping/*.bed);
do
	bedtools intersect -c -a Tco-genome3000.bed -b ${p} > ${p/.bed}Intersect.txt
done | sed ':a;N;$!ba;s/\n/ /g' # Remove the annoying .bedIntersect.txt filenames
rm -f Tco-genome3000Intersect.txt # This should remove Tco-genome3000Intersect.txt, as it is known when the genome bedfile is intersected with itself, we will get 100% overlap.
ls *.txt

# Find alignments between all read sequences in bam format with T.co bedfile and generate counts in text file using BEDTOOLS MULTICOV
bedtools multicov -bams Tco-5053.bam Tco-5368.bam Tco-5615.bam Tco-5908.bam Tco-6153.bam Tco-6320.bam Tco-6580.bam Tco-6761.bam Tco-5110.bam Tco-5375.bam Tco-5646.bam Tco-5934.bam Tco-6195.bam Tco-6395.bam Tco-6600.bam Tco-6778.bam Tco-5132.bam Tco-5520.bam Tco-5774.bam Tco-6016.bam Tco-6225.bam Tco-6422.bam Tco-6619.bam Tco-6821.bam Tco-5161.bam Tco-5572.bam Tco-5798.bam Tco-6028.bam Tco-6241.bam Tco-6475.bam Tco-6624.bam Tco-6890.bam Tco-5224.bam Tco-5578.bam Tco-5814.bam Tco-6037.bam Tco-6288.bam Tco-6499.bam Tco-6658.bam Tco-6894.bam Tco-5296.bam Tco-5592.bam Tco-5864.bam Tco-6114.bam Tco-6307.bam Tco-6520.bam Tco-6675.bam Tco-6950.bam -bed Tco-genome3000.bed > AlignmentCounts.txt 
ls *.txt

# Prompt Y/N dialogue before proceeding
while true; do
    read -p "Proceed to generating the mean counts per gene for each group? Press Y to proceed or N to cancel." yn
    case $yn in
        [Yy]* ) source /home/$USER/output.sh; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer Y or N.";;
    esac
done

