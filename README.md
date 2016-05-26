## NLM_PR_CHALLENGE

<h3> Table of contents </h3>
---
<ol>
<li><a href="https://github.com/munsellb/NLM_PR_CHALLENGE/blob/master/README.md#team">Team</a></li>
<li><a href="https://github.com/munsellb/NLM_PR_CHALLENGE/blob/master/README.md#requirements">Requirements</a></li>
<li><a href="https://github.com/munsellb/NLM_PR_CHALLENGE/blob/master/README.md#install-steps">Install Steps</a></li>
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
<b>Team Name</b>: </br>
ShowMeThePills </br>

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

<b>GitHub</b> </br>
https://github.com/munsellb/NLM_PR_CHALLENGE

<h3>Requirements</h3>
****

Run natively in Matlab, version 2010b or greater is required.

Run as MCR application, the following are required:
<ul>
    <li>Linux (64-bit) OS is required (Tested on latest release of Ubuntu and Scientific Linux)</li>
    <li>MCR installer (http://munsellb.people.cofc.edu/matlab_mcr/MyAppInstaller_mcr.install)</li>
</ul>

Note: The MCR application (i.e. all the libraries required 
to run an instance of Matlab) will be installed in the /usr/local 
folder.

<h3>Install Steps</h3>
****
Basic installation Steps to run as MCR application.

First install the MCR libraries (see URL above), then open 
a bash shell and cd into the NLM_PR_CHALLENGE directory, 
and create a symbolic link
```
ln -s ./exe/showmethepills.sh showmethepills.sh
```
Lastly, set the read/write/exeute bits as follows
```
chmod 775 ./exe/showmethepills.sh
```

<h3>Run in Matlab</h3>
****

Add the required files and folders to the Matlab path. 
From the matlab command prompt run
```
setmenv;
```
Note: this script is only executed once and must be done 
before any other script is executed! Otherwise, the remaining 
steps will produce file not found errors.

From the Matlab command prompt then run:
```
showmethepills( 'data/dr', 'data/dc' );
```
Where the first argument is the path (full or relative) 
to the directory that contains the reference pill images, 
and the second argument is the path to the directory that 
contains that consumer pill images. 

For more information about this script, type "help showmethepills" 
at the matlab command prompt.

<h3>Run as MCR Application</h3>
****
From the bash shell command prompt run the script:
```
./showmethepills.sh 'NLM_PR_CHALLENGE/data/dr' 'NLM_PR_CHALLENGE/data/dc'
```
Where the first argument is the full path to the directory 
that contains the reference pill images, and the second argument 
is the path to the directory that contains that consumer pill 
images. The NLM_PR_CHALLENGE is the root folder of the project.


<h3>Pipeline</h3>
****

The basic algorithm/processing pipeline for our software 
application can be clearly seen in the showmethepills script 
shown below

```
fprintf('-----------------------------------------------\n');
fprintf('[Step 1]: Executing Application\n');

fprintf('[Step 2]: Organizing the reference pill images\n');
orgImgs( 'DR', ref_dir, 'proc' );

fprintf('[Step 2]: Organizing the consumer pill images\n');
orgImgs( 'DC', con_dir, 'proc' );

fprintf('[Step 3]: Processing the reference pill images\n');
procImgs('DR','proc');

fprintf('[Step 3]: Processing the consumer pill images\n');
procImgs('DC','proc');

opts.range = [1 5000];
opts.save_files = true;
opts.href = 1;

fprintf('[Step 4]: Performing pill classification\n');
classify( 'proc', 'DR', 'DC', opts );

fprintf('[Step 5]: Creating MR CSV file\n');
generateMR( 'proc', 'ShowMeThePills' );
```
The specific details of each processing steps 2 through 5 are provided below.

<h5>Image Organization</h5> 
```
%
%   Usage: orgImgs( type, data_dir, proc_dir )
%
%   Description: Organize reference (DC) or consumer (DC) pill images into 
%   directory hierachy. At the completion of the script, the processing directory 
%   will contain a separate directory that has provided the pill image. Additionally, 
%   a Matlab file (DC.mat or DR.mat) will be created that contains a cell, and each 
%   element in the cell defines a structure that has a "path" field and an "img" field. 
%   The path field is the fully qualified location of the pill folder (on the file system), 
%   and the img field has the full name of the image file (including file extension, 
%   such as ".jpg").
%
%   Return: Nothing
%
%   Arguments: 3 required arguments (both strings)
%              
%              type = DR or DC (only these two will be accepted, not case
%              sensitive)
%              data_dir = location of the original pill images.
%              proc_dir = location of processing directory on file system
%              (if the directory does not exist, it will be created).
%
%   Example usage:
%   
%               orgImgs( 'DC', 'data', 'proc' )
%
%
%
```
<h5>Image Processing</h5>
```
%
%   Usage: procImgs( type, proc_dir )
%
%   Description: Process reference (DC) or consumer (DC) pill images using 
%   directory hierachy created in orgImgs script. At the completion of the 
%	script, the files required to compute our three features (shape, text, 
%	will be created in the directory for each pill reference or consumer pill.
%
%   Return: Nothing
%
%   Arguments: 2 required arguments (both strings)
%              
%              type = DR or DC (only these two will be accepted, not case
%              sensitive)
%              proc_dir = location of processing directory on file system.
%
%   Example usage:
%   
%               procImgs( 'DC', 'proc' )
%
%	Note: The following files are created
%		1) mask_bI.jpg (binary mask that has the same resolution as RGB pill image)
%		2) mask_bW.jpg (square binary mask used to compute shape feature)
%		3) mask_RGB.jpg (square color mask used to compute text feature)
%		4) lcolor.png (square color image used to compute color feature)
%
%	
%
```

<h5>Classification</h5>
```
%
%   Usage: [ S, K, T ] = classify( proc_dir, ref, con )
%
%   Description: Compute the feature matrices for Shape (S),
%   Color (K), and Text (T). At completion of the script 
%   the three feature matrices will be stored in the proc_dir
%   with the following names: S.mat, T.mat, and K.mat.
%
%   Arguments (All Strings): 
%       (1) proc_dir = location of process directory
%       (2) ref = reference data set. Value can only be DR or DC
%       (3) con = consumer data set. Value can only be DR or DC
%
%   Return:
%       Feature matrices for shape, color and text. For each 
%       matrix the number of rows = number of consumer images
%       and the number of columns = number of reference images.
%       ( note: to combine: F = ( S + K + T )/3 )
%
%   Example:
%       [S,K,T] = classify( 'proc', 'DR', 'DC' );
%
%
%
```

<h5>MR Generation</h5>
```
%
%   Usage: generateMR( proc_dir, file_name )
%
%   Description: Creates the scoring matrix as defined by 
%   challenge (http://pir.nlm.nih.gov/challenge/)
%
%   Return: Nothing
%
%   Arguments: 2 required arguments (both strings)
%            	proc_dir = location of processing directory on file system.
%		file_name = name of the CSV file.
%
%   Example usage:
%   
%               generateMR( 'proc', 'showmethepills_MR.csv' )
%
%
```
