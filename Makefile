%.ckpt:
	python ./src/infer/convert-model.py --model_path ./src/train/model/$* --checkpoint_path $@

image:
	cd infrastructure/build && packer build .

deployment:
	cd infrastructure/run && terraform apply

.PHONY: image deployment
