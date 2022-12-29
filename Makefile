scripts/prov-compare.sh: scripts/cuda.sh scripts/utils.sh scripts/conda-env.sh scripts/xformers.sh scripts/source-code.sh
	cat $^ > $@
