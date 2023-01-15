%.ckpt:
	python ./src/infer/convert-model.py --model_path ./src/train/model/$* --checkpoint_path $@

build:
	cd infrastructure/build && aws-vault exec kieran -- packer build .

run:
	cd infrastructure/run && aws-vault exec kieran -- terraform apply

.PHONY: build run
