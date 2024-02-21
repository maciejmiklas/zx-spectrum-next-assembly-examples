#!/bin/bash

# Name of the program for compilation
EXAMPLE_NAME=009-show_sprites.asm

SD_CARD=/dev/disk6
CP_FROM=bin/project.nex 
CP_TO=/Volumes/ZX_NEXT/home/DEV/prj/test_asm/project.nex
SJASMPLUS=/Users/mmiklas/Development/ZX_Spectrum/opt/sjasmplus/sjasmplus 
set -e

echo "Compiling $EXAMPLE_NAME into bin"

$SJASMPLUS src/$EXAMPLE_NAME --lst=bin/project.lst --zxnext=cspectpwd --outprefix=bin/

#read -p "Copy to SD card ? (Y/n)?" -n 1 -r
#echo
#if [[ $REPLY =~ ^[Nn]$ ]]
#then
#    echo Skipping
#else
    cp -v $CP_FROM $CP_TO
    diskutil unmountDisk $SD_CARD
    diskutil eject $SD_CARD
#fi

