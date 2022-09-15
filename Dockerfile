FROM quay.io/centos/centos:stream9

WORKDIR /opt/app-root/src
ARG YOLOv5_VERSION=6.2
ARG WEIGHTS=yolov5s

RUN dnf install -y git wget libGL python3-pip \
 && dnf clean all

RUN mkdir -p /usr/local/lib/python3.9/site-packages \
 && cd /usr/local/lib/python3.9/site-packages \
 && git clone --branch v${YOLOv5_VERSION} --depth 1 https://github.com/ultralytics/yolov5.git \
 && pip install --no-cache-dir \
    -r /usr/local/lib/python3.9/site-packages/yolov5/requirements.txt

ENV TRAINING_DATA=/opt/app-root/src/training

COPY requirements.txt /opt/app-root/src/

RUN cd /opt/app-root/src \
 && pip install --no-cache-dir -r requirements.txt \
 && mkdir -p ${TRAINING_DATA}/train_data/images/test \
 && mkdir -p ${TRAINING_DATA}/train_data/images/train \
 && mkdir -p ${TRAINING_DATA}/train_data/images/val \
 && mkdir -p ${TRAINING_DATA}/train_data/labels/test \
 && mkdir -p ${TRAINING_DATA}/train_data/labels/train \
 && mkdir -p ${TRAINING_DATA}/train_data/labels/val \
 && chown -R 1001:1001 ${TRAINING_DATA}

COPY app/ /opt/app-root/src/

RUN cd /usr/local/lib/python3.9/site-packages/yolov5 \
 && wget -O data/coco_bx.yaml http://nexus.davenet.local:8081/repository/simplevis/model/coco_bx.yaml \
 && wget -O ${TRAINING_DATA}/dataset.tgz http://nexus.davenet.local:8081/repository/simplevis/data/training/dataset_bx.tgz \
 && cd ${TRAINING_DATA} \
 && tar xzf dataset.tgz

USER 1001
# EXPOSE 8000
# ENTRYPOINT ["/usr/local/bin/uvicorn"]
# CMD ["main:app", "--host", "0.0.0.0"]
