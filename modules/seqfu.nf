process SEQFU_QUAL {
    conda "bioconda::seqfu=1.20.3"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/seqfu:1.20.3--h1eb128b_0' :
        'biocontainers/seqfu:1.20.3--h1eb128b_0' }"

    
    input:
    path(reads) 
 
    output:
    path("fwd.txt"), emit: fwd
    path("rev.txt"), emit: rev
    
    script:
    """
    seqfu cat --skip 4  *_R1.fastq.gz | seqfu qual --max 10000000 -  | cut -f 6 > fwd.txt
    seqfu cat --skip 4  *_R2.fastq.gz | seqfu qual --max 10000000 -  | cut -f 6 > rev.txt
    """
    stub:
    """
    touch fwd.txt rev.txt
    """
}

process METADATA {
    conda "bioconda::seqfu=1.20.3"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/seqfu:1.20.3--h1eb128b_0' :
        'biocontainers/seqfu:1.20.3--h1eb128b_0' }"

    
    input:
    path(reads) 
 
    output:
    path("metadata.tsv")
    
    script:
    """
    seqfu metadata -f dadaist . > metadata.tsv
    """
    stub:
    """
    touch fwd.txt rev.txt
    """
}

process ZERO_TRIM {
    conda "bioconda::seqfu=1.20.3"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/seqfu:1.20.3--h1eb128b_0' :
        'biocontainers/seqfu:1.20.3--h1eb128b_0' }"

    
    input:
    path(reads)
 
    output:
    path("fwd.txt"), emit: fwd
    path("rev.txt"), emit: rev
    
    script:
    """
    echo 0 > fwd.txt
    echo 0 > rev.txt
    """
    stub:
    """
    touch fwd.txt rev.txt
    """    
}