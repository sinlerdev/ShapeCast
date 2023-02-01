# ShapeCast

ShapeCast is a library that creates a set of offsets to cast multiple rays that mimic a specific shape- its optimized and our benchmarks yielded ~4us processing time (read the benchmarks folder).

### Features
1. Automatic Centering- The offsets that are created are optimized for centering.
2. Distancing between Points and Planes.
3. Depth Grid to allow you to make actual 3D shapes.
4. Custom raycaster functions.
5. A Fast visualizer packed with ShapeCast.

### Install

The recommended way to get ShapeCast is through Wally:
```toml
[dependencies]
ShapeCast = "sinlerdev/shapecast@X.X.X -- X is the version you want to install
```

If you don't want to use Wally, you can either grab the source code from the github release you wish for rojo usage, or the rbxm for Studio usage.