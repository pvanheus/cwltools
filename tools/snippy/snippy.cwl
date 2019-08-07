class: CommandLineTool
cwlVersion: v1.0
$namespaces:
  sbg: 'https://www.sevenbridges.com/'
id: snippy
baseCommand:
  - snippy
inputs:
  - 'sbg:category': Output
    id: outdir
    type: string?
    default: '.'
    inputBinding:
      position: 1
      prefix: '--outdir'
    label: Output folder (default '')
  - 'sbg:category': Output
    id: prefix
    type: string?
    default: 'snps'
    inputBinding:
      position: 1
      prefix: '--prefix'
    label: Prefix for output files (default 'snps')
  - 'sbg:category': Output
    id: report
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--report'
    label: Produce report with visual alignment per variant (default OFF)
  - 'sbg:category': Output
    id: cleanup
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--cleanup'
    label: Remove most files not needed for snippy-core (inc. BAMs!) (default OFF)
  - 'sbg:category': Output
    id: rgid
    type: string?
    inputBinding:
      position: 1
      prefix: '--rgid'
    label: 'Use this @RG ID: in the BAM header (default '''')'
  - id: unmapped
    type: boolean?
    inputBinding:
      position: 1
      prefix: '--unmapped'
    label: Keep unmapped reads in BAM and write FASTQ (default OFF)
  - 'sbg:category': General
    id: force
    type: boolean?
    inputBinding:
      position: 2
      prefix: '--force'
    label: Force overwrite of existing output folder (default OFF)
  - 'sbg:category': General
    id: quiet
    type: boolean?
    inputBinding:
      position: 2
      prefix: '--quiet'
    label: No screen output (default OFF)
  - id: version
    type: boolean?
    inputBinding:
      position: 2
      prefix: '--version'
    label: Print version and exit
  - 'sbg:category': General
    id: citation
    type: boolean?
    inputBinding:
      position: 2
      prefix: '--citation'
    label: Print citation for referencing snippy
  - 'sbg:category': Resources
    id: cpus
    type: int?
    inputBinding:
      position: 3
      prefix: '--cpus'
    label: Maximum number of CPU cores to use (default '8')
  - 'sbg:category': Resources
    id: ram
    type: float?
    inputBinding:
      position: 3
      prefix: '--ram'
    label: Try and keep RAM under this many GB (default '8')
  - 'sbg:category': Resources
    id: tmp
    type: Directory?
    inputBinding:
      position: 3
      prefix: '--tmp'
    label: Fast temporary storage eg. local SSD (default '/tmp')
  - 'sbg:category': Input
    id: reference
    type: File
    inputBinding:
      position: 2
      prefix: '--reference'
    label: 'Reference genome. Supports FASTA, GenBank, EMBL (not GFF) (default '''')'
  - 'sbg:category': Input
    id: R1
    type: File?
    inputBinding:
      position: 2
      prefix: '--R1'
    'sbg:fileTypes': 'fastq, fastq.gz'
  - 'sbg:category': Input
    id: R2
    type: File?
    inputBinding:
      position: 4
      prefix: '--R2'
    label: 'Reads, paired-end R2 (right) (default '''')'
    'sbg:fileTypes': 'fastq, fastq.gz'
  - 'sbg:category': Input
    id: contigs
    type: File?
    inputBinding:
      position: 4
      prefix: '--ctgs'
    label: Don't have reads use these contigs (default '')
    'sbg:fileTypes': fasta
  - 'sbg:category': Input
    id: pe_interleaved
    type: File?
    inputBinding:
      position: 4
      prefix: '--peil'
    'sbg:fileTypes': 'fastq, fastq.gz'
  - 'sbg:category': Input
    id: bam
    type: File?
    inputBinding:
      position: 4
      prefix: '--bam'
    label: Use this BAM file instead of aligning reads (default '')
    'sbg:fileTypes': bam
  - 'sbg:category': Input
    id: targets
    type: File?
    inputBinding:
      position: 4
      prefix: '--targets'
    label: Only call SNPs from this BED file (default '')
    'sbg:fileTypes': bed
  - 'sbg:category': Input
    id: subsample
    type: float?
    inputBinding:
      position: 4
      prefix: '--subsample'
    label: Subsample FASTQ to this proportion (default '1')
  - 'sbg:category': Parameters
    id: mapping_qual
    type: int?
    inputBinding:
      position: 5
      prefix: '--mapqual'
    label: Minimum read mapping quality to consider (default '60')
  - 'sbg:category': Parameters
    id: base_quality
    type: int?
    inputBinding:
      position: 5
      prefix: '--basequal'
    label: Minimum base quality to consider (default '13')
  - 'sbg:category': Parameters
    id: min_coverage
    type: int?
    inputBinding:
      position: 5
      prefix: '--mincov'
    label: Minimum site depth to for calling alleles (default '10')
  - 'sbg:category': Parameters
    id: min_fraction
    type: float?
    inputBinding:
      position: 5
      prefix: '--minfrac'
    label: Minumum proportion for variant evidence (0=AUTO) (default '0')
  - 'sbg:category': Parameters
    id: min_qual
    type: float?
    inputBinding:
      position: 5
      prefix: '--minqual'
    label: Minumum QUALITY in VCF column 6 (default '100')
  - 'sbg:category': Parameters
    id: max_soft_clipping
    type: int?
    inputBinding:
      position: 5
      prefix: '--maxsoft'
    label: Maximum soft clipping to allow (default '10')
  - 'sbg:category': Parameters
    id: bwa_options
    type: string?
    inputBinding:
      position: 3
      prefix: '--bwaopt'
    label: 'Extra BWA MEM options, eg. -x pacbio (default '''')'
  - 'sbg:category': Parameters
    id: freebayes_options
    type: string?
    inputBinding:
      position: 5
      prefix: '--fbopt'
    label: 'Extra Freebayes options, eg. --theta 1E-6 --read-snp-limit 2 (default '''')'
outputs:
  - id: tab_output
    type: File
    outputBinding:
      glob: $(inputs.outdir)/$(inputs.prefix).tab
    'sbg:fileTypes': tab
  - id: csv_output
    label: A comma-separated version of the .tab file .html
    type: File
    outputBinding:
      glob: |
        $(inputs.outdir)/$(inputs.prefix).csv
    'sbg:fileTypes': csv
  - id: html_output
    label: A HTML version of the .tab file
    type: File
    outputBinding:
      glob: $(inputs.outdir)/$(inputs.prefix).html
    'sbg:fileTypes': html
  - id: vcf_output
    label: The final annotated variants in VCF format
    type: File
    outputBinding:
      glob: $(inputs.outdir)/$(inputs.prefix).vcf
    'sbg:fileTypes': vcf
  - id: bed_output
    label: The variants in BED format
    type: File
    outputBinding:
      glob: $(inputs.outdir)/$(inputs.prefix).bed
    'sbg:fileTypes': bed
  - id: gff3_output
    label: The variants in GFF3 format
    type: File
    outputBinding:
      glob: $(inputs.outdir)/$(inputs.prefix).gff
    'sbg:fileTypes': gff3
  - id: bam_output
    label: >-
      The alignments in BAM format. Includes unmapped, multimapping reads.
      Excludes duplicates.
    type: File
    outputBinding:
      glob: $(inputs.outdir)/$(inputs.prefix).bam
    secondaryFiles:
      - $(inputs.outdir)/$(inputs.prefix).bam.bai
    'sbg:fileTypes': bam
  - id: log_output
    label: A log file with the commands run and their outputs
    type: File
    outputBinding:
      glob: $(inputs.outdir)/$(inputs.prefix).log
    'sbg:fileTypes': txt
  - id: aligned_fasta_output
    label: >-
      A version of the reference but with - at position with depth=0 and N for 0
      < depth < --mincov (does not have variants)
    type: File
    outputBinding:
      glob: $(inputs.outdir)/$(inputs.prefix).aligned.fa
    'sbg:fileTypes': fasta
  - id: consensus_fasta_output
    label: A version of the reference genome with all variants instantiated
    type: File
    outputBinding:
      glob: $(inputs.outdir)/$(inputs.prefix).consensus.fa
    'sbg:fileTypes': fasta
  - id: consensus_substitutions_fasta_output
    type: File
    outputBinding:
      glob: $(inputs.outdir)/$(inputs.prefix).consensus.subs.fa
    'sbg:fileTypes': fasta
  - id: raw_vcf
    label: The unfiltered variant calls from Freebayes
    type: File
    outputBinding:
      glob: $(inputs.outdir)/$(inputs.prefix).raw.vcf
    'sbg:fileTypes': vcf
  - id: filtered_vcf
    label: The filtered variant calls from Freebayes
    type: File
    outputBinding:
      glob: $(inputs.outdir)/$(inputs.prefix).raw.vcf
    'sbg:fileTypes': vcf
  - id: compressed_vcf
    label: Compressed .vcf file via BGZIP
    type: File
    outputBinding:
      glob: $(inputs.outdir)/$(inputs.prefix).vcf.gz
    secondaryFiles:
      - '$(inputs.outdir)/$(inputs.prefix).vcf,gz,csi'
    'sbg:fileTypes': vcf.gz
label: snippy
requirements:
  - class: DockerRequirement
    dockerPull: 'quay.io/biocontainers/snippy:4.4.1--0'
  - class: InlineJavascriptRequirement
