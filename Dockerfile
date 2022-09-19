# FROM ubi9:latest
FROM quay.io/centos/centos:stream9

WORKDIR /opt/app-root/src
ENV TRAINING_NAME=uavs
ENV TRAINING_VER=1.1
ENV DATASET=dataset_uavs.tgz
ENV MODEL_CLASSES=coco_uavs.yml
ENV YOLOv5_VERSION=6.2
ENV YOLO_DIR=/usr/local/lib/python3.9/site-packages/yolov5
ENV WEIGHTS=yolov5s.pt
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
    -r ${YOLO_DIR}/requirements.txt

ENV TRAINING_DATA=${YOLO_DIR}/training

COPY requirements.txt /opt/app-root/src/

RUN wget -O ${YOLO_DIR}/data/${MODEL_CLASSES} ${ARTI_REPO}/${MODEL_CLASSES} \
 && wget -O ${YOLO_DIR}/weights.pt ${ARTI_REPO}/${WEIGHTS} \
 && cd /opt/app-root/src \
 && pip install --no-cache-dir -r requirements.txt \
 && mkdir -p ${TRAINING_DATA} \
 && chown -R 1001:1001 ${TRAINING_DATA} 

COPY app/ /opt/app-root/src/

USER 1001
ENTRYPOINT ["/opt/app-root/src/trainit.sh"]