# Starter NES Project

This is a starter NES skeleton, containing the minimal amount of code that is useful for building a new project.

Depends on [makechr](http://github.com/dustmop/makechr) for building the graphics data.

Depends on [ca65 and ld65](http://cc65.github.io/cc65/) to assemble and link.

Depends on python in order to create debugging info. You can remove this dependency by removing the call to python in the Makefile.

Functions include:
* Initialization code
* Graphics loading
* Controller reading
* Frame synchronization
* Basic NMI

To build, run `make`, which produces starter.nes.

To clean, run `make clean`, which removes the build directory ".b/"
