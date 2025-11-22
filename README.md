# Pseudo-static binaries for the BlueBuild project

I made this, because we need utilities that would be portable and work everywhere accross any Linux distribution, like some `coreutils`, `sed`, `awk`, `curl` and `wget` tools.  
So everyone can benefit from this too.

Building statically linked packages is not so easy, so I resorted to the unique method of building pseudo-static binaries, which are generally just a bit, but still acceptably larger compared to true static binaries.

Those pseudo-static binaries are built thanks to [`sharun`](https://github.com/VHSgunzo/sharun)'s wrappe feature, which bundles all libraries needed for the binary in a single executable.  
We rely on Arch packaging of these, which is good and fast, so we always get the latest version of everything.

Binaries are automatically built every day.
