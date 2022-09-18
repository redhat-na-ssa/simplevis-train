IMAGE_BASE = /data/simplevis-data/training/images
LABEL_BASE = /data/simplevis-data/training/labels
TRAIN_BASE = /data/simplevis-data/training/train_data

podman run -it \
 --rm -v simplevis-training:/usr/local/lib/python3.9/site-packages/yolov5/training \
 --user 0 \
 simplevis-train \
 /bin/bash