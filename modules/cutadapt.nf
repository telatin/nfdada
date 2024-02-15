process CUTADAPT {
    label 'process_medium'
    conda "bioconda::cutadapt=3.4"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/cutadapt:3.4--py39h38f01e4_1' :
        'biocontainers/cutadapt:3.4--py39h38f01e4_1' }"

    
    input:
    tuple val(sample_id), path(reads) 
    val(fwd)
    val(rev) 
    
    output:
    tuple val(sample_id), path("${sample_id}_trim_R*.fastq.gz"), emit: reads
    tuple val(sample_id), path("cutadapt_${sample_id}.log"), emit: log
    
    script:
    """
    FWDRC=\$(rc.py $fwd)
    REVRC=\$(rc.py $rev)
    echo $fwd:\$FWDRC
    echo $rev:\$REVRC
    cutadapt -a ${fwd}...\${REVRC} -A ${rev}...\${FWDRC} -j ${task.cpus} --discard-untrimmed -o "${sample_id}_trim_R1.fastq.gz" -p "${sample_id}_trim_R2.fastq.gz" ${reads[0]} ${reads[1]} 2> cutadapt_${sample_id}.log
    """
    stub:
    """
    touch "${sample_id}_trim_R1.fastq.gz"  "${sample_id}_trim_R2.fastq.gz"
    """
}