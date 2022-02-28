#!/bin/bash

set +e -x


# CrisprEsso_count_indel 0.0.1
# Generated by dx-app-wizard.
#
# Basic execution pattern: Your app will run on a single machine from
# beginning to end.
#
# Your job's input variables (if any) will be loaded as environment
# variables before this script runs.  Any array inputs will be loaded
# as bash arrays.
#
# Any code outside of main() (or any entry point you may add) is
# ALWAYS executed, followed by running the entry point itself.
#
# See https://documentation.dnanexus.com/developer for tutorials on how
# to modify this file.

main() {

    echo "Value of fastq_R1: '$fastq_R1'"
    echo "Value of fastq_R2: '$fastq_R2'"
    echo "Value of sample_name: '$sample_name'"
    echo "Value of amplicon_sequence: '$amplicon_sequence'"
    echo "Value of gRNA: '$gRNA'"

    # The following line(s) use the dx command-line tool to download your file
    # inputs to the local file system using variable names for the filenames. To
    # recover the original filenames, you can use the output of "dx describe
    # "$variable" --name".

    dx download "$fastq_R1"

    dx download "$fastq_R2"

    # Install conda
    pypath=$PYTHONPATH
    orig_path=$PATH
    export PYTHONPATH=
    wget "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh" -O miniconda.sh 
    chmod a+x miniconda.sh 
       ./miniconda.sh -b -p /opt/conda/ 
       rm miniconda.sh

    PATH=/opt/conda/bin:$PATH

    conda update -n base -c defaults conda -y && \
       conda install \
       -c conda-forge \
       -c bioconda \
       bwa==0.7.17 \
       samtools==1.10 \
       -y && \
       conda clean --all -y

				conda config --add channels defaults
				conda config --add channels bioconda
				conda config --add channels conda-forge

				conda install CRISPResso2

				CRISPResso -r1 "$fastq_R1_name" -r2 "$fastq_R2_name" --amplicon_seq $amplicon_sequence --guide_seq $gRNA -o $sample_name --keep_intermediate --dump

    cd $sample_name 
				
				python /python_script/get_indel_frequency.py
				
				cd ..
				
				zip -r results.zip $sample_name
				
    output=$(dx upload results.zip --brief)

    # The following line(s) use the utility dx-jobutil-add-output to format and
    # add output variables to your job's output as appropriate for the output
    # class.  Run "dx-jobutil-add-output -h" for more information on what it
    # does.

    dx-jobutil-add-output output "$output" --class=file
}