# Parallel-Lyric-Finder

Parallel-Lyric-Finder is a full-stack web application that allows users to search for songs containing a particular lyric. 

The front end is written in React and TypeScript and uses the [Mantine](https://mantine.dev/getting-started/) component library. 

The backend is written in C++20 and CUDA and is built using CMake. The application is served using the [oat++](https://oatpp.io) web framework. 

The underlying database of songs was scraped from [lyricsdepot](http://www.lyricsdepot.com) using ScraPy + some additional postprocessing. It's stored as a JSON lines file and loaded into an in-memory database. The database contains 300,000+ songs.

## Demo

https://github.com/abhinavchadaga/lyric-finder/assets/48454518/5327195a-d69d-4eb8-831e-42a911aaef33

## Search Engine implementations

This project was originally written to explore the use of parallelization in improving the map-reduce paradigm. The backend can be initialized using one of three search-engines: a sequential, cpu implementation, a thread-parallel implementation that uses STL threads, and a CUDA implementation.

When tested on a standard Ubuntu Linux desktop workstation, the CUDA implementation is the fastest (and most consistent performer) followed by the STL thread-parallel implementation. The sequential implementation is understandably last.

## Building and running the application

Parallel-Lyric-Finder is built using CMake. Use docker to build and run the application.

The `lyric-finder-server` executable supports the following command line arguments: \
| Argument | Description |
| -------- | ----------- |
| `-g` | Selects the CUDA search engine if available. |
| `-t [number]` | Number of threads to use for the STL thread-parallel search engine. 0 uses a sequential implementation with no threads. |

### In Docker

To use build the appropriate docker image and run, use the instructions below. Note, the server runs on port 8000:

To pull and run the cpu-only image: \
`docker pull abhinavchadaga/parallel-lyric-finder:cpu-ubuntu2204`\
`docker run -p 8000:8000 abhinavchadaga/parallel-lyric-finder:cpu-ubuntu2204 [args]`

To pull and run the CUDA supported image: \
`docker pull abhinavchadaga/parallel-lyric-finder:cuda-11.7`\
`docker run --gpus all -p 8000:8000 abhinavchadaga/parallel-lyric-finder:cuda-11.7 [args]`
