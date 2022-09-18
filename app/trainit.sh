#!/bin/bash
python3 main.py

cd /usr/local/lib/python3.9/site-packages/yolov5

python3 train.py --data $MODEL_CLASSES \
--batch-size $BATCH_SIZE \
--weights $WEIGHTS \
--img 640 \
--epochs $EPOCHS

curl -v -u $ARTI_USER:$ARTI_PWD \
--upload-file /usr/local/lib/python3.9/site-packages/yolov5/runs/train/exp/weights/best.pt \
$ARTI_REPO/$TRAINING_NAME/$TRAINING_VER/$TRAINING_NAME.pt

curl -v -u $ARTI_USER:$ARTI_PWD \
--upload-file /usr/local/lib/python3.9/site-packages/yolov5/data/$MODEL_CLASSES \
$ARTI_REPO/$TRAINING_NAME/$TRAINING_VER/$MODEL_CLASSES