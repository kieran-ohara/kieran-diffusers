%.ckpt:
	python ./src/infer/convert-model.py --model_path ./src/train/model/$* --checkpoint_path $@

run:
	cd infrastructure/run && aws-vault exec kieran -- terraform apply

.PHONY: run
