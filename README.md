# MAGIC Forest External Libraries Installer

Install all prerequisite libraries for MagicForest.

```sh
cmake -B build -DCMAKE_INSTALL_PREFIX=~/lib_magic
cmake --build build
```

"~/lib_magic" is an arbitrary location to install all the MagicForest external libraries.

See [libraries.json](./cmake/libraries.json) for what versions/tags/branches are installed of each library.
