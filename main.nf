/* 
 *   A stub for a Metabarcoding pipeline based on Dadaist2
 *   -----------------------------------------
 

 */

/* 
 *   Input parameters 
 */
include { validateParameters; paramsHelp; paramsSummaryLog; fromSamplesheet } from 'plugin/nf-validation'
include { make_input } from './lib/utils'
/*
  Import processes from external files
  It is common to name processes with UPPERCASE strings, to make
  the program more readable (this is of course not mandatory)
*/
include { CUTADAPT } from './modules/cutadapt.nf'
include { SEQFU_QUAL; ZERO_TRIM } from './modules/seqfu.nf'
include { RUNDADA; TAXONOMY; EXPORT_DADA } from './modules/dadaist.nf'
/* 
 *   DSL2 allows to reuse channels
 */
// reads = Channel
//         .fromFilePairs(params.reads, checkIfExists: true)

reads = make_input(params.reads)
db = Channel.fromPath(params.db)
if (params.verbose) {
    reads.view()
}
// Print help message, supply typical command line usage for the pipeline
if (params.help) {
   log.info paramsHelp("nextflow quadram-institute-bioscience/nextflow-example --input input_file.csv")
   exit 0
}

// Validate input parameters (requires json)
//validateParameters()

// Print summary of supplied parameters
log.info paramsSummaryLog(workflow)

workflow {
    ch_multiqc = Channel.empty()
    ch_reads   = Channel.empty()
    //ch_trim    = Channel.empty()
    if (params.skip_cutadapt) {
        ch_reads = reads
    } else {
        CUTADAPT(reads, params.fwdprimer, params.revprimer)
        ch_reads = CUTADAPT.out.reads
    }
    
    if (params.skip_trim) {
        ZERO_TRIM(ch_reads.map{it -> it[1]}.collect())
        ch_trim = ZERO_TRIM.out
    } else {
        SEQFU_QUAL(ch_reads.map{it -> it[1]}.collect())
        ch_trim = SEQFU_QUAL.out
    }
    
    RUNDADA(ch_reads.map{it -> it[1]}.collect(), ch_trim.fwd, ch_trim.rev)
    EXPORT_DADA(RUNDADA.out.table)
    TAXONOMY(EXPORT_DADA.out.features, db)
    // Collect all the relevant file for MultiQC
    //MULTIQC( ch_multiqc.collect() ) 
}