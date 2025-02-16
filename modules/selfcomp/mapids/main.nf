process SELFCOMP_MAPIDS {
    tag "$meta.id"
    label 'process_medium'
    def version = '0.001-c1'
    if (params.enable_conda) {
        exit 1, "Conda environments cannot be used when using the makecmap process. Please use docker or singularity containers."
    }
    container "quay.io/sanger-tol/selfcomp:${version}"
    input:
    tuple val(meta), path(bed)
    path(agp)
    output:
    tuple val(meta), path("*.bed"), emit: bedfile
    path "versions.yml"          , emit: versions
    when:
    task.ext.when == null || task.ext.when
    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"
    """
    mapids.py -i $bed -r $agp > ${prefix}_mapped.bed
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        selfcomp_mapids: ${version}
    END_VERSIONS
    """
}
