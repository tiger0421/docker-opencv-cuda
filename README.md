# docker-opencv-cuda
This container is built for Compute Capability=7.5  
check your GPU [here](https://developer.nvidia.com/cuda-gpus#compute)

# Suport
- melodic

# Chek your GPU
```
$ python3
import cv2
print(cv2.cuda.getCudaEnabledDeviceCount())
```
Success if a value greater than 0 is returned.

# Build
Before building, match GPU_ARCH in Dockerfile to your GPU
```
$ docker build -t IMAGE_NAME:TAG_NAME
```
