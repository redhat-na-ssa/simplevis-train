#!/bin/bash

mkdir -p ${TRAINING_DATA}/train_data/images/test \
 && mkdir -p ${TRAINING_DATA}/train_data/images/train \
 && mkdir -p ${TRAINING_DATA}/train_data/images/val \
 && mkdir -p ${TRAINING_DATA}/train_data/labels/test \
 && mkdir -p ${TRAINING_DATA}/train_data/labels/train \
 && mkdir -p ${TRAINING_DATA}/train_data/labels/val
 
wget -O ${TRAINING_DATA}/dataset.tgz http://nexus.davenet.local:8081/repository/simplevis/data/training/${DATASET} \
 && cd ${TRAINING_DATA} \
 && tar xzf dataset.tgz

cd /opt/app-root/src
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

curl -v -u $ARTI_USER:$ARTI_PWD \
--upload-file /usr/local/lib/python3.9/site-packages/yolov5/runs/train/exp/results.csv \
$ARTI_REPO/$TRAINING_NAME/$TRAINING_VER/results.csv