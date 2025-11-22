# Pseudo-static binaries for BlueBuild project

I made this, because we need utilities that would work everywhere accross any Linux distribution, like some `coreutils`, `sed`, `awk`, `curl` and `wget`.

Building statically linked packages is not so easy, so I resorted to unique method of building pseudo-static binaries.

Those pseudo-static binaries are built thanks to [`sharun`](https://github.com/VHSgunzo/sharun)'s wrappe feature, which bundles all libraries needed for the binary in a single executable.
