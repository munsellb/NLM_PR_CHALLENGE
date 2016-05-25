## NLM_PR_CHALLENGE

<h3> Table of contents </h3>
---
<ol>
<li><a href="https://github.com/munsellb/NLM_PR_CHALLENGE/blob/master/README.md#team">Team</a></li>
<li><a href="https://github.com/munsellb/NLM_PR_CHALLENGE/blob/master/README.md#os-and-software-requirements">Requirements</a></li>
<li><a href="https://github.com/munsellb/NLM_PR_CHALLENGE/blob/master/README.md#run-in-matlab">Run in Matlab</a></li>
<li><a href="https://github.com/munsellb/NLM_PR_CHALLENGE/blob/master/README.md#run-as-mcr-application">Run as MCR application</a></li>
<li><a href="https://github.com/munsellb/NLM_PR_CHALLENGE/blob/master/README.md#pipeline">Pipeline</a></li>
<ul>
<li><a href="https://github.com/munsellb/NLM_PR_CHALLENGE/blob/master/README.md#image-organization">Image Organization</a></li> 
<li><a href="https://github.com/munsellb/NLM_PR_CHALLENGE/blob/master/README.md#image-processing">Image Processing</a></li>
<li><a href="https://github.com/munsellb/NLM_PR_CHALLENGE/blob/master/README.md#classification">Classification</a></li>
<li><a href="https://github.com/munsellb/NLM_PR_CHALLENGE/blob/master/README.md#mr-generation">MR Generation</a></li>
</ul>
</ol>


<h3>Team</h3>
****
<b>Team Captain</b>: </br>
Nick Desisto (US Citizen, College of Charleston Student) </br>

<b>Team Captain Email Address</b>: </br>
desistonv@g.cofc.edu </br>

<b>Contact Information</b>: </br>
College of Charleston  </br>
Department of Computer Science  </br>
Harbor Walk East, Lab 105E  </br>
Charleston, SC. 29401  </br>
Phone 843.953.0428 </br>

<b>Team Members</b>:  </br>
Lucas Leandro Nesi (International Brazilian Student)  </br>
Leonardo De Melo Joao  (International Brazilian Student)  </br>

<h3>Requirements</h3>
****
Running natively in Matlab, version 2010b or greater is required.

Running as MCR application, the following are required:
<ul>
    <li>Linux (64-bit) OS is required (Tested on latest release of Ubuntu and Scientific Linux)</li>
    <li>MCR installer (http://munsellb.people.cofc.edu/matlab_mcr/MyAppInstaller_mcr.install)</li>
</ul>

Note: The MCR application (i.e. all the libraries required to run an instance of Matlab) will 
be installed in the /usr/local folder.

Basic installation steps:

1. Install the MCR libraries (see URL above)
2. Open a bash shell, cd into the NLM_PR_CHALLENGE directory, and create a symbolic link
```
ln -s ./exe/showmethepills.sh showmethepills.sh
```
3. Set the read/write/exeute bits as follows
```
chmod 775 ./exe/showmethepills.sh
```

<h3>Run in Matlab</h3>
****

Add the required files and folders to the Matlab path. From the matlab command prompt run
```
setmenv;
```
Note: this script is only executed once and must be done before any other script is executed! 
Otherwise, the remaining steps will produce file not found errors.

From the Matlab command prompt then run:
```
showmethepills( 'data/dr', 'data/dc' );
```
Where the first argument is the path (full or relative) to the directory that contains the 
reference pill images, and the second argument is the path to the directory that contains 
that consumer pill images. 

For more information about this script, type "help showmethepills" at the matlab command prompt.

<h3>Run as MCR Application</h3>
****
From the bash shell command prompt run the script:
```
showmethepills( 'data/dr', 'data/dc' );
```
Where the first argument is the path (full or relative) to the directory that contains the 
reference pill images, and the second argument is the path to the directory that contains 
that consumer pill images. 

For more information about this script, type "help showmethepills" at the matlab command prompt.
