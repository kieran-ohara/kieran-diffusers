%.ckpt:
	python ./src/infer/convert-model.py --model_path ./src/train/model/$* --checkpoint_path $@
