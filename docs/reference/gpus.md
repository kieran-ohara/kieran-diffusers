# GPUs

Comparing the different cloud providers re. cost.

## AWS

| Class     | Price ($) | GPU              | GPU Memory (Gb) |
| --------- | --------- | ---------------- | --------------- |
| g4dn.xl   | 0.615     | Nvidia Tensor T4 | 16              |
| g4dn.12xl | 4.36      | Nvidia Tensor T4 | 4x16            |
| g5        | 1         | A10G             | 24              |
| g3        | 0.75      | Tesla M60        | 8               |
| p3        | 3         | Tesla v100       | 16/32           |
| p4        | 20        | Tesla A100       | 40              |

## GCP

| Class         | region       | Price ($ ph) | GPU              | GPU Memory (Gb) |
| ------------- | ------------ | ------------ | ---------------- | --------------- |
| n1-standard-1 | europe-west2 | 0.34         | Nvidia Tensor T4 | 16              |
| n1-standard-1 | europe-west2 | 0.62         | Nvidia Tensor T4 | 2x16            |
| n1-standard-1 | europe-west2 | 1.20         | Nvidia Tensor T4 | 4x16            |
| n1-standard-1 | asia-east1   | 0.29         | Nvidia Tensor T4 | 2x16            |
| n1-standard-1 | asia-east1   | 0.54         | Nvidia Tensor T4 | 2x16            |
| n1-standard-1 | asia-east1   | 1.03         | Nvidia Tensor T4 | 4x16            |
