process RUNDADA {
    label 'process_dada'
    conda "bioconda::dadaist2=1.3.0"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/dadaist2:1.3.0--hdfd78af_0' :
        'biocontainers/dadaist2:1.3.0--hdfd78af_0' }"

    
    input:
    path(reads) 
    path("fwd.txt")
    path("rev.txt")
    
    output:
    path("dada2.tsv"), emit: table
    path("dada2.stats"), emit: stats
    path("quality_R*.pdf"), emit: plots
    
    script:
    """
    dadaist2-rundada -i ./ -o dada2/ --trunc-len-1 \$(cat fwd.txt) --trunc-len-2 \$(cat rev.txt) -t ${task.cpus}
    mv dada2/{dada2,quality}* .
    """
    stub:
    """
    touch ${sample_id}.fa
    """
}

process TAXONOMY {
    label 'process_dada'
    conda "bioconda::dadaist2=1.3.0"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/dadaist2:1.3.0--hdfd78af_0' :
        'biocontainers/dadaist2:1.3.0--hdfd78af_0' }"

    
    input:
    path("rep-seqs.fasta") 
    path(db)
    
    
    output:
    path("taxonomy.tsv")
  
    
    script:
    """
    dadaist2-assigntax -i rep-seqs.fasta -r $db  -o taxonomy/ -t ${task.cpus}
    mv taxonomy/taxonomy.tsv .
    """
    stub:
    """
    touch ${sample_id}.fa
    """
}


process EXPORT_DADA {
    label 'process_dada'
    conda "bioconda::dadaist2=1.3.0"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/dadaist2:1.3.0--hdfd78af_0' :
        'biocontainers/dadaist2:1.3.0--hdfd78af_0' }"

    
    input:
    path("dada2.tsv") 
    
    
    output:
    path("rep-seqs.fasta"), emit: features
    path("table.tsv"), emit: table

    script:
    """
    dadaist2-dada2fasta -i dada2.tsv -r rep-seqs.fasta -o table.tsv
    """
    stub:
    """
    touch rep-seqs.fasta table.tsv
    """
}
