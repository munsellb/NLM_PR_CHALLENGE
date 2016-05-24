#!/bin/bash

(git pull) && (rm ./exe/showmethepills)

chmod 775 ./exe/showmethepills

./exe/run_matlab.sh /usr/local/MATLAB/MATLAB_Compiler_Runtime/v83

