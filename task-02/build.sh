#!/bin/bash

find src -name *.java -print > sourcelist.txt
javac @sourcelist.txt -XDignore.symbol.file -d classes
rm sourcelist.txt
