# Linux aarch32 Project

The following repository is a collection of "mini" projects written entirely in 32-bit arm assembly using only linux kernel calls. That's right, pure A32 assembly and NO C standard library. Just assembly and kernel calls! :)

## Project organization

The prject is layed out quite simple. The root directory contains a bunch of folders. These folders in turn contain a "mini" project inside. Fully self contained.
Each project contains all the src files and a make file to build/run/debug the given project. While I don't intend on making drastic modifications to the makefile, the core of them shoudl still be the same (i.e. same required build tools, etc).

The current projects are as follow:

1) itoa
    - description
3) factorial
    - description
4) todo
    - description

## General requirements

Out of the box the following build tools are expected to be installed:

- gdb-multiarch
    - OPTIONAL, used for debugging
- gef
    - OPTIONAL, assumed to be installed when debugging, can be changed via USING_GEF flag in makefile
- arm-none-linux-gnueabihf-as
    - REQUIRED
- arm-none-linux-gnueabihf-ld
    - REQUIRED
- arm-none-linux-gnueabihf-objcopy
    - OPTIONAL
- qemu-arm
    - REQUIRED
 
The above packages are what the makefile is expecting out of the box and accessible in path. However, these tools can be swapped and replaced with equivalent ones vie modifications to the makefile tool variables.

## General commands

Below are the commands that will generally work with the make file. Make sure to see the projects readme and makefile for more specific details for that particular project

`make`
    - description


`make run`
    - description


`make clean`
    - description


`make debug_server`
    - description


`make debug`
    - description


`make gef`
    - description


