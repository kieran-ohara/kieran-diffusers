# GPUs

Comparing the different cloud providers re. cost.

## AWS

| Class     | Price ($) | GPU              | GPU Memory (Gb) | Memory (Gb) |
| --------- | --------- | ---------------- | --------------- | ----------- |
| g4dn.xl   | 0.615     | Nvidia Tensor T4 | 16              | 16          |
| g4dn.12xl | 4.36      | Nvidia Tensor T4 | 4x16            |             |
| g5        | 1         | A10G             | 24              |             |
| g3        | 0.75      | Tesla M60        | 8               |             |
| p3        | 3         | Tesla v100       | 16/32           |             |
| p4        | 20        | Tesla A100       | 40              |             |

## GCP

| Class | region | Price ($ ph) | GPU | GPU Memory (Gb) | Memory (Gb) | Recommended | it/s |
| -------------- | ------------- | ------------ | --- | --------------- | ----------- | ------------------- | |
| n1-standard-4 | us-central1 | 0.38 | T4 | 16 | 15 | | |
| n1-standard-4 | europe-west-4 | 0.39 | T4 | 16 | 15 | Check vscode is OK /run exp in terminal not vscode? | |
| n1-standard-8 | europe-west-4 | 0.54 | T4 | 16 | 30 | If vscode is not OK | |
| n1-standard-4 | us-central1 | 0.63 | T4 | 2x16 | 15 | | |
| n1-standard-4 | europe-west-4 | 0.64 | T4 | 2x16 | 16 | vscode+exp is good| 1.41 it/s, 8g memory |
| n1-standard-8 | us-central1 | 0.76 | T4 | 2x16 | 30 | | |
| n1-standard-8 | europe-west4 | 0.78 | T4 | 2x16 | 30 | vscode+exp is good | 1.58 it/s, 8g memory |
| n1-standard-8 | us-central1 | 1.25 | T4 | 4x16 | 30 | | |
| n1-standard-8 | europe-west4 | 1.28 | T4 | 4x16 | 30 | | 1.65 it/s, 16g memory, lr=1e-6 |
| n1-standard-16 | us-central1 | 1.51 | T4 | 4x16 | 60 | | |

# Disk

standard disk

| type | standard peristent disk |
