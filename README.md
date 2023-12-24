# Lyric-Finder

This project allows a user to enter a song lyric and display a list of songs that contain that lyric.

The frontend is written in React and TypeScript and uses the [Mantine](https://mantine.dev) component library.

The backend is written in C++20 and CUDA and is built using CMake. The application is served using the [oat++](https://oatpp.io) web framework.

## Search Engine implementations

This project was originally written to explore the use of parallelization in improving the map-reduce paradigm. The backend can be initialized using one of three search-engines: a sequential, cpu implementation, a thread-parallel implementation that uses STL threads, and a CUDA implementation.

When tested on a standard Ubuntu Linux desktop workstation, the CUDA implementation is the fastest (and most consistent performer) followed by the STL thread-parallel implementation. The sequential implementation is understandably last.

## Building and running the application

Lyric-Finder is built using CMake. Use docker to build and run the application.

The `lyric-finder-server` executable supports the following command line arguments: \
| Argument | Description |
| -------- | ----------- |
| `-g` | Selects the CUDA search engine if available. |
| `-t [number]` | Number of threads to use for the STL thread-parallel search engine. 0 uses a sequential implementation with no threads. |

### In Docker

To use build the appropriate docker image and run, use the instructions below. Note, the server runs on port 8000:

To build and run the cpu-only image, run the following in the root directory: \
`docker build -f CPU.Dockerfile -t lyric-finder-sever-cpu .`\
`docker run -p 8000:8000 lyric-finder-sever-cpu [args]`

To build and run the CUDA supported image, run the following in `backend/`: \
`docker build -f CUDA.Dockerfile -t lyric-finder-sever-gpu .`\
`docker run --gpus all -p 8000:8000 lyric-finder-sever-gpu [args]`
