#!/bin/bash

# compile tinymaix as a library
gcc -c tinymaix/tm_layers_fp8.c  tinymaix/tm_model.c  tinymaix/tm_stat.c tinymaix/tm_layers.c  tinymaix/tm_layers_O1.c
ar rvs libtm.a tm_layers_fp8.o tm_model.o  tm_stat.o tm_layers.o  tm_layers_O1.o

# compile and link main application
# libgd should be on ldlibrary path
gcc tomato_leaf_disease_detect.c -o tomato_leaf_disease_detect -lgd -lm  -L. -ltm
