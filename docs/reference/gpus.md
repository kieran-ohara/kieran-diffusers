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

| Class          | region      | Price ($ ph) | GPU              | GPU Memory (Gb) | Memory (Gb) | Recommended |
| -------------- | ----------- | ------------ | ---------------- | --------------- | ----------- | ----------- |
| n1-standard-4  | us-central1 | 0.38         | Nvidia Tensor T4 | 16              | 15          | x           |
| n1-standard-4  | us-central1 | 0.63         | Nvidia Tensor T4 | 2x16            | 15          |             |
| n1-standard-8  | us-central1 | 0.76         | Nvidia Tensor T4 | 2x16            | 30          | x           |
| n1-standard-8  | us-central1 | 1.25         | Nvidia Tensor T4 | 4x16            | 30          | x           |
| n1-standard-16 | us-central1 | 1.51         | Nvidia Tensor T4 | 4x16            | 60          |             |
