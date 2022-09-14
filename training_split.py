import os
import shutil
from pathlib import Path

IMAGE_BASE = Path("/Users/davidwhite/workspace/pshare/images")
LABEL_BASE = Path("/Users/davidwhite/workspace/pshare/labels")
TRAIN_BASE = Path("/Users/davidwhite/workspace/pshare/train_data")
VAL_IMAGE_DIR = TRAIN_BASE.joinpath("images/val")
TRAIN_IMAGE_DIR = TRAIN_BASE.joinpath("images/train")
TEST_IMAGE_DIR = TRAIN_BASE.joinpath("images/test")
VAL_LABEL_DIR = TRAIN_BASE.joinpath("labels/val")
TRAIN_LABEL_DIR = TRAIN_BASE.joinpath("labels/train")
TEST_LABEL_DIR = TRAIN_BASE.joinpath("labels/test")

count = 0
# Iterate directory
for path in os.listdir(LABEL_BASE):
    # check if current path is a file
    if os.path.isfile(os.path.join(LABEL_BASE, path)):
        count += 1
num_test = round(count * .1)
num_val = round(count * .1)
num_train = count - (num_test + num_val)
print(str(count) + " total files in training set.")
print(str(num_test) + " will be user for test.")
print(str(num_val) + " will be used for val.")
print(str(num_train) + " remain for training.")

all_labels = []
for i in LABEL_BASE.iterdir():
    all_labels.append(i)

for x in range(0,num_val):
    ifile = os.path.basename(all_labels[x])
    my_ext = os.path.splitext(ifile)[0]
    shutil.copy(all_labels[x], VAL_LABEL_DIR.joinpath(ifile)) #Label
    shutil.copy(IMAGE_BASE.joinpath(my_ext + ".jpg"), VAL_IMAGE_DIR.joinpath(my_ext + ".jpg")) #Image
    print("val: " + str(x) + ": " + my_ext)
for x in range(num_val,num_test + num_val):
    ifile = os.path.basename(all_labels[x])
    my_ext = os.path.splitext(ifile)[0]
    shutil.copy(all_labels[x], TEST_LABEL_DIR.joinpath(ifile)) #Label
    shutil.copy(IMAGE_BASE.joinpath(my_ext + ".jpg"), TEST_IMAGE_DIR.joinpath(my_ext + ".jpg")) #Image
    print("test: " + str(x) + ": " + my_ext)
for x in range(num_val + num_test,num_train):
    ifile = os.path.basename(all_labels[x])
    my_ext = os.path.splitext(ifile)[0]
    shutil.copy(all_labels[x], TRAIN_LABEL_DIR.joinpath(ifile)) #Label
    shutil.copy(IMAGE_BASE.joinpath(my_ext + ".jpg"), TRAIN_IMAGE_DIR.joinpath(my_ext + ".jpg")) #Image
    print("train: " + str(x) + ": " + my_ext)

# for l in all_labels:
#     ifile = os.path.basename(l)
#     my_ext = os.path.splitext(ifile)[0]
#     idx = all_labels.index(l)
#     if idx < num_val:
#         print("val: " + str(idx) + ": " + my_ext)    
#     if idx >= num_val <= 74:
#         print("test: " + str(idx) + ": " + my_ext)    

    # shutil.copy(i, VAL_LABEL_DIR.joinpath(ifile))
    # shutil.copy(IMAGE_BASE.joinpath(my_ext + ".jpg"), VAL_IMAGE_DIR.joinpath(my_ext + ".jpg"))

# for i in LABEL_BASE.iterdir():
#     if test_pics <= num_test:
#         ifile = os.path.basename(i)
#         my_ext = os.path.splitext(ifile)[0]
#         # shutil.copy(i, VAL_LABEL_DIR.joinpath(ifile))
#         # shutil.copy(IMAGE_BASE.joinpath(my_ext + ".jpg"), VAL_IMAGE_DIR.joinpath(my_ext + ".jpg"))
#         print(str(test_pics) + ": " + my_ext)
#         test_pics += 1