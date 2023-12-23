# Lyric-Finder

This project allows a user to enter a song lyric and display a list of songs that contain that lyric.

The frontend is written in React and TypeScript and uses the [Mantine](https://mantine.dev) component library.

The backend is written in C++20 and CUDA and is built using CMake. The application is served using the [oat++](https://oatpp.io) web framework.

## Search Engine implementations

This project was originally written to explore the use of parallelization in improving the map-reduce paradigm. The backend can be initialized using one of three search-engines: a sequential, cpu implementation, a thread-parallel implementation that uses STL threads, and a CUDA implementation.

When tested on a standard Ubuntu Linux desktop workstation, the CUDA implementation is the fastest (and most consistent performer) followed by the STL thread-parallel implementation. The sequential implementation is understandably last.

## Running the application

### In Docker

This application can be run by building the appropriate docker image (based on the hardware being used to run the app) and starting a container.

To build and run the cpu-only image, run the following in `backend/`: \
`docker build -f CPU.Dockerfile -t lyric-finder-sever-cpu .`\
`docker run -p 8000:8000 lyric-finder-sever-cpu`

To build and run the CUDA supported image, run the following in `backend/`: \
`docker build -f CUDA.Dockerfile -t lyric-finder-sever-gpu .`\
`docker run --gpus all -p 8000:8000 lyric-finder-sever-gpu`

### CMake

This application can also be run using CMake.

To build the application, run the following in `backend/`: \
`cmake -B build -DCMAKE_BUILD_TYPE=Release -G Ninja .`\
`cmake --build ..`\
`./build/lyric-finder-server`
