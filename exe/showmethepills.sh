#!/bin/bash

cp ./exe/showmethepills ./exe/showmethepills_bu

((git pull) && (rm ./exe/showmethepills_bu)) || (mv ./exe/showmethepills_bu ./exe/showmethepills)

chmod 775 ./exe/showmethepills

./exe/run_matlab.sh /usr/local/MATLAB/MATLAB_Compiler_Runtime/v83 $1 $2

