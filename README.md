# Lyric-Finder

This project allows a user to enter a song lyric and display a list of songs that contain that lyric.

The frontend is written in React and TypeScript and uses the [Mantine](https://mantine.dev) component library.

The backend is written in C++20 and CUDA and is built using CMake. The application is served using the [oat++](https://oatpp.io) web framework.

## Search Engine implementations

This project was originally written to explore the use of parallelization in improving the map-reduce paradigm. The backend can be initialized using one of three search-engines: a sequential, cpu implementation, a thread-parallel implementation that uses STL threads, and a CUDA implementation.

When tested on a standard Ubuntu Linux desktop workstation, the CUDA implementation is the fastest (and most consistent performer) followed by the STL thread-parallel implementation. The sequential implementation is understandably last.

## Running the application

### CMake

This application is built using CMake. Use the commands below to build from scratch.

Run the following in `backend/`: \
`mkdir build && cd build`\
`cmake -DCMAKE_BUILD_TYPE=Release -G Ninja ..` (can use make instead of ninja)\
`cmake --build .`\
`./lyric-finder-server [-g enable cuda support] [-t number of threads to use if not using cuda]`

### In Docker

To use build the appropriate docker image and run, use the instructions below:

To build and run the cpu-only image, run the following in `backend/`: \
`docker build -f CPU.Dockerfile -t lyric-finder-sever-cpu .`\
`docker run -p 8000:8000 lyric-finder-sever-cpu [args]`

To build and run the CUDA supported image, run the following in `backend/`: \
`docker build -f CUDA.Dockerfile -t lyric-finder-sever-gpu .`\
`docker run --gpus all -p 8000:8000 lyric-finder-sever-gpu [args]`
