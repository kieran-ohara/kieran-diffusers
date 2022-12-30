To try and maintain some sort of control over the experiment, I want to lock the
images to be the same so that the only variables changing are controlled by me.
To do this I settled on a standard bunch of prompts and locked the seed to
ensure I was only seeing the difference in LR/Steps.

# Exp1.

| variable                | value        |
| ----------------------- | ------------ |
| instance_data_dir       | kieran2      |
| instance prompt         | kokieran     |
| class_prompt            | man          |
| num_class_images        | 200          |
| learning_rate           | 5e-6         |
| interpolate with prompt | kokieran man |

# Exp2.

| variable                | value        |
| ----------------------- | ------------ |
| instance_data_dir       | kieran2      |
| instance prompt         | kokieran     |
| class_prompt            | man          |
| num_class_images        | 200          |
| learning_rate           | 2e-6         |
| interpolate with prompt | kokieran man |

# Exp3

| variable                | value        |
| ----------------------- | ------------ |
| instance_data_dir       | kieran2      |
| instance prompt         | kokieran     |
| class_prompt            | man          |
| num_class_images        | 2400         |
| learning_rate           | 5e-6         |
| interpolate with prompt | kokieran man |

# Exp4

| variable                | value        |
| ----------------------- | ------------ |
| instance_data_dir       | kieran2      |
| instance prompt         | kokieran     |
| class_prompt            | man          |
| num_class_images        | 4400         |
| learning_rate           | 5e-6         |
| interpolate with prompt | kokieran man |

# Exp5

| variable                | value        |
| ----------------------- | ------------ |
| instance_data_dir       | kieran2      |
| instance prompt         | kokieran     |
| class_prompt            | man          |
| num_class_images        | 2400         |
| learning_rate           | 3e-6         |
| interpolate with prompt | kokieran man |
