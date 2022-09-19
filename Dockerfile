# FROM ubi9:latest
FROM quay.io/centos/centos:stream9

WORKDIR /opt/app-root/src
ENV TRAINING_NAME=uavs
ENV TRAINING_VER=1.0
ENV DATASET=dataset_uavs.tgz
ENV MODEL_CLASSES=coco_uavs.yml
ENV YOLOv5_VERSION=6.2
ENV WEIGHTS=weights.pt
ENV BATCH_SIZE=2
ENV EPOCHS=1
ENV ARTI_REPO=http://nexus.davenet.local:8081/repository/simplevis/model
ENV ARTI_USER=simplevis
ENV ARTI_PWD=simplevis123

RUN dnf install -y git wget libGL python3-pip \
 && dnf clean all

RUN mkdir -p /usr/local/lib/python3.9/site-packages \
 && cd /usr/local/lib/python3.9/site-packages \
 && git clone --branch v${YOLOv5_VERSION} --depth 1 https://github.com/ultralytics/yolov5.git \
 && pip install --no-cache-dir \
    -r /usr/local/lib/python3.9/site-packages/yolov5/requirements.txt

ENV TRAINING_DATA=/usr/local/lib/python3.9/site-packages/yolov5/training

COPY requirements.txt /opt/app-root/src/

RUN cd /opt/app-root/src \
 && pip install --no-cache-dir -r requirements.txt \
 && mkdir -p ${TRAINING_DATA}/train_data/images/test \
 && mkdir -p ${TRAINING_DATA}/train_data/images/train \
 && mkdir -p ${TRAINING_DATA}/train_data/images/val \
 && mkdir -p ${TRAINING_DATA}/train_data/labels/test \
 && mkdir -p ${TRAINING_DATA}/train_data/labels/train \
 && mkdir -p ${TRAINING_DATA}/train_data/labels/val \
 && chown -R 1001:1001 ${TRAINING_DATA} \
 && mkdir /usr/local/lib/python3.9/site-packages/yolov5/runs
 && chown -R 1001:1001 /usr/local/lib/python3.9/site-packages/yolov5/runs

COPY app/ /opt/app-root/src/

RUN cd /usr/local/lib/python3.9/site-packages/yolov5 \
 && wget -O ${TRAINING_DATA}/dataset.tgz http://nexus.davenet.local:8081/repository/simplevis/data/training/${DATASET} \
 && cd ${TRAINING_DATA} \
 && tar xzf dataset.tgz \
 && cd /usr/local/lib/python3.9/site-packages/yolov5 \
 && cp ${TRAINING_DATA}/model/${MODEL_CLASSES} data/${MODEL_CLASSES} \
 && cp ${TRAINING_DATA}/model/${WEIGHTS} ${WEIGHTS}

USER 1001
# EXPOSE 8000
ENTRYPOINT ["/opt/app-root/src/trainit.sh"]
# CMD ["main:app", "--host", "0.0.0.0"]
