# A Quick Overview

## Requirments / Assumptions

This makefile uses qemu to run the program and gdb-multiarch to debug it.
These settings along with other flags can be changed in the Makefile.
If you do not have GEF installed simply set the `USING_GEF` var to `0`.

## Make Commands

To build the project simple type `make` in the parent directory.

To build and run type `make run`. This will build and run the program.

To debug the program type `make debug_server`. This will launch qemu in debug mode on port 4242.
Next, open a new terminal and type `make debug`. This will launch gdb as sudo (if gef is enabled) and connect to qemu automatically.
If gef is enabled and you would like to use it type `make gef`. You can disable gef my setting the var `USING_GEF = 0`. This removes the `make gef` target and removes sudo from the the `debug` target.

To clean type `make clean`.
